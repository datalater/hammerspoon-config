-- hammerspoon config
require("luarocks.loader")
require("modules.inputsource_aurora")

-- Hammerspoon reload
hs.hotkey.bind({"option", "cmd"}, "r", hs.reload)

-- WindowHints
hs.hints.hintChars = {"1", "2", "3", "4", "Q", "W", "E", "R", "A", "S", "D", "F"}
hs.hotkey.bind({"shift"}, "F1", hs.hints.windowHints)

local f13_mode = hs.hotkey.modal.new()
hs.hotkey.bind(
    {},
    "f13",
    function()
        f13_mode:enter()
    end,
    function()
        f13_mode:exit()
    end
)

local f14_mode = hs.hotkey.modal.new()
hs.hotkey.bind(
    {},
    "f14",
    function()
        f14_mode:enter()
    end,
    function()
        f14_mode:exit()
    end
)

do -- hints
    -- hs.hotkey.bind({}, 'f16', hs.hints.windowHints)
    -- hs.hints.hintChars = {'q', 'w', 'e', 'r', 'u', 'i', 'o', 'p', 'h', 'j', 'k', 'l', 'm', ',', '.' }
end

do -- input source switcher
    local inputEnglish = "com.apple.keylayout.ABC"
    local inputKorean = "com.apple.inputmethod.Korean.2SetKorean"
    local inputJapanese = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"
    
    f13_mode:bind({}, "1", function()
        hs.keycodes.currentSourceID(inputEnglish)
    end)
    
    f13_mode:bind({}, "2", function()
        hs.keycodes.currentSourceID(inputKorean)
    end)
    
    f13_mode:bind({}, "3", function()
        hs.keycodes.currentSourceID(inputJapanese)
    end)

    f13_mode:bind({}, "0", function()
        hs.alert.show(hs.keycodes.currentSourceID())
    end)
end

do -- input source toggle between English and Korean with F19(karabiner binding tab to f19)
    hs.hotkey.bind({}, "f19", function()
        local current = hs.keycodes.currentSourceID()
        local inputEnglish = "com.apple.keylayout.ABC"
        local inputKorean = "com.apple.inputmethod.Korean.2SetKorean"
        
        if current == inputEnglish then
            hs.keycodes.currentSourceID(inputKorean)
        else
            hs.keycodes.currentSourceID(inputEnglish)
        end
    end)
end

