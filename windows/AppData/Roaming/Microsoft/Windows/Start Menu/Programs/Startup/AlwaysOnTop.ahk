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

; Windows key passthroughs (with Blind modifier)
;#1::Send("{Blind}{#1}")
;#2::Send("{Blind}{#2}")
;#3::Send("{Blind}{#3}")
;#4::Send("{Blind}{#4}")
;#5::Send("{Blind}{#5}")
;#6::Send("{Blind}{#6}")
;#7::Send("{Blind}{#7}")
;#8::Send("{Blind}{#8}")
;#9::Send("{Blind}{#9}")

;#v::Send("{Blind}{#v}")
;#t::Send("{Blind}{#t}")
;#m::Send("{Blind}{#m}")
;#f::Send("{Blind}{#f}")
;#Enter::Send("{Blind}{#Enter}")

;#Left::Send("{Blind}{#Left}")
;#Right::Send("{Blind}{#Right}")
;#Up::Send("{Blind}{#Up}")
;#Down::Send("{Blind}{#Down}")

;#+1::Send("{Blind}{#+1}")
;#+2::Send("{Blind}{#+2}")
;#+3::Send("{Blind}{#+3}")
;#+4::Send("{Blind}{#+4}")
;#+5::Send("{Blind}{#+5}")
;#+6::Send("{Blind}{#+6}")
;#+7::Send("{Blind}{#+7}")
;#+8::Send("{Blind}{#+8}")
;#+9::Send("{Blind}{#+9}")

;#+e::Send("{Blind}{#+e}")
;;#+r::Send("{Blind}{#+r}")
;#+w::Send("{Blind}{#+w}")
;#+q::Send("{Blind}{#+q}")
;#+c::Send("{Blind}{#+c}")
;#+p::Send("{Blind}{#+p}")
;#+b::Send("{Blind}{#+b}")

;#+Left::Send("{Blind}{#+Left}")
;#+Right::Send("{Blind}{#+Right}")
;#+Up::Send("{Blind}{#+Up}")
;#+Down::Send("{Blind}{#+Down}")

;#^Left::Send("{Blind}{#^Left}")
;#^Right::Send("{Blind}{#^Right}")
;#^Up::Send("{Blind}{#^Up}")
;#^Down::Send("{Blind}{#^Down}")

; F1: toggle or launch "Mockey"
;#F1::
;{
;    DetectHiddenWindows(true)
;    winTitle := "Mockey"
;    appPath := "F:\godot_projects\mockey\Mockey.exe"
;
;    if WinExist(winTitle)
;    {
;        if WinActive(winTitle) {
;            WinHide(winTitle)
;            WinActivate("ahk_class Progman")
;        }
;        else {
;            WinShow(winTitle)
;            WinActivate(winTitle)
;        }
;    }
;    else
;    {
;        Run(appPath)
;    }
;}

;#+r::  ; Win + Shift + R
;{
;    ; processName := "glazewm.exe"
;    ; exePath := "C:\Program Files\glzr.io\GlazeWM\glazewm.exe"
;	processName := "Whim.Runner.exe"
;	exePath := "C:\Users\agrie\AppData\Local\Programs\Whim\Whim.Runner.exe"
;
;    ; Kill the process
;    ProcessClose(processName)
;
;    ; Optional: Wait until it fully exits
;    Loop
;    {
;        if !ProcessExist(processName)
;            break
;        Sleep(200)
;    }
;
;    ; Restart the process
;    Run exePath
;
;    return
;}

; ------------------- Recover Hidden Window (Hack) ----------------------

A_TrayMenu.Add("Recover Hidden Window", RecoverHiddenWindow)
RecoverHiddenWindow(*) {
  ;MsgBox("About to show InputBox...")
  result := InputBox("Identifier (ahk_pid ARG or ahk_exe ARG or TITLE):", "Show Window")
  ;MsgBox("InputBox done.")
  if (result.Result == "OK" && result.Value != "") {
    ;if WinExist(result.Value) {
	  WinShow(result.Value)
	  WinActivate(result.Value)
	  WinRestore(result.Value)
	;}
  }
}

; ------------------- Navigate To Window ----------------------

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


; ------------------- Jump To Desktop ----------------------

hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", "C:\bin\VirtualDesktopAccessor.dll", "Ptr")

GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GoToDesktopNumber", "Ptr")

GoToDesktopNumber(num) {
    global GoToDesktopNumberProc
    DllCall(GoToDesktopNumberProc, "Int", num-1, "Int")
    return
}

; Hotkeys to jump to specific desktops (Win + Number)
#1::GoToDesktopNumber(1)  ; Win + 1 = Desktop 1
#2::GoToDesktopNumber(2)  ; Win + 2 = Desktop 2  
#3::GoToDesktopNumber(3)  ; Win + 3 = Desktop 3
#4::GoToDesktopNumber(4)  ; Win + 4 = Desktop 4
#5::GoToDesktopNumber(5)  ; Win + 5 = Desktop 5
#6::GoToDesktopNumber(6)  ; Win + 6 = Desktop 6
#7::GoToDesktopNumber(7)  ; Win + 7 = Desktop 7
#8::GoToDesktopNumber(8)  ; Win + 8 = Desktop 8
#9::GoToDesktopNumber(9)  ; Win + 9 = Desktop 9


