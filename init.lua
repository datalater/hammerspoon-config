-- hammerspoon config
require('luarocks.loader')
require('modules.inputsource_aurora')
require('modules.pinshot')

-- Hammerspoon reload
hs.hotkey.bind({'option', 'cmd'}, 'r', hs.reload)

-- WindowHints
hs.hints.hintChars = {'1', '2', '3', '4', 'Q', 'W', 'E', 'R'}
hs.hotkey.bind({'shift'}, 'F1', hs.hints.windowHints)

local f13_mode = hs.hotkey.modal.new()
hs.hotkey.bind({}, 'f13', function() f13_mode:enter() end,
               function() f13_mode:exit() end)

local f14_mode = hs.hotkey.modal.new()
hs.hotkey.bind({}, 'f14', function() f14_mode:enter() end,
               function() f14_mode:exit() end)

do -- hints
    -- hs.hotkey.bind({}, 'f16', hs.hints.windowHints)
    -- hs.hints.hintChars = {'q', 'w', 'e', 'r', 'u', 'i', 'o', 'p', 'h', 'j', 'k', 'l', 'm', ',', '.' }
end

do -- pinshot
    local pinshot = require('modules.pinshot')
    local mode = f14_mode
    f14_mode:bind({}, '[', pinshot.show)
    f14_mode:bind({}, ']', pinshot.clear)
    f14_mode:bind({}, '\\', pinshot.clearAll)
end

do -- app manager
    local app_man = require('modules.appman')
    local mode = f13_mode

    mode:bind({}, 'c', app_man:toggle('Google Chrome'))
    mode:bind({}, 'l', app_man:toggle('Line'))
    mode:bind({}, 'q', app_man:toggle('Sequel Pro'))
    -- mode:bind({'shift'}, 'v', app_man:toggle('VimR'))
    -- mode:bind({}, 'v', app_man:toggle('MacVim'))
    mode:bind({}, 't', app_man:toggle('Terminal'))
    mode:bind({}, 'b', app_man:toggle('Ridibooks'))
    mode:bind({}, 'm', app_man:toggle('Notes'))
    mode:bind({}, 'n', app_man:toggle('Notion'))
    mode:bind({}, 's', app_man:toggle('Slack'))
    mode:bind({}, 'f', app_man:toggle('Finder'))
    mode:bind({}, 'r', app_man:toggle('Reminders'))
    mode:bind({}, 'e', app_man:toggle('Evernote'))
    mode:bind({}, 'w', app_man:toggle('WebStorm'))
    mode:bind({}, 'd', app_man:toggle('ScreenBrush'))
    mode:bind({}, 'a', app_man:toggle('Atom'))
    mode:bind({}, 'p', app_man:toggle('Preview'))
    -- mode:bind({}, 'p', app_man:toggle('PhpStorm'))
    mode:bind({}, 'k', app_man:toggle('KakaoTalk'))
    -- mode:bind({}, 't', app_man:toggle('Telegram'))
    mode:bind({}, 'i', app_man:toggle('iTerm'))
    mode:bind({}, 'v', app_man:toggle('Visual Studio Code'))

    -- mode:bind({'shift'}, 'tab', app_man.focusPreviousScreen)
    mode:bind({}, 'tab', app_man.focusNextScreen)

    -- hs.hotkey.bind({'cmd', 'shift'}, 'space', app_man:toggle('Terminal'))

    local tabTable = {}

    tabTable['Slack'] = {
        left = {mod = {'option'}, key = 'up'},
        right = {mod = {'option'}, key = 'down'}
    }
    tabTable['Safari'] = {
        left = {mod = {'control', 'shift'}, key = 'tab'},
        right = {mod = {'control'}, key = 'tab'}
    }
    tabTable['터미널'] = {
        left = {mod = {'control', 'shift'}, key = 'tab'},
        right = {mod = {'control'}, key = 'tab'}
    }
    tabTable['Terminal'] = {
        left = {mod = {'control', 'shift'}, key = 'tab'},
        right = {mod = {'control'}, key = 'tab'}
    }
    tabTable['iTerm2'] = {
        left = {mod = {'control', 'shift'}, key = 'tab'},
        right = {mod = {'control'}, key = 'tab'}
    }
    tabTable['IntelliJ IDEA'] = {
        left = {mod = {'command', 'shift'}, key = '['},
        right = {mod = {'command', 'shift'}, key = ']'}
    }
    tabTable['PhpStorm'] = {
        left = {mod = {'command', 'shift'}, key = '['},
        right = {mod = {'command', 'shift'}, key = ']'}
    }
    tabTable['WebStorm'] = {
        left = {mod = {'command', 'shift'}, key = '['},
        right = {mod = {'command', 'shift'}, key = ']'}
    }
    tabTable['_else_'] = {
        left = {mod = {'control'}, key = 'pageup'},
        right = {mod = {'control'}, key = 'pagedown'}
    }
    local function tabMove(dir)
        return function()
            local activeAppName = hs.application.frontmostApplication():name()
            local tab = tabTable[activeAppName] or tabTable['_else_']
            hs.eventtap.keyStroke(tab[dir]['mod'], tab[dir]['key'])
        end
    end

    f13_mode:bind({}, ',', tabMove('left'), function() end, tabMove('left'))
    f13_mode:bind({}, '.', tabMove('right'), function() end, tabMove('right'))
end

do -- winmove
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

    mode:bind({}, 'a', win_move.more_left_padding)
    mode:bind({}, 'd', win_move.more_right_padding)
    mode:bind({}, 'w', win_move.more_up_padding)
    mode:bind({}, 's', win_move.more_down_padding)
end

do -- clipboard history
    local clipboard = require('modules.clipboard')
    local mode = f13_mode
    clipboard.setSize(10)
    f13_mode:bind({}, '`', clipboard.showList)
    f13_mode:bind({'shift'}, '`', clipboard.clear)
end

hs.alert.show('loaded')
