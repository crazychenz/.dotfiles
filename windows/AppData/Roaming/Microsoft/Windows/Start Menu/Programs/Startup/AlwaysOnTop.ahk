#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^6:: Winset, Alwaysontop, , A
return

;f16:: MsgBox, Here I am

;f16::SoundSet, -5
;f17::SoundSet, +5

f16::Send {Volume_Down}
return

f17::Send {Volume_Up}
return

f18::Send {Volume_Mute}
return

f19::Send {Media_Play_Pause}
return

MButton::
    holdTime := 300 ; 1000ms = 1 second
    MouseDownTime := A_TickCount
    while GetKeyState("MButton", "P")
    {
        Sleep, 10
    }

    if (A_TickCount - MouseDownTime < holdTime)
    {
        Send, {MButton}
    }
    else
    {
        Send, {Enter}
    }
return


;{Media_Next}
;{Media_Prev}

#1::SendInput {Blind}{#1}
#2::SendEvent {Blind}{#2}
#3::SendPlay {Blind}{#3}
#4::Send {Blind}{#4}
#5::Send {Blind}{#5}
#6::Send {Blind}{#6}
#7::Send {Blind}{#7}
#8::Send {Blind}{#8}
#9::Send {Blind}{#9}
#Left::Send {Blind}{#Left}
#Right::Send {Blind}{#Right}
#Up::Send {Blind}{#Up}
#Down::Send {Blind}{#Down}
#+Left::Send {Blind}{#+Left}
#+Right::Send {Blind}{#+Right}
#+Up::Send {Blind}{#+Up}
#+Down::Send {Blind}{#+Down}
#^Left::Send {Blind}{#^Left}
#^Right::Send {Blind}{#^Right}
#^Up::Send {Blind}{#^Up}
#^Down::Send {Blind}{#^Down}
