#Requires AutoHotkey v2.0

#Include <Array>
#Include <Gui/Misc>

class Page  {
    __New(window:=false, name:="") {
        this.Window := window
        this.Name := name
        this.Visible := false

        this.Elements := []
    }

    Init() {

    }
    Exit() {
        return ""
    }

    SetWindow(window) {
        this.Window := window
    }

    Show() {
        this.Visible := true
        for (key, el in this.Elements) {
            el.Visible := true
            el.Enabled := true
        }
        this.Update()
    }

    Update() {

    }

    Hide() {
        this.Visible := false
        for (key, el in this.Elements) {
            el.Visible := false
            el.Enabled := false
        }
    }

    Redraw() {
        for (key, el in this.Elements) {
            el.Redraw()
        }
    }

    ; Remove() {
    ;     for (key, el in this.Elements) {
    ;         el.Delete()
    ;     }
    ; }

    AddElement(controlType, optStr, params:={}) {
        if (this.Window == false) {
            MsgBox("Error Adding Element: Window Not Set")
            return
        }

        if (params.HasOwnProp('text')) {
            element := this.Window.Add(controlType, optStr, params.text)
        }
        else if (params.HasOwnProp('content')) {
            element := this.Window.Add(controlType, optStr, params.content)
            if (params.content.Length > 0) {
                element.Choose(1)
            }
        }
        else if (params.HasOwnProp('path')) {
            element := this.Window.Add(controlType, optStr, params.path)
        }
        else {
            element := this.Window.Add(controlType, optStr)
        }

        if (params.HasOwnProp('font')) {
            element.SetFont(params.font)
        }


        if (params.HasOwnProp('eventName') && params.HasOwnProp('cb')) {
            element.OnEvent(params.eventName, ObjBindMethod(this, params.cb))
        }
        
        if (params.HasOwnProp('name')) {
            element.Name := params.name
        }

        if (params.HasOwnProp('value')) {
            element.Value := params.value
        }

        element.Visible := false
        element.Enabled := false

        this.Elements.Push(element)
        return element
    }

    ; RemoveElement(name) {
    ;     foundIndex := this.Elements.Find((v) => v.Name == name, &match)
    ;     if (foundIndex) {
    ;         ; Get the class name of the control
    ;         class_nn := WinGetClass("ahk_id " match.Hwnd)
    ;         MyTip("Found: " foundIndex)

    ;         ; Check the control type and call the appropriate destruction method
    ;         if (InStr(class_nn, "SysTabControl") != 0
    ;             || InStr(class_nn, "ListBox") != 0
    ;             || InStr(class_nn, "SysListView32") != 0
    ;             || InStr(class_nn, "msctls_progress32") != 0
    ;             || InStr(class_nn, "Edit") != 0) {
    ;             DestroyControlMethod2(match.Hwnd, class_nn)
    ;         } else {
    ;             DestroyControlMethod1(match.Hwnd, class_nn)
    ;         }

    ;         ; Remove the element from the Elements map
    ;         this.Elements.RemoveAt(foundIndex)
    ;     } 
    ;     else {
    ;         MsgBox("Error: No element with the name '" name "' found!")
    ;     }
    ; }

    GetElement(name) {
        foundIndex := this.Elements.Find((v) => v.Name == name, &match)
        return foundIndex ? match : false
    }
}
