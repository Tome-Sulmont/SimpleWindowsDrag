# Simple Windows Drag
The goal with Simple Windows Drag is to easily snap, move and resize windows with a single keystroke and mouse movement.  
This is a script for [AutoHotKey](https://www.autohotkey.com/) V2
## Features
- Hold down <kbd>LWin</kbd> and <kbd>Left click</kbd> anywhere inside a window to **drag** it to a new location.
- Hold down <kbd>LWin</kbd> and <kbd>Right click drag</kbd> inside a window to easily **resize** it.
- Hold down <kbd>LWin</kbd> and <kbd>Middle click drag</kbd> to perform the following actions ; **maximize**, **always on top** or **snap** a window.
- Hold down <kbd>LWin</kbd> and <kbd>Middle click</kbd> without moving to minimize the window under the mouse cursor.

## All shortcuts

| Hotkeys|Behavior|
|---|---|
|<kbd>LWin</kbd> + <kbd>Left Button</kbd> + <kbd>Drag</kbd>|Move a window.|
|<kbd>LWin</kbd> + <kbd>Right Button</kbd> + <kbd>Drag</kbd>|Resize a window.|
|<kbd>LWin</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Up</kbd>|Maximize/Restore a window.|
|<kbd>LWin</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Down</kbd>|Always On Top a window.|
|<kbd>LWin</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Right</kbd>|Snap to the Right half.|
|<kbd>LWin</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Left</kbd>|Snap to the Left half.|
|<kbd>LWin</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Top right corner</kbd>|Snap to the Top-Right quarter.|
|<kbd>LWin</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Top left corner</kbd>|Snap to the Top-Left quarter.|
|<kbd>LWin</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Bottom right corner</kbd>|Snap to Bottom-Right quarter.|
|<kbd>LWin</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Bottom left corner</kbd>|Snap to the Bottom-Left quarter.|
|<kbd>LWin</kbd> + <kbd>Middle Button</kbd> + <kbd>Motionless</kbd>|Minimize a window.|
|<kbd>LWin</kbd> + <kbd>Numpad</kbd>|Snap the active window.|

## Installation
1. Install [AutoHotKey](https://www.autohotkey.com/)
2. Download the `SimpleWindowsDrag.ahk` file and double click to run it.
3. (Optional) To have the script run when you start your computer, place the .ahk file (or a shortcut of it) into your computer's startup folder.

→ The startup folder can be accessed by pressing <kbd>Win</kbd> + <kbd>R</kbd> on your keyboard, then in the Open field, type `shell:startup` then press <kbd>Enter</kbd>.

## The script
I’v tried to make those 3 scripts work together :
- [Easy Window Dragging KDE style](https://www.autohotkey.com/docs/v1/scripts/index.htm#EasyWindowDrag_(KDE)) - by Jonny
- [Hyper Window Snap](https://github.com/glenviewjeff/HyperWindowSnap) - by Andrew Moore and Jeff Axelrod
- [Middle Mouse Button Gestures (diagonal)](https://www.autohotkey.com/board/topic/87331-middle-mouse-button-gestures-diagonal/) - by Drozdman

Thank's to the folks at the [AHK Forum](https://www.autohotkey.com/boards/viewtopic.php?t=114370) for converting it to V2 and adding new features.

I’m pretty happy with what this piece of code can do, I hope you find it useful as well :)


