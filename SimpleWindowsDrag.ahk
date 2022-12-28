#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance Force

Menu, Tray, Icon, imageres.dll, 262 ; makes the icon into two window


;    ------------------------------
;  ----------------------------------
; ------- Simple Window Drag ---------
;  ----------------------------------
;    ------------------------------
; 
; version : 1.0.0
;
; -> Script by Tomé Sulmont (tome.sulmont@laposte.net)
; 
; Includes modified versions of :
; 	- Easy Window Dragging KDE style - by Jonny
; 	- Middle Mouse Button Gestures (diagonal) - by Drozdman
;	- Hyper Window Snap - by Andrew Moore and Jeff Axelrod
; 
; https://www.autohotkey.com
; 
; The goal with this script is to easily snap, move and resize windows with a single 
; key press and a mouse :
;   1) Hold down the F14 key and LEFT-click anywhere inside a window to drag it to 
;   a new location.
; 	2) Hold down F14 and RIGHT-click-drag anywhere inside a window to easily resize it.
;   3) Hold down F14 and MIDDLE-click-drag to perform different actions : maximize, 
;   always on top or snap a window.
; 	4) Hold down F14 and MIDDLE-click without moving to minimize the window under 
;   the mouse cursor.
;
; Shortcuts :
;  F14 + Left Button   + Drag					    : Move a window.
;  F14 + Right Button  + Drag						: Resize a window.
;  F14 + Middle Button + Drag Up					: Maximize/Restore a window.
;  F14 + Middle Button + Drag Down 					: Always On Top a window.
;  F14 + Middle Button + Drag Right 				: Snap to the Right half.
;  F14 + Middle Button + Drag Left 					: Snap to the Left half.
;  F14 + Middle Button + Drag Top Right Corner 		: Snap to the Top-Right quarter. 
;  F14 + Middle Button + Drag Top Left Corner 		: Snap to the Top-Left quarter.
;  F14 + Middle Button + Drag Bottom Right Corner 	: Snap to Bottom-Right quarter.
;  F14 + Middle Button + Drag Bottom Left Corner 	: Snap to the Bottom-Left quarter.
;  F14 + Middle Button + Motionless 				: Minimize a window.
;  F14 + Numpad                                     : Snap the active window.
;
; In my case, F14 is remapped to Caps Lock with PowerToy (because "Capslock::f14" doesn't work)


If (A_AhkVersion < "1.0.39.00")
{
    MsgBox,20,,This script may not work properly with your version of AutoHotkey. Continue?
    IfMsgBox, No
    ExitApp
}



; ----------------------------
; --- Easy Window Dragging ---
; ----------------------------

; This is the setting that runs smoothest on my system. 
; Depending on your video card and cpu power, 
; you may want to raise or lower this value.
SetWinDelay,2

CoordMode,Mouse
return

f14 & LButton:: ; F14 + Left Button
MouseGetPos,,,KDE_id ; Get the window id
; Abort if it's the desktop.
WinGetClass, ClassWin, ahk_id %KDE_id%
If ClassWin = WorkerW 
	return
; If the window is maximized, restore the initial position 
; and size of the window and center the mouse.
WinGet,KDE_Win, MinMax,ahk_id %KDE_id%
If KDE_Win
{
	WinRestore,ahk_id %KDE_id%
	WinGetPos,KDE_WinX1, KDE_WinY1, KDE_WinW, KDE_WinH, ahk_id %KDE_id%
	MouseMove,(KDE_WinX1 + (KDE_WinW / 2)), (KDE_WinY1 + (KDE_WinH / 2)), 0 
}

; Move the window.
MouseGetPos, KDE_X1, KDE_Y1
WinGetPos, KDE_WinX1, KDE_WinY1,,, ahk_id %KDE_id%
Loop
{
    GetKeyState, KDE_Button,LButton, P ; Break if button has been released.
    If KDE_Button = U
        break
    MouseGetPos, KDE_X2, KDE_Y2 ; Get the current mouse position.
    KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
    KDE_Y2 -= KDE_Y1
    KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
    KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
    WinMove, ahk_id %KDE_id%,, %KDE_WinX2%, %KDE_WinY2% ; Move the window to the new position.
}
return


f14 & RButton:: ; F14 + Right Button
; Get the mouse position and window id,
MouseGetPos, KDE_X1, KDE_Y1,KDE_id
; Abort if it's the desktop.
WinGetClass, ClassWin, ahk_id %KDE_id%
If ClassWin = WorkerW 
	return
; Abort if the window is maximized.
WinGet, KDE_Win, MinMax, ahk_id %KDE_id%
If KDE_Win
    return
; Get the initial window position and size.
WinGetPos, KDE_WinX1, KDE_WinY1, KDE_WinW, KDE_WinH, ahk_id %KDE_id%
; Define the window region the mouse is currently in.
; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
If (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
    KDE_WinLeft := 1
Else
    KDE_WinLeft := -1
If (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
    KDE_WinUp := 1
Else
    KDE_WinUp := -1
Loop
{
    GetKeyState, KDE_Button, RButton, P ; Break if button has been released.
    If KDE_Button = U
        break
    MouseGetPos, KDE_X2, KDE_Y2 ; Get the current mouse position.
    ; Get the current window position and size.
    WinGetPos, KDE_WinX1, KDE_WinY1, KDE_WinW, KDE_WinH, ahk_id %KDE_id%
    KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
    KDE_Y2 -= KDE_Y1
    ; Then, act according to the defined region.
    WinMove,ahk_id %KDE_id%,, KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2  ; X of resized window
                            , KDE_WinY1 +   (KDE_WinUp+1)/2*KDE_Y2  ; Y of resized window
                            , KDE_WinW  -     KDE_WinLeft  *KDE_X2  ; W of resized window
                            , KDE_WinH  -       KDE_WinUp  *KDE_Y2  ; H of resized window
    KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
    KDE_Y1 := (KDE_Y2 + KDE_Y1)
}
return



; -------------------------
; --- Hyper Window Snap ---
; -------------------------

SnapActiveWindow(winPlaceVertical, winPlaceHorizontal, winSizeHeight) {
    heightOffset := 7
    widthOffset := 15
    xOffset := 7
    
    activeWin := WinExist("A")
    activeMon := GetMonitorIndexFromWindow(activeWin)
		WinGet, MinMaxState, MinMax, A
		If (MinMaxState) {
			WinRestore, A
		}
	
    SysGet, MonitorWorkArea, MonitorWorkArea, %activeMon%

    if (winSizeHeight == "half") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)/2 + heightOffset
    } else if (winSizeHeight == "full") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop) + heightOffset
		} else if (winSizeHeight == "third") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)/3
    }

    if (winPlaceHorizontal == "left") {
        posX  := MonitorWorkAreaLeft - xOffset
        width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/2 + widthOffset
    } else if (winPlaceHorizontal == "right") {
        posX  := MonitorWorkAreaLeft + (MonitorWorkAreaRight - MonitorWorkAreaLeft)/2 - xOffset
        width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/2 + widthOffset
    } else {
        posX  := MonitorWorkAreaLeft - xOffset
        width := MonitorWorkAreaRight - MonitorWorkAreaLeft + widthOffset
    }

    if (winPlaceVertical == "bottom") {
        posY := MonitorWorkAreaBottom - height + heightOffset
    } else if (winPlaceVertical == "middle") {
        posY := MonitorWorkAreaTop + height
    } else {
        posY := MonitorWorkAreaTop
    }
	
    WinMove, A,, %posX%, %posY%, %width%, %height%
}

