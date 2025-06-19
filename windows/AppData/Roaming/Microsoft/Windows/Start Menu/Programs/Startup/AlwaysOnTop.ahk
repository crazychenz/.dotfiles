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

; Windows key passthroughs (with Blind modifier)
#1::Send("{Blind}{#1}")
#2::Send("{Blind}{#2}")
#3::Send("{Blind}{#3}")
#4::Send("{Blind}{#4}")
#5::Send("{Blind}{#5}")
#6::Send("{Blind}{#6}")
#7::Send("{Blind}{#7}")
#8::Send("{Blind}{#8}")
#9::Send("{Blind}{#9}")

#v::Send("{Blind}{#v}")
#t::Send("{Blind}{#t}")
#m::Send("{Blind}{#m}")
#f::Send("{Blind}{#f}")
#Enter::Send("{Blind}{#Enter}")

#Left::Send("{Blind}{#Left}")
#Right::Send("{Blind}{#Right}")
#Up::Send("{Blind}{#Up}")
#Down::Send("{Blind}{#Down}")

#+1::Send("{Blind}{#+1}")
#+2::Send("{Blind}{#+2}")
#+3::Send("{Blind}{#+3}")
#+4::Send("{Blind}{#+4}")
#+5::Send("{Blind}{#+5}")
#+6::Send("{Blind}{#+6}")
#+7::Send("{Blind}{#+7}")
#+8::Send("{Blind}{#+8}")
#+9::Send("{Blind}{#+9}")

#+e::Send("{Blind}{#+e}")
;#+r::Send("{Blind}{#+r}")
#+w::Send("{Blind}{#+w}")
#+q::Send("{Blind}{#+q}")
#+c::Send("{Blind}{#+c}")
#+p::Send("{Blind}{#+p}")
#+b::Send("{Blind}{#+b}")

#+Left::Send("{Blind}{#+Left}")
#+Right::Send("{Blind}{#+Right}")
#+Up::Send("{Blind}{#+Up}")
#+Down::Send("{Blind}{#+Down}")

#^Left::Send("{Blind}{#^Left}")
#^Right::Send("{Blind}{#^Right}")
#^Up::Send("{Blind}{#^Up}")
#^Down::Send("{Blind}{#^Down}")

; F1: toggle or launch "Mockey"
#F1::
{
    DetectHiddenWindows(true)
    winTitle := "Mockey"
    appPath := "F:\godot_projects\mockey\Mockey.exe"

    if WinExist(winTitle)
    {
        if WinActive(winTitle) {
            WinHide(winTitle)
            WinActivate("ahk_class Progman")
        }
        else {
            WinShow(winTitle)
            WinActivate(winTitle)
        }
    }
    else
    {
        Run(appPath)
    }
}

#+r::  ; Win + Shift + R
{
    processName := "glazewm.exe"
    exePath := "C:\Program Files\glzr.io\GlazeWM\glazewm.exe"

    ; Kill the process
    ProcessClose(processName)

    ; Optional: Wait until it fully exits
    Loop
    {
        if !ProcessExist(processName)
            break
        Sleep(200)
    }

    ; Restart the process
    Run exePath

    return
}

