# hammerspoon_winmove

Hammerspoon-winmove provides functions for moving windows.

# how to use

Place this in your `~/.hammerspoon/init.lua`:

```lua
local win_move = require('modules.hammerspoon_winmove.hammerspoon_winmove')

local mod = {'option', 'shift'}

hs.hotkey.bind(mod, '1', win_move.left_bottom)
hs.hotkey.bind(mod, '2', win_move.bottom)
hs.hotkey.bind(mod, '3', win_move.right_bottom)
hs.hotkey.bind(mod, '4', win_move.left)
hs.hotkey.bind(mod, '5', win_move.full_screen)
hs.hotkey.bind(mod, '6', win_move.right)
hs.hotkey.bind(mod, '7', win_move.left_top)
hs.hotkey.bind(mod, '8', win_move.top)
hs.hotkey.bind(mod, '9', win_move.right_top)
hs.hotkey.bind(mod, '-', win_move.prev_screen)
hs.hotkey.bind(mod, '=', win_move.next_screen)
```
