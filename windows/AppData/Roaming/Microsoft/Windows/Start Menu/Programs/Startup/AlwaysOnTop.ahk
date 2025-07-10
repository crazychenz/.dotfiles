#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode("Input")
SetWorkingDir A_ScriptDir

^6:: WinSetAlwaysOnTop -1, "A"  ; Toggle always-on-top for active window

; Volume & media controls
F13::Send("{Volume_Down}")
F14::Send("{Volume_Up}")
F15::Send("{Media_Next}")
F16::Send("{Media_Play_Pause}")

; Middle mouse button short/long press behavior
MButton::
{
    holdTime := 300
    mouseDownTime := A_TickCount
    while GetKeyState("MButton", "P")
        Sleep(10)

    if (A_TickCount - mouseDownTime < holdTime)
        Send("{MButton}")
    else
        Send("{Enter}")
}

#l:: {
    DllCall("LockWorkStation")
}

; ------------------- Jump To Desktop ----------------------

; Hotkeys to jump to specific desktops (Win + Number)
#1::GoToDesktopNumber(1)
#2::GoToDesktopNumber(2)
#3::GoToDesktopNumber(3)
#4::GoToDesktopNumber(4)
#5::GoToDesktopNumber(5)
#6::GoToDesktopNumber(6)
#7::GoToDesktopNumber(7)
#8::GoToDesktopNumber(8)
#9::GoToDesktopNumber(9)

hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", "C:\bin\VirtualDesktopAccessor.dll", "Ptr")

GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GoToDesktopNumber", "Ptr")

GoToDesktopNumber(num) {
    global GoToDesktopNumberProc
    DllCall(GoToDesktopNumberProc, "Int", num-1, "Int")
    return
}

; ------------------- Navigate To Window ----------------------

; Note: Prefer no shift, but Fancyzones uses #Arrow to move window
#+Left:: NavigateWindow("left")
#+Down:: NavigateWindow("down")
#+Up:: NavigateWindow("up")
#+Right:: NavigateWindow("right")



NavigateWindow(direction) {
    ; Get current active window
    currentHwnd := WinGetID("A")
    
    ; Get position and size of current window
    WinGetPos(&currentX, &currentY, &currentW, &currentH, currentHwnd)
    currentCenterX := currentX + currentW // 2
    currentCenterY := currentY + currentH // 2
    
    ; Get all visible windows
    windows := GetVisibleWindows()
    
    ; Remove current window from candidates
    filteredWindows := []
    for window in windows {
        if (window.hwnd != currentHwnd)
            filteredWindows.Push(window)
    }
    
    if (filteredWindows.Length == 0)
        return
    
    ; Find the best window in the specified direction
    bestWindow := FindBestWindow(filteredWindows, currentCenterX, currentCenterY, direction)
    
    if (bestWindow != "") {
        ; Focus the target window
        WinActivate(bestWindow)
    }
}

GetVisibleWindows() {
    windows := []
    
    ; Enumerate all windows
    for hwnd in WinGetList() {
        ; Skip if window is not visible
        if (!WinGetMinMax(hwnd) && WinExist(hwnd)) {
            ; Get window position and size
            try {
                WinGetPos(&x, &y, &w, &h, hwnd)
                
                ; Skip windows that are too small (likely system windows)
                if (w < 100 || h < 100)
                    continue
                
                ; Skip windows that are off-screen
                if (x < -1000 || y < -1000)
                    continue
                
                ; Get window title
                title := WinGetTitle(hwnd)
                
                ; Skip windows without titles or with certain system titles
                if (title == "" || title == "Program Manager" || title == "Desktop")
                    continue
                
                ; Add to our list
                windows.Push({
                    hwnd: hwnd,
                    x: x,
                    y: y,
                    w: w,
                    h: h,
                    centerX: x + w // 2,
                    centerY: y + h // 2,
                    title: title
                })
            }
        }
    }
    
    return windows
}

FindBestWindow(windows, currentX, currentY, direction) {
    bestWindow := ""
    bestScore := 999999
    
    for window in windows {
        targetX := window.centerX
        targetY := window.centerY
        
        ; Calculate relative position
        deltaX := targetX - currentX
        deltaY := targetY - currentY
        
        ; Check if window is in the correct direction
        isValidDirection := false
        distance := 0
        
        switch direction {
            case "up":
                if (deltaY < -50) {  ; Window is above (with some tolerance)
                    isValidDirection := true
                    distance := Abs(deltaY) + Abs(deltaX) * 0.5  ; Prioritize vertical distance
                }
            case "down":
                if (deltaY > 50) {   ; Window is below
                    isValidDirection := true
                    distance := Abs(deltaY) + Abs(deltaX) * 0.5
                }
            case "left":
                if (deltaX < -50) {  ; Window is to the left
                    isValidDirection := true
                    distance := Abs(deltaX) + Abs(deltaY) * 0.5  ; Prioritize horizontal distance
                }
            case "right":
                if (deltaX > 50) {   ; Window is to the right
                    isValidDirection := true
                    distance := Abs(deltaX) + Abs(deltaY) * 0.5
                }
        }
        
        ; If this window is in the right direction and closer than our current best
        if (isValidDirection && distance < bestScore) {
            bestScore := distance
            bestWindow := window.hwnd
        }
    }
    
    return bestWindow
}





