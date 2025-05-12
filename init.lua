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
    -- mode:bind({}, "v", app_man:toggle("Visual Studio Code"))
    mode:bind({}, "v", app_man:toggle("Vivaldi"))
    -- mode:bind({"shift"}, "v", app_man:toggle("Tunnelblick")) -- VPN
    mode:bind({}, "x", app_man:toggle("Cursor"))
    mode:bind({}, "w", app_man:toggle("superwhisper"))
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

do -- mouse mode
    -- 단축키 설정
    local KEYBINDINGS = {
        MODE_TOGGLE = "f14",        -- 마우스 모드 토글 (win_move에서 사용하는 F14 사용)
        MOVE = {
            UP = "up",
            DOWN = "down",
            LEFT = "left",
            RIGHT = "right"
        },
        CLICK = {
            LEFT = ",",             -- 좌클릭
            RIGHT = "."             -- 우클릭
        },
        SCROLL = {
            LEFT = "h",             -- 스크롤 왼쪽
            UP = "j",               -- 스크롤 위
            DOWN = "k",             -- 스크롤 아래
            RIGHT = "l"             -- 스크롤 오른쪽
        },
        SPEED = {
            DECREASE = "[",         -- 속도 감소
            INCREASE = "]"          -- 속도 증가
        }
    }

    -- 속도 관련 설정
    local SPEED_SETTINGS = {
        MIN = 1,     -- 최소 속도
        MAX = 20,    -- 최대 속도
        STEP = 1,    -- 속도 조절 단위
        DEFAULT = 4  -- 기본 속도
    }

    -- 마우스 모드 설정
    local mouse_mode = f14_mode  -- 기존 f14_mode 사용
    local move_timer = nil
    local scroll_timer = nil
    local move_speed = hs.settings.get("mouse_move_speed") or SPEED_SETTINGS.DEFAULT

    -- 현재 눌린 키 상태를 추적
    local key_state = {
        up = false,
        down = false,
        left = false,
        right = false,
        scroll_up = false,
        scroll_down = false,
        scroll_left = false,
        scroll_right = false
    }

    -- 마우스 클릭 함수
    local function leftClick()
        -- 현재 마우스 위치 저장
        local pos = hs.mouse.getAbsolutePosition()
        
        -- 좌클릭 이벤트 생성 및 실행
        local clickEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, pos)
        clickEvent:post()
        
        -- 약간의 딜레이 후 마우스 업 이벤트 실행
        hs.timer.doAfter(0.01, function()
            local upEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, pos)
            upEvent:post()
        end)
        
        -- 클릭 피드백 표시
        hs.alert.show("Click", 0.3)
    end

    -- 우클릭 함수
    local function rightClick()
        -- 현재 마우스 위치 저장
        local pos = hs.mouse.getAbsolutePosition()
        
        -- 우클릭 이벤트 생성 및 실행
        local clickEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.rightMouseDown, pos)
        clickEvent:post()
        
        -- 약간의 딜레이 후 마우스 업 이벤트 실행
        hs.timer.doAfter(0.01, function()
            local upEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.rightMouseUp, pos)
            upEvent:post()
        end)
        
        -- 클릭 피드백 표시
        hs.alert.show("Right Click", 0.3)
    end

    -- 스크롤 함수
    local function scroll()
        local dx, dy = 0, 0
        
        -- 각 방향의 상태에 따라 스크롤량 계산
        if key_state.scroll_left then dx = dx - 10 end
        if key_state.scroll_right then dx = dx + 10 end
        if key_state.scroll_up then dy = dy - 10 end
        if key_state.scroll_down then dy = dy + 10 end
        
        -- 스크롤 이벤트 생성 및 실행
        if dx ~= 0 or dy ~= 0 then
            local scrollEvent = hs.eventtap.event.newScrollEvent({dx, dy}, {}, "pixel")
            scrollEvent:post()
        end
    end

    -- 속도 조절 함수
    local function adjustSpeed(increase)
        local old_speed = move_speed
        if increase then
            move_speed = math.min(move_speed + SPEED_SETTINGS.STEP, SPEED_SETTINGS.MAX)
        else
            move_speed = math.max(move_speed - SPEED_SETTINGS.STEP, SPEED_SETTINGS.MIN)
        end
        
        -- 속도가 변경된 경우에만 저장하고 피드백 표시
        if old_speed ~= move_speed then
            hs.settings.set("mouse_move_speed", move_speed)
            -- 속도 표시 (1초 동안 표시)
            hs.alert.show(string.format("Speed: %d", move_speed), 1)
        end
    end

    -- 마우스 이동 함수
    local function moveMouse()
        local dx, dy = 0, 0
        
        -- 각 방향의 상태에 따라 이동량 계산
        if key_state.up then dy = dy - move_speed end
        if key_state.down then dy = dy + move_speed end
        if key_state.left then dx = dx - move_speed end
        if key_state.right then dx = dx + move_speed end
        
        -- 대각선 이동 시 속도 정규화 (대각선이 더 빠르지 않도록)
        if dx ~= 0 and dy ~= 0 then
            local factor = 1 / math.sqrt(2)
            dx = dx * factor
            dy = dy * factor
        end
        
        local pos = hs.mouse.getAbsolutePosition()
        hs.mouse.setAbsolutePosition({x = pos.x + dx, y = pos.y + dy})
    end

    -- 타이머 시작 함수
    local function startMoveTimer()
        if move_timer then
            move_timer:stop()
        end
        move_timer = hs.timer.new(0.016, moveMouse)  -- 약 60fps
        move_timer:start()
    end

    -- 타이머 정지 함수
    local function stopMoveTimer()
        if move_timer then
            move_timer:stop()
            move_timer = nil
        end
    end

    -- 스크롤 타이머 시작 함수
    local function startScrollTimer()
        if scroll_timer then
            scroll_timer:stop()
        end
        scroll_timer = hs.timer.new(0.016, scroll)  -- 약 60fps
        scroll_timer:start()
    end

    -- 스크롤 타이머 정지 함수
    local function stopScrollTimer()
        if scroll_timer then
            scroll_timer:stop()
            scroll_timer = nil
        end
    end

    -- F14 키로 마우스 모드 활성화/비활성화
    hs.hotkey.bind({}, KEYBINDINGS.MODE_TOGGLE, function()
        mouse_mode:enter()
        hs.alert.show("Mouse Mode: ON")
    end, function()
        mouse_mode:exit()
        -- 모든 키 상태 초기화
        for k in pairs(key_state) do
            key_state[k] = false
        end
        stopMoveTimer()
        stopScrollTimer()
        hs.alert.show("Mouse Mode: OFF")
    end)

    -- 마우스 모드에서 방향키로 커서 이동
    mouse_mode:bind({}, KEYBINDINGS.MOVE.UP, function()
        key_state.up = true
        startMoveTimer()
    end, function()
        key_state.up = false
        if not (key_state.down or key_state.left or key_state.right) then
            stopMoveTimer()
        end
    end)

    mouse_mode:bind({}, KEYBINDINGS.MOVE.DOWN, function()
        key_state.down = true
        startMoveTimer()
    end, function()
        key_state.down = false
        if not (key_state.up or key_state.left or key_state.right) then
            stopMoveTimer()
        end
    end)

    mouse_mode:bind({}, KEYBINDINGS.MOVE.LEFT, function()
        key_state.left = true
        startMoveTimer()
    end, function()
        key_state.left = false
        if not (key_state.up or key_state.down or key_state.right) then
            stopMoveTimer()
        end
    end)

    mouse_mode:bind({}, KEYBINDINGS.MOVE.RIGHT, function()
        key_state.right = true
        startMoveTimer()
    end, function()
        key_state.right = false
        if not (key_state.up or key_state.down or key_state.left) then
            stopMoveTimer()
        end
    end)

    -- 속도 조절 단축키
    mouse_mode:bind({}, KEYBINDINGS.SPEED.DECREASE, function()
        adjustSpeed(false)  -- 속도 감소
    end)

    mouse_mode:bind({}, KEYBINDINGS.SPEED.INCREASE, function()
        adjustSpeed(true)   -- 속도 증가
    end)

    -- 좌클릭 단축키
    mouse_mode:bind({}, KEYBINDINGS.CLICK.LEFT, leftClick)

    -- 우클릭 단축키
    mouse_mode:bind({}, KEYBINDINGS.CLICK.RIGHT, rightClick)

    -- 스크롤 단축키 (vim 스타일)
    mouse_mode:bind({}, KEYBINDINGS.SCROLL.LEFT, function()
        key_state.scroll_left = true
        startScrollTimer()
    end, function()
        key_state.scroll_left = false
        if not (key_state.scroll_right or key_state.scroll_up or key_state.scroll_down) then
            stopScrollTimer()
        end
    end)

    mouse_mode:bind({}, KEYBINDINGS.SCROLL.UP, function()
        key_state.scroll_up = true
        startScrollTimer()
    end, function()
        key_state.scroll_up = false
        if not (key_state.scroll_left or key_state.scroll_right or key_state.scroll_down) then
            stopScrollTimer()
        end
    end)

    mouse_mode:bind({}, KEYBINDINGS.SCROLL.DOWN, function()
        key_state.scroll_down = true
        startScrollTimer()
    end, function()
        key_state.scroll_down = false
        if not (key_state.scroll_left or key_state.scroll_right or key_state.scroll_up) then
            stopScrollTimer()
        end
    end)

    mouse_mode:bind({}, KEYBINDINGS.SCROLL.RIGHT, function()
        key_state.scroll_right = true
        startScrollTimer()
    end, function()
        key_state.scroll_right = false
        if not (key_state.scroll_left or key_state.scroll_up or key_state.scroll_down) then
            stopScrollTimer()
        end
    end)
end

hs.alert.show("loaded")
