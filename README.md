# Simple Windows Drag
The goal with Simple Windows Drag is to easily snap, move and resize windows with a single key press and a mouse.
This script is made for AutoHotKey V1.1
## Features
- Hold down <kbd>F14</kbd> and <kbd>Left click</kbd> anywhere inside a window to **drag** it to a new location.
- Hold down <kbd>F14</kbd> and <kbd>Right click drag</kbd> anywhere inside a window to easily **resize** it.
- Hold down <kbd>F14</kbd> and <kbd>Middle click drag</kbd> to perform the following actions ; **maximize**, **always on top** or **snap** a window.
- Hold down <kbd>F14</kbd> and <kbd>Middle click</kbd> without moving to minimize the window under the mouse cursor.

In my case, <kbd>F14</kbd> is remapped to <kbd>Caps Lock</kbd> with PowerToy
## All shortcuts

| Hotkeys|Behavior|
|---|---|
|<kbd>F14</kbd> + <kbd>Left Button</kbd> + <kbd>Drag</kbd>|Move a window.|
|<kbd>F14</kbd> + <kbd>Right Button</kbd> + <kbd>Drag</kbd>|Resize a window.|
|<kbd>F14</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Up</kbd>|Maximize/Restore a window.|
|<kbd>F14</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Down</kbd>|Always On Top a window.|
|<kbd>F14</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Right</kbd>|Snap to the Right half.|
|<kbd>F14</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Left</kbd>|Snap to the Left half.|
|<kbd>F14</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Top right corner</kbd>|Snap to the Top-Right quarter.|
|<kbd>F14</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Top left corner</kbd>|Snap to the Top-Left quarter.|
|<kbd>F14</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Bottom right corner</kbd>|Snap to Bottom-Right quarter.|
|<kbd>F14</kbd> + <kbd>Middle Button</kbd> + <kbd>Drag Bottom left corner</kbd>|Snap to the Bottom-Left quarter.|
|<kbd>F14</kbd> + <kbd>Middle Button</kbd> + <kbd>Motionless</kbd>|Minimize a window.|
|<kbd>F14</kbd> + <kbd>Numpad</kbd>|Snap the active window.|

## Installation
1. Install [AutoHotKey](https://www.autohotkey.com/)
2. Download the `SimpleWindowsDrag.ahk` file and double click to run it.
3. (Optional) To have the script run when you start your computer, place the .ahk file (or a shortcut of it) into your computer's startup folder.

-> The startup folder can be accessed by pressing <kbd>Win</kbd> + <kbd>R</kbd> on your keyboard, then in the Open field, type `shell:startup` then press <kbd>Enter</kbd>.

## The script
I’v tried to make those 3 scripts work together :
- [Easy Window Dragging KDE style](https://www.autohotkey.com/docs/v1/scripts/index.htm#EasyWindowDrag_(KDE)) - by Jonny
- [Hyper Window Snap](https://github.com/glenviewjeff/HyperWindowSnap) - by Andrew Moore and Jeff Axelrod
- [Middle Mouse Button Gestures (diagonal)](https://www.autohotkey.com/board/topic/87331-middle-mouse-button-gestures-diagonal/) - by Drozdman

It’s all written in Autohotkey V1.1 because of the amount of ressources online and the fact that the originals scripts are  all written in this version of the language.

I’m new to coding, so my code is probably not well optimized and some fonctions does not works as well as I’d like. But overall, I’m pretty happy with what this piece of code can do.
