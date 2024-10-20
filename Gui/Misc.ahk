#Requires AutoHotkey v2.0


DestroyControlMethod1(hwnd, class_nn) {
    ; Method 1 uses WM_DESTROY and WM_NC_DESTROY
    SendMessage(0x0002, 0, 0, "ahk_id " hwnd)  ; WM_DESTROY
    SendMessage(0x0082, 0, 0, "ahk_id " hwnd)  ; WM_NCDESTROY
    static WinSet := WinSet  ; Declare WinSet as a global function
    WinSet("Redraw", "ahk_id " hwnd)
}

DestroyControlMethod2(hwnd, class_nn) {
    ; Method 2 uses WM_CLOSE
    SendMessage(0x10, 0, 0, "ahk_id " hwnd)  ; WM_CLOSE
}