-- hammerspoon config

require('luarocks.loader')

local f13_mode = hs.hotkey.modal.new()
hs.hotkey.bind({}, 'f13', function() f13_mode:enter() end, function() f13_mode:exit() end)

local f14_mode = hs.hotkey.modal.new()
hs.hotkey.bind({}, 'f14', function() f14_mode:enter() end, function() f14_mode:exit() end)

do  -- hints
    -- hs.hotkey.bind({}, 'f16', hs.hints.windowHints)
    -- hs.hints.hintChars = {'q', 'w', 'e', 'r', 'u', 'i', 'o', 'p', 'h', 'j', 'k', 'l', 'm', ',', '.' }
end

do  -- app manager
    local app_man = require('modules.appman')
    local mode = f13_mode

    mode:bind({}, 'c', app_man:toggle('Google Chrome'))
    mode:bind({}, 'l', app_man:toggle('Line'))
    mode:bind({}, 'q', app_man:toggle('Sequel Pro'))
    -- mode:bind({'shift'}, 'v', app_man:toggle('VimR'))
    -- mode:bind({}, 'v', app_man:toggle('MacVim'))
    mode:bind({}, 'n', app_man:toggle('Notes'))
    mode:bind({}, 's', app_man:toggle('Safari'))
    mode:bind({}, 'f', app_man:toggle('Finder'))
    mode:bind({}, 'r', app_man:toggle('Reminders'))
    mode:bind({}, 'e', app_man:toggle('Evernote'))
    mode:bind({}, 'p', app_man:toggle('PhpStorm'))
    mode:bind({}, 'a', app_man:toggle('Atom'))
    mode:bind({}, 'm', app_man:toggle('Postman'))
    mode:bind({}, 'k', app_man:toggle('KakaoTalk'))
    -- mode:bind({}, 't', app_man:toggle('Telegram'))
    mode:bind({}, 'i', app_man:toggle('iTerm'))

    -- mode:bind({'shift'}, 'tab', app_man.focusPreviousScreen)
    mode:bind({}, 'tab', app_man.focusNextScreen)

    -- hs.hotkey.bind({'cmd', 'shift'}, 'space', app_man:toggle('Terminal'))
end

do  -- winmove
    local win_move = require('modules.hammerspoon_winmove.hammerspoon_winmove')
    local mode = f14_mode

    mode:bind({}, '0', win_move.default)
    mode:bind({}, '1', win_move.left_bottom)
    mode:bind({}, '2', win_move.bottom)
    mode:bind({}, '3', win_move.right_bottom)
    mode:bind({}, '4', win_move.left)
    mode:bind({}, '5', win_move.full_screen)
    mode:bind({}, '6', win_move.right)
    mode:bind({}, '7', win_move.left_top)
    mode:bind({}, '8', win_move.top)
    mode:bind({}, '9', win_move.right_top)
    mode:bind({}, '-', win_move.prev_screen)
    mode:bind({}, '=', win_move.next_screen)
end

hs.alert.show('loaded')