GetMonitorIndexFromWindow(windowHandle) {
    ; Starts with 1.
    monitorIndex := 1

    VarSetCapacity(monitorInfo, 40)
    NumPut(40, monitorInfo)

    if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2))
        && DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) {
        monitorLeft   := NumGet(monitorInfo,  4, "Int")
        monitorTop    := NumGet(monitorInfo,  8, "Int")
        monitorRight  := NumGet(monitorInfo, 12, "Int")
        monitorBottom := NumGet(monitorInfo, 16, "Int")
        workLeft      := NumGet(monitorInfo, 20, "Int")
        workTop       := NumGet(monitorInfo, 24, "Int")
        workRight     := NumGet(monitorInfo, 28, "Int")
        workBottom    := NumGet(monitorInfo, 32, "Int")
        isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

        SysGet, monitorCount, MonitorCount

        Loop, %monitorCount% {
            SysGet, tempMon, Monitor, %A_Index%

            ; Compare location to determine the monitor index.
            if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
                and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom)) {
                monitorIndex := A_Index
                break
            }
        }
    }

    return %monitorIndex%
}

; Win + Numpad = Snap to conrners for diagonals, or top, bottom, left, right of screen (Landscape)
f14 & Numpad7:: 
WinGetClass, ClassWin , A ; Abort if it's the desktop.
If ClassWin = WorkerW 
    return
SnapActiveWindow("top","left","half")
return
f14 & Numpad8::
WinGetClass, ClassWin , A ; Abort if it's the desktop.
If ClassWin = WorkerW 
    return
SnapActiveWindow("top","full","half")
return
f14 & Numpad9::
WinGetClass, ClassWin , A ; Abort if it's the desktop.
If ClassWin = WorkerW 
    return
SnapActiveWindow("top","right","half")
return
f14 & Numpad4::
WinGetClass, ClassWin , A ; Abort if it's the desktop.
If ClassWin = WorkerW 
    return
SnapActiveWindow("top","left","full")
return
f14 & Numpad6::
WinGetClass, ClassWin , A ; Abort if it's the desktop.
If ClassWin = WorkerW 
    return
SnapActiveWindow("top","right","full")
return
f14 & Numpad1::
WinGetClass, ClassWin , A ; Abort if it's the desktop.
If ClassWin = WorkerW 
    return
SnapActiveWindow("bottom","left","half")
return
f14 & Numpad2::
WinGetClass, ClassWin , A ; Abort if it's the desktop.
If ClassWin = WorkerW 
    return
