#Requires AutoHotkey v2.0


#Include <Gui/Scrollable>
#Include <Gui/Page>
#Include <Map>
#Include <Array>


class Window extends Gui {
    __New(Title, Options, indexPage, params:={}) {
        super.__New(Options, Title)
        this.BaseTitle := Title
        this.Minimized := false
        this.Maximized := false
        windowX := 0, windowY := 0, windowWidth := 0, windowHeight := 0
        this.GetPos(&windowX, &windowY, &windowWidth, &windowHeight)

        this.OnEvent("Size", (args*) => this.OnSizeEvent(args*))
        this.OnEvent("Close", (args*) => this.Close(args*))
        ; this.OnEvent("Minimize", (*) => this.Minimize())
        OnMessage(0x0115, OnScroll) ; WM_VSCROLL
        OnMessage(0x0114, OnScroll) ; WM_HSCROLL
        OnMessage(0x020A, OnWheel)  ; WM_MOUSEWHEEL

        this.Pages := Map()
        this.Pages := []
        this.CurrentPage := Page(this)
        this.AddPage(indexPage)

        if (params.HasOwnProp("hidden")) {
            if (params.hidden == false) {
                this.Show()
            }
        }
        else {
            this.Show()
        }
        
        if (params.HasOwnProp("width") || params.HasOwnProp('height')) {
            this.Resize(params)
        }
    }

    ; Minimize() {
    ;     super.Minimize()
    ; }
    OnSizeEvent(args*) {
        ScrollGuiUpdate(args*)
        windowState := WinGetMinMax(this.Title)
        this.Minimized := windowState == -1 ? true : false
        this.Maximized := windowState == 1 ? true : false
        ; MyTip("Minimized: " this.Minimized)
    }

    Close(args*) {
        this.Pages.ForEach((page,key,map) => page.Exit())
        ExitApp()
    }

    Show() {
        if (this.CurrentPage.Name != ""){
            this.ShowPage()
        }
        super.Show()
    }

    Resize(params:={}) {
        windowX := 0, windowY := 0, windowWidth := 0, windowHeight := 0
        this.GetPos(&windowX, &windowY, &windowWidth, &windowHeight)
        screenWidth := SysGet(78), screenHeight := SysGet(79)
        ; Initialize the new window position and size
        newX := windowX, newY := windowY
        newWidth := params.HasOwnProp("width") ? params.width : windowWidth
        newHeight := params.HasOwnProp("height") ? params.height : windowHeight

        if (params.HasOwnProp("constrain") && params.constrain) {
            ; Check if the new width is greater than the screen width
            if (newWidth > screenWidth) {
                newX := 0  ; Set the left position to align with the left side of the screen
                newWidth := screenWidth  ; Limit the width to the screen width
            }
            ; Check if the right side of the window goes beyond the screen's width
            else if (windowX + newWidth > screenWidth) {
                newX := screenWidth - newWidth  ; Move the window to the left so the right side aligns with the screen
            }
            
            ; Check if the new height is greater than the screen height
            if (newHeight > screenHeight) {
                newY := 0  ; Set the top position to align with the top of the screen
                newHeight := screenHeight  ; Limit the height to the screen height
            }
            ; Check if the bottom of the window goes below the screen's maximum height
            else if (windowY + newHeight > screenHeight) {
                newY := screenHeight - newHeight  ; Move the window up so the bottom aligns with the screen
            }
        }

        ; Resize and move the window
        this.Move(newX, newY, newWidth, newHeight)
    }

    AddPage(page) {
        page.SetWindow(this)
        page.Init()
        ; this.Pages[page.Name] := page
        this.Pages.Push(page)
        if (this.CurrentPage.Name == "") { ; 1st page being added
            this.CurrentPage := page
            this.ShowPage()
        }
    }

    ClearWindow() {
        if (this.CurrentPage.Name != ""){
            this.CurrentPage.Hide()
        }
    }

    ShowPage(name:=this.CurrentPage.Name) {
        ; pageToShow := this.Pages.Get(name)
        foundIndex := this.Pages.Find((v) => v.Name == name, &pageToShow)
        if (!foundIndex) {
            MsgBox("Page " name " can't be found")
            return false
        }
        
        this.ClearWindow()
        this.CurrentPage := pageToShow
        this.CurrentPage.Show()
        this.Title := this.BaseTitle " - " name
    }

    RemovePage(name) {
        foundIndex := this.Pages.Find((v) => v.Name == name, &pageToRemove)
        if (!foundIndex) {
            MsgBox("Page " name " can't be found")
            return false
        }
        pageToRemove.Hide() ; Hides controls from window
        this.Pages.RemoveAt(foundIndex)
    }
}