#Requires AutoHotkey v2.0

SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
#SingleInstance Force
TraySetIcon "imageres.dll", 143 ; makes the icon into two window


; Simple Window Drag 
; --------------------------------------------------
; version : 2.0.0
; -> Script by Tomé Sulmont (tome.sulmont@laposte.net)
; Thank's to the folks at the AHK forum for converting it to V2 and adding new features.
;
; Includes modified versions of :
; 	- Easy Window Dragging KDE style - by Jonny
; 	- Middle Mouse Button Gestures (diagonal) - by Drozdman
;	- Hyper Window Snap - by Andrew Moore and Jeff Axelrod
;
; https://www.autohotkey.com
;
; The goal with this script is to easily snap, move and resize windows with a single key press and a mouse :
;   1) Hold down the LWin key and LEFT-click anywhere inside a window to drag it to a new location.
; 	2) Hold down LWin and RIGHT-click-drag inside a window to easily resize it.
;   3) Hold down LWin and MIDDLE-click-drag to perform different actions : maximize, always on top or snap a window.
; 	4) Hold down LWin and MIDDLE-click without moving to minimize the window under the mouse cursor.
;
; Shortcuts :
;  LWin + Left Button   + Drag					    : Move a window.
;  LWin + Right Button  + Drag						: Resize a window.
;  LWin + Middle Button + Drag Up					: Maximize/Restore a window.
;  LWin + Middle Button + Drag Down 				: Always On Top a window.
;  LWin + Middle Button + Drag Right 				: Snap to the Right half.
;  LWin + Middle Button + Drag Left 				: Snap to the Left half.
;  LWin + Middle Button + Drag Top Right Corner 	: Snap to the Top-Right quarter.
;  LWin + Middle Button + Drag Top Left Corner 		: Snap to the Top-Left quarter.
;  LWin + Middle Button + Drag Bottom Right Corner 	: Snap to Bottom-Right quarter.
;  LWin + Middle Button + Drag Bottom Left Corner 	: Snap to the Bottom-Left quarter.
;  LWin + Middle Button + Motionless 				: Minimize a window.
;  LWin + Numpad                                    : Snap the active window.

; Ideas of possible features :
;  1. Add actions to LWin + scroll up / down

; Note
; --------------------------------------------------
if (VerCompare(A_AhkVersion, "1.0.39.00") < 0) {
    msgResult := MsgBox("This script may not work properly with your version of AutoHotkey. Continue?", "", 20)
    if (msgResult = "No")
        ExitApp()
}


; Easy Window Dragging
; --------------------------------------------------
; This is the setting that runs smoothest on my system. Depending on your video card and cpu power, you may want to raise or lower this value.
SetWinDelay(2)
CoordMode("Mouse")
return


; Mouse Gesture
; --------------------------------------------------
LWin & LButton:: {
    MouseGetPos(, , &KDE_id) ; Get the window id
    ; Abort if it's the desktop.
    ClassWin := WinGetClass("ahk_id " KDE_id)
    if (ClassWin = "WorkerW")
        return
    ; If the window is maximized, restore the initial position
    ; and size of the window and center the mouse.
    KDE_Win := WinGetMinMax("ahk_id " KDE_id)
    if KDE_Win {
        WinRestore("ahk_id " KDE_id)
        WinGetPos(&KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, "ahk_id " KDE_id)
        MouseMove((KDE_WinX1 + (KDE_WinW / 2)), (KDE_WinY1 + (KDE_WinH / 2)), 0)
    }

    ; Move the window.
    MouseGetPos(&KDE_X1, &KDE_Y1)
    WinGetPos(&KDE_WinX1, &KDE_WinY1, , , "ahk_id " KDE_id)
    Loop {
        KDE_Button := GetKeyState("LButton", "P") ? "D" : "U" ; Break if button has been released.
        if (KDE_Button = "U")
            break
        MouseGetPos(&KDE_X2, &KDE_Y2) ; Get the current mouse position.
        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1
        KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
        KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
        WinMove(KDE_WinX2, KDE_WinY2, , , "ahk_id " KDE_id) ; Move the window to the new position.
    }
    return
}

LWin & RButton:: {
    ; Get the mouse position and window id,
    MouseGetPos(&KDE_X1, &KDE_Y1, &KDE_id)
    ; Abort if it's the desktop.
    ClassWin := WinGetClass("ahk_id " KDE_id)
    if (ClassWin = "WorkerW")
        return
    ; Abort if the window is maximized.
    KDE_Win := WinGetMinMax("ahk_id " KDE_id)
    If KDE_Win
        return
    ; Get the initial window position and size.
    WinGetPos(&KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, "ahk_id " KDE_id)
    ; Determine whether we're in the left, center, or right third of the window.
    If (KDE_X1 < KDE_WinX1 + KDE_WinW / 3) {
        KDE_dX := 1
        KDE_dW := -1
    }
    else if (KDE_X1 > KDE_WinX1 + 2*(KDE_WinW / 3)) {
        KDE_dX := 0
        KDE_dW := 1
    }
    else {
        KDE_dX := 0
        KDE_dW := 0
    }
    ; Determine whether we're in the top, middle, or bottom third.
    if (KDE_Y1 < KDE_WinY1 + KDE_WinH / 3) {
        KDE_dY := 1
        KDE_dH := -1
    }
    else If (KDE_Y1 > KDE_WinY1 + 2*(KDE_WinH / 3)) {
        KDE_dY := 0
        KDE_dH := 1
    }
    else {
        KDE_dY := 0
        KDE_dH := 0
    }
    ; Special case : center cell only -> adaptive split by aspect ratio
    if (KDE_dX = 0 && KDE_dY = 0 && KDE_dW = 0 && KDE_dH = 0) {
        ; Determine aspect ratio
        if (KDE_WinW >= KDE_WinH) {
            ; Horizontal or square window -> vertical split (left/right)
            CenterMidX := KDE_WinX1 + KDE_WinW / 2
            if (KDE_X1 < CenterMidX) {
                ; Center-left
                KDE_dX := 1
                KDE_dW := -1
            } else {
                ; Center-right
                KDE_dX := 0
                KDE_dW := 1
            }
        } 
        else {
            ; Vertical window -> horizontal split (top/bottom)
            CenterMidY := KDE_WinY1 + KDE_WinH / 2

            if (KDE_Y1 < CenterMidY) {
                ; Center-top
                KDE_dY := 1
                KDE_dH := -1
            } 
            else {
                ; Center-bottom
                KDE_dY := 0
                KDE_dH := 1
            }
        }
    }
    Loop {
        KDE_Button := GetKeyState("RButton", "P") ? "D" : "U" ; Break if button has been released.
        if (KDE_Button = "U")
            break
        MouseGetPos(&KDE_X2, &KDE_Y2) ; Get the current mouse position.
        ; Get the current window position and size.
        WinGetPos(&KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, "ahk_id " KDE_id)
        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1
        WinMove(KDE_WinX1 + (KDE_dX * KDE_X2),
                KDE_WinY1 + (KDE_dY * KDE_Y2),
                KDE_WinW  + (KDE_dW * KDE_X2),
                KDE_WinH  + (KDE_dH * KDE_Y2),
                "ahk_id " KDE_id)
        KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
        KDE_Y1 := (KDE_Y2 + KDE_Y1)
    }
    return
}

LWin & MButton:: {
    MouseGetPos(&X1, &Y1, &KDE_id) ; Get the window id
    ; Abort if it's the desktop.
    ClassWin := WinGetClass("ahk_id " KDE_id)
    if (ClassWin = "WorkerW")
        return
    KeyWait("MButton")
    MouseGetPos(&X2, &Y2)
    MinTime := 50 ; Set` A_TimeSinceThisHotkey
    LongTime := 200 ; Set A_TimeSinceThisHotkey to avoid hiting Gesture down by accident
    Tolerance := 60 ; Tolerance of the gesture
    if (A_TimeSinceThisHotkey > MinTime AND X2 - X1 > 0 AND Y2 - Y1 < 0 AND Abs(X2 - X1) >= Tolerance AND Abs(Y2 - Y1) >= Tolerance) {
        GestureTR(KDE_id)	; gesture top/right
    }
    else if (A_TimeSinceThisHotkey > MinTime AND X2 - X1 > 0 AND Y2 - Y1 > 0 AND Abs(X2 - X1) >= Tolerance AND Abs(Y2 - Y1) >= Tolerance) {
        GestureDR(KDE_id)	; gesture down/right
    }
    else if (A_TimeSinceThisHotkey > MinTime AND X2 - X1 < 0 AND Y2 - Y1 < 0 AND Abs(X2 - X1) >= Tolerance AND Abs(Y2 - Y1) >= Tolerance) {
        GestureTL(KDE_id)	; gesture top/left
    }
    else if (A_TimeSinceThisHotkey > MinTime AND X2 - X1 < 0 AND Y2 - Y1 > 0 AND Abs(X2 - X1) >= Tolerance AND Abs(Y2 - Y1) >= Tolerance) {
        GestureDL(KDE_id)	; gesture down/left
    }
    else if (A_TimeSinceThisHotkey > MinTime AND Y2 - Y1 < 0 AND Abs(Y2 - Y1) >= Tolerance AND Abs(X2 - X1) < Tolerance) {
        GestureU(KDE_id)	; gesture up
    }
    else if (A_TimeSinceThisHotkey > LongTime AND Y2 - Y1 > 0 AND Abs(Y2 - Y1) >= Tolerance AND Abs(X2 - X1) < Tolerance) {
        GestureD(KDE_id)	; Gesture down
    }
    else if (A_TimeSinceThisHotkey > MinTime AND X2 - X1 < 0 AND Abs(X2 - X1) >= Tolerance AND Abs(Y2 - Y1) < Tolerance) {
        GestureL(KDE_id)	; gesture left
    }
    else if (A_TimeSinceThisHotkey > MinTime AND X2 - X1 > 0 AND Abs(X2 - X1) >= Tolerance AND Abs(Y2 - Y1) < Tolerance) {
        GestureR(KDE_id)	; gesture right
    }
    else if ((X1 = X2) and (Y1 = Y2)) {
        NoMove(KDE_id)		; gesture no move
    }
    return
}


; Hyper Window Snap
; --------------------------------------------------
SnapActiveWindow(winPlaceVertical, winPlaceHorizontal, winSizeHeight) {
    heightOffset := 7
    widthOffset := 15
    xOffset := 7

    activeWin := WinExist("A")
    activeMon := GetMonitorIndexFromWindow(activeWin)
    MinMaxState := WinGetMinMax("A")
    if (MinMaxState) {
        WinRestore("A")
    }

    MonitorGetWorkArea(activeMon, &MonitorWorkAreaLeft, &MonitorWorkAreaTop, &MonitorWorkAreaRight, &MonitorWorkAreaBottom)

    if (winSizeHeight == "half") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop) / 2 + heightOffset
    } else if (winSizeHeight == "full") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop) + heightOffset
    } else if (winSizeHeight == "third") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop) / 3
    }

    if (winPlaceHorizontal == "left") {
        posX := MonitorWorkAreaLeft - xOffset
        width := (MonitorWorkAreaRight - MonitorWorkAreaLeft) / 2 + widthOffset
    } else if (winPlaceHorizontal == "right") {
        posX := MonitorWorkAreaLeft + (MonitorWorkAreaRight - MonitorWorkAreaLeft) / 2 - xOffset
        width := (MonitorWorkAreaRight - MonitorWorkAreaLeft) / 2 + widthOffset
    } else {
        posX := MonitorWorkAreaLeft - xOffset
        width := MonitorWorkAreaRight - MonitorWorkAreaLeft + widthOffset
    }

    if (winPlaceVertical == "bottom") {
        posY := MonitorWorkAreaBottom - height + heightOffset
    } else if (winPlaceVertical == "middle") {
        posY := MonitorWorkAreaTop + height
    } else {
        posY := MonitorWorkAreaTop
    }

    WinMove(posX, posY, width, height, "A")
}

GetMonitorIndexFromWindow(windowHandle) {
    ; Starts with 1.
    monitorIndex := 1

    monitorInfo := Buffer(40)
    NumPut('UInt', 40, monitorInfo) 

    if (monitorHandle := DllCall("MonitorFromWindow", "Ptr", windowHandle, "UInt", 0x2))
        && DllCall("GetMonitorInfo", "Ptr", monitorHandle, "Ptr", monitorInfo) {
            monitorLeft := NumGet(monitorInfo, 4, "Int")
            monitorTop := NumGet(monitorInfo, 8, "Int")
            monitorRight := NumGet(monitorInfo, 12, "Int")
            monitorBottom := NumGet(monitorInfo, 16, "Int")
            workLeft := NumGet(monitorInfo, 20, "Int")
            workTop := NumGet(monitorInfo, 24, "Int")
            workRight := NumGet(monitorInfo, 28, "Int")
            workBottom := NumGet(monitorInfo, 32, "Int")
            isPrimary := NumGet(monitorInfo, 36, "UInt") & 1

            monitorCount := MonitorGetCount()

            Loop monitorCount {
                MonitorGet(A_Index, &tempMonLeft, &tempMonTop, &tempMonRight, &tempMonBottom)

                ; Compare location to determine the monitor index.
                if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
                    and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom)) {
                        monitorIndex := A_Index
                        break
                }
            }
    }
    return monitorIndex
}


; Set actions
; --------------------------------------------------
; Add Title Id to diferanciate diferent multiple instances (explorer or chrome for exemple) ?
GestureTR(KDE_id) {	; gesture top/right
    WinActivate("ahk_id " KDE_id) ; Activate the window
    SnapActiveWindow("top", "right", "half")
    return
}
GestureDR(KDE_id) {	; gesture down/right
    WinActivate("ahk_id " KDE_id) ; Activate the window
    SnapActiveWindow("bottom", "right", "half")
    return
}
GestureTL(KDE_id) {	; gesture top/left
    WinActivate("ahk_id " KDE_id) ; Activate the window
    SnapActiveWindow("top", "left", "half")
    return
}
GestureDL(KDE_id) {	; gesture down/left
    WinActivate("ahk_id " KDE_id) ; Activate the window
    SnapActiveWindow("bottom", "left", "half")
    return
}
GestureU(KDE_id) {	; gesture up
    ; Toggle between maximized and restored state.
    KDE_Win := WinGetMinMax("ahk_id " KDE_id)
    If KDE_Win
        WinRestore("ahk_id " KDE_id)
    Else
        WinMaximize("ahk_id " KDE_id)
    return
}
GestureD(KDE_id) {	; Gesture down
    WinActivate("ahk_id " KDE_id) ; Activate the window
    ;WinSetAlwaysOnTop(-1, "ahk_id " KDE_id)
    Sendinput("!p") ; Send alt+p in order to activate PowerToy Always on top
    return
}
GestureL(KDE_id) {	; gesture left
    WinActivate("ahk_id " KDE_id) ; Activate the window
    SnapActiveWindow("top", "left", "full")
    return
}
GestureR(KDE_id) { ; gesture right
    WinActivate("ahk_id " KDE_id) ; Activate the window
    SnapActiveWindow("top", "right", "full")
    return
}
NoMove(KDE_id) { ; gesture no move
    WinMinimize("ahk_id " KDE_id) ; Minimize the window
    return
}


; Win + Numpad = Snap to conrners for diagonals, or top, bottom, left, right of screen (Landscape)
; --------------------------------------------------
LWin & Numpad1:: {
    ClassWin := WinGetClass("A") ; Abort if it's the desktop.
    if (ClassWin = "WorkerW")
        return
    SnapActiveWindow("bottom", "left", "half")
    return
}
LWin & Numpad2:: {
    ClassWin := WinGetClass("A") ; Abort if it's the desktop.
    if (ClassWin = "WorkerW")
        return
    SnapActiveWindow("bottom", "full", "half")
    return
}
LWin & Numpad3:: {
    ClassWin := WinGetClass("A") ; Abort if it's the desktop.
    if (ClassWin = "WorkerW")
        return
    SnapActiveWindow("bottom", "right", "half")
    return
}
LWin & Numpad4:: {
    ClassWin := WinGetClass("A") ; Abort if it's the desktop.
    if (ClassWin = "WorkerW")
        return
    SnapActiveWindow("top", "left", "full")
    return
}
LWin & Numpad5:: {
    ClassWin := WinGetClass("A") ; Abort if it's the desktop.
    if (ClassWin = "WorkerW")
        return
    KDE_Win := WinGetMinMax("A")
    If KDE_Win
        WinRestore("A")
    Else
        WinMaximize("A")
    return
}
LWin & Numpad6:: {
    ClassWin := WinGetClass("A") ; Abort if it's the desktop.
    if (ClassWin = "WorkerW")
        return
    SnapActiveWindow("top", "right", "full")
    return
}
LWin & Numpad7:: {
    ClassWin := WinGetClass("A") ; Abort if it's the desktop.
    if (ClassWin = "WorkerW")
        return
    SnapActiveWindow("top", "left", "half")
    return
}
LWin & Numpad8:: {
    ClassWin := WinGetClass("A") ; Abort if it's the desktop.
    if (ClassWin = "WorkerW")
        return
    SnapActiveWindow("top", "full", "half")
    return
}
LWin & Numpad9:: {
    ClassWin := WinGetClass("A") ; Abort if it's the desktop.
    if (ClassWin = "WorkerW")
        return
    SnapActiveWindow("top", "right", "half")
    return
}