SnapActiveWindow("bottom","full","half")
return
f14 & Numpad3::
WinGetClass, ClassWin , A ; Abort if it's the desktop.
If ClassWin = WorkerW 
    return
SnapActiveWindow("bottom","right","half")
return
f14 & Numpad5::
WinGetClass, ClassWin , A ; Abort if it's the desktop.
If ClassWin = WorkerW 
    return
WinGet,KDE_Win,MinMax, A
    If KDE_Win
        WinRestore, A
    Else
        WinMaximize, A
    Return
return



; ---------------------
; --- Mouse Gesture ---
; ---------------------

f14 & MButton:: ;  F14 + Middle Button
MouseGetPos, X1, Y1, KDE_id ; Get the window id
; Abort if it's the desktop.
WinGetClass, ClassWin , ahk_id %KDE_id% 
If ClassWin = WorkerW 
	return
SetTimer, MBGesture, 1
MinTime := 50 ; Set A_TimeSinceThisHotkey
LongTime := 200 ; Set A_TimeSinceThisHotkey to avoid hiting Gesture down by accident
Tolerance := 60 ; Tolerance of the gesture
Keywait MButton
if(A_TimeSinceThisHotkey>MinTime AND X2-X1>0 AND Y2-Y1<0 AND Abs(X2-X1) >= Tolerance AND Abs(Y2-Y1) >= Tolerance) {
	Goto GestureTR	; gesture top/right
}
else if(A_TimeSinceThisHotkey>MinTime AND X2-X1>0 AND Y2-Y1>0 AND Abs(X2-X1) >= Tolerance AND Abs(Y2-Y1) >= Tolerance) {
	Goto GestureDR	; gesture down/right
}
else if(A_TimeSinceThisHotkey>MinTime AND X2-X1<0 AND Y2-Y1<0 AND Abs(X2-X1) >= Tolerance AND Abs(Y2-Y1) >= Tolerance) {
	Goto GestureTL	; gesture top/left
}
else if(A_TimeSinceThisHotkey>MinTime AND X2-X1<0 AND Y2-Y1>0 AND Abs(X2-X1) >= Tolerance AND Abs(Y2-Y1) >= Tolerance) {
	Goto GestureDL	; gesture down/left
}
else if(A_TimeSinceThisHotkey>MinTime AND Y2-Y1< 0 AND Abs(Y2-Y1) >= Tolerance AND Abs(X2-X1) < Tolerance) {
	Goto GestureU	; gesture up
}
else if(A_TimeSinceThisHotkey>LongTime AND Y2-Y1>0 AND Abs(Y2-Y1) >= Tolerance AND Abs(X2-X1) < Tolerance) {
	Goto GestureD	; Gesture down
}
else if(A_TimeSinceThisHotkey>MinTime AND X2-X1<0 AND Abs(X2-X1) >= Tolerance AND Abs(Y2-Y1) < Tolerance) {
	Goto GestureL	; gesture left
}
else if(A_TimeSinceThisHotkey>MinTime AND X2-X1>0 AND Abs(X2-X1) >= Tolerance AND Abs(Y2-Y1) < Tolerance) {
	Goto GestureR	; gesture right
}
else if ((X1 = X2) and (Y1 = Y2)) {
	Goto NoMove		; gesture no move
}
MBGesture:
MouseGetPos, X2, Y2
return


; - Set actions - ; Add Title Id to diferanciate diferent multiple instances (explorer or chrome for exemple) ?

GestureTR:	; gesture top/right
	WinActivate, ahk_id %KDE_id% ; Activate the window
	SnapActiveWindow("top","right","half")
return

GestureDR:	; gesture down/right
	WinActivate, ahk_id %KDE_id% ; Activate the window
	SnapActiveWindow("bottom","right","half")
return

GestureTL:	; gesture top/left
	WinActivate, ahk_id %KDE_id% ; Activate the window
	SnapActiveWindow("top","left","half")
return

GestureDL:	; gesture down/left
	WinActivate, ahk_id %KDE_id% ; Activate the window
	SnapActiveWindow("bottom","left","half")
return

GestureU:	; gesture up
	; Toggle between maximized and restored state.
	WinGet, KDE_Win, MinMax, ahk_id %KDE_id%
	If KDE_Win
		WinRestore, ahk_id %KDE_id%
	Else
		WinMaximize, ahk_id %KDE_id%
	Return
return

GestureD:	; Gesture down
	WinActivate, KDE_id ; Activate the window
	WinSet, AlwaysOnTop, -1, ahk_id %KDE_id%	
return

GestureL:	; gesture left
	WinActivate, KDE_id ; Activate the window
	SnapActiveWindow("top","left","full")
return

GestureR:	; gesture right
	WinActivate, KDE_id ; Activate the window
	SnapActiveWindow("top","right","full")
return

NoMove:		; gesture no move
	WinMinimize, ahk_id %KDE_id% ; Minimize the window
return