do -- app manager
    local app_man = require("modules.appman")
    local mode = f13_mode

    mode:bind({}, "a", app_man:toggle("Arc"))
    mode:bind({"shift"}, "a", app_man:toggle("Android Studio"))
    mode:bind({}, "b", app_man:toggle("Ridibooks"))
    mode:bind({}, "c", app_man:toggle("Google Chrome"))
    mode:bind({}, "d", app_man:toggle("Discord"))
    mode:bind({"shift"}, "d", app_man:toggle("Docker"))
    mode:bind({}, "e", app_man:toggle("Microsoft Edge"))
    mode:bind({}, "f", app_man:toggle("Finder"))
    mode:bind({}, "g", app_man:toggle("ChatGPT"))
    mode:bind({"shift"}, "g", app_man:toggle("Gifox"))
    mode:bind({"shift"}, "f", app_man:toggle("Firefox"))
    mode:bind({}, "h", app_man:toggle("Heynote"))
    mode:bind({}, "i", app_man:toggle("iTerm"))
    mode:bind({}, "k", app_man:toggle("KakaoTalk"))
    mode:bind({}, "m", app_man:toggle("Melon"))
    mode:bind({"shift"}, "m", app_man:toggle("Notes"))
    mode:bind({}, "n", app_man:toggle("Notion"))
    mode:bind({}, "o", app_man:toggle("OrbStack"))
    mode:bind({}, "p", app_man:toggle("Preview"))
    mode:bind({"shift"}, "p", app_man:toggle("Postico 2"))
    mode:bind({}, "s", app_man:toggle("Slack"))
    mode:bind({"shift"}, "s", app_man:toggle("Safari"))
    mode:bind({}, "t", app_man:toggle("Typora"))
    mode:bind({}, "v", app_man:toggle("Visual Studio Code"))
    mode:bind({"shift"}, "v", app_man:toggle("Tunnelblick")) -- VPN
    mode:bind({}, "x", app_man:toggle("Cursor"))
    -- mode:bind({}, "x", app_man:toggle("Simulator")) -- Xcode Simulator
    mode:bind({}, "y", app_man:toggle("YES24_eBook"))
    mode:bind({}, "z", app_man:toggle("zoom.us"))

    -- mode:bind({'shift'}, 'tab', app_man.focusPreviousScreen)
    mode:bind({}, "tab", app_man.focusNextScreen)

    local tabTable = {}

    tabTable["Slack"] = {
        left = {mod = {"option"}, key = "up"},
        right = {mod = {"option"}, key = "down"}
    }
    tabTable["Safari"] = {
        left = {mod = {"control", "shift"}, key = "tab"},
        right = {mod = {"control"}, key = "tab"}
    }
    tabTable["터미널"] = {
        left = {mod = {"control", "shift"}, key = "tab"},
        right = {mod = {"control"}, key = "tab"}
    }
    tabTable["Terminal"] = {
        left = {mod = {"control", "shift"}, key = "tab"},
        right = {mod = {"control"}, key = "tab"}
    }
    tabTable["iTerm2"] = {
        left = {mod = {"control", "shift"}, key = "tab"},
        right = {mod = {"control"}, key = "tab"}
    }
    tabTable["IntelliJ IDEA"] = {
        left = {mod = {"command", "shift"}, key = "["},
        right = {mod = {"command", "shift"}, key = "]"}
    }
    tabTable["PhpStorm"] = {
        left = {mod = {"command", "shift"}, key = "["},
        right = {mod = {"command", "shift"}, key = "]"}
    }
    tabTable["WebStorm"] = {
        left = {mod = {"command", "shift"}, key = "["},
        right = {mod = {"command", "shift"}, key = "]"}
    }
    tabTable["_else_"] = {
        left = {mod = {"control"}, key = "pageup"},
        right = {mod = {"control"}, key = "pagedown"}
    }
    local function tabMove(dir)
        return function()
            local activeAppName = hs.application.frontmostApplication():name()
            local tab = tabTable[activeAppName] or tabTable["_else_"]
            hs.eventtap.keyStroke(tab[dir]["mod"], tab[dir]["key"])
        end
    end

    f13_mode:bind(
        {},
        ",",
        tabMove("left"),
        function()
        end,
        tabMove("left")
    )
    f13_mode:bind(
        {},
        ".",
        tabMove("right"),
        function()
        end,
        tabMove("right")
    )
end

do -- winmove
    local win_move = require("modules.hammerspoon_winmove.hammerspoon_winmove")
    local mode = f14_mode

    mode:bind({}, "0", win_move.default)
    mode:bind({}, "1", win_move.left_bottom)
    mode:bind({}, "2", win_move.bottom)
    mode:bind({}, "3", win_move.right_bottom)
    mode:bind({}, "4", win_move.left)
    mode:bind({}, "5", win_move.full_screen)
    mode:bind({}, "6", win_move.right)
    mode:bind({}, "7", win_move.left_top)
    mode:bind({}, "8", win_move.top)
    mode:bind({}, "9", win_move.right_top)
    mode:bind({}, "-", win_move.prev_screen)
    mode:bind({}, "=", win_move.next_screen)

    mode:bind({}, "q", win_move.left_main)
    mode:bind({}, "w", win_move.center_main)
    mode:bind({}, "e", win_move.right_main)
    mode:bind({}, "r", win_move.left_sub)
    mode:bind({}, "t", win_move.right_sub)

    mode:bind({}, "a", win_move.left_main_2)
    mode:bind({}, "s", win_move.center_main_2)
    mode:bind({}, "d", win_move.right_main_2)
    mode:bind({}, "f", win_move.left_sub_2)
    mode:bind({}, "g", win_move.right_sub_2)

    mode:bind({"shift"}, "a", win_move.left_padding_plus)
    mode:bind({"shift"}, "f", win_move.right_padding_plus)

    mode:bind({}, "z", win_move.flex_left)
    mode:bind({}, "v", win_move.flex_right)
    mode:bind({}, "c", win_move.flex_top)
    mode:bind({}, "x", win_move.flex_bottom)

    mode:bind({}, "y", win_move.move_left)
    mode:bind({}, "u", win_move.move_center)
    mode:bind({}, "i", win_move.move_right)
end

do -- clipboard history
    local clipboard = require("modules.clipboard")
    local mode = f13_mode
    clipboard.setSize(10)
    f13_mode:bind({}, "`", clipboard.showList)
    f13_mode:bind({"shift"}, "`", clipboard.clear)
end

hs.alert.show("loaded")
