tbh. wrote this so long ago, can't really remember the thought behind it or how to use it. I will update when I have read up on it again in some of the scripts that is using it.


## Window & Page:

Window is used for the root of an AHK GUI. and Page is used for the individual pages it contains. It's kinda like a SPA Web application. It's probably not very memory efficient but I didn't create this for big elaborate AHK GUI applications. I created this to make it easier to use in my own small scripts.


Page is what is used inside the Window.

#### Example Usage:

```
class HomePage extends Page {
    __New(window:=false, name:="Home") {
        super.__New(window, name)

        ; this.AddElement("Text", "x15 y15 w100 h25 +0x200 -Background", "Tester123")
    }

    Init() {
        this.AddElement("Text", "x15 y15 w100 h25 +0x200 -Background", "Home")
    }

    Show() {
        super.Show()
    }
}


class InfoPage extends Page {
    __New(window:=false, name:="Info") {
        super.__New(window, name)
    }

    Init() {
        this.AddElement("Text", "x15 y15 w100 h25 +0x200 -Background", "Info")
    }

    Show() {
        super.Show()
    }
}

pageHome := HomePage()
pageInfo := InfoPage()
myGui := Window("GUI Example", "+Resize -MaximizeBox +MinSize500x +MaxSize500x", pageHome)
myGui.AddPage(InfoPage())
myGui.Show()
Sleep(2000)
myGui.ShowPage("Info")
```