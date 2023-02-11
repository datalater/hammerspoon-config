local obj = {}

local vim_icon = hs.menubar.new()
local inputEnglish = "com.apple.keylayout.ABC"
local boxes = {}

local cfg = {
    key_interval = 100,
    icon = {vim = "𝑽", novim = ""}
}

local mode = {
    on = false,
    triggered = false
}

function obj:init(mode)
    local function vim_end()
        mode.triggered = true
    end

    self.close = vim_end

    vim_icon:setClickCallback(setVimDisplay)

    hs.fnutils.each(
        {
            {mod = {}, key = "h", func = rapidKey({}, "left"), repetition = true},
            {mod = {}, key = "j", func = rapidKey({}, "down"), repetition = true},
            {mod = {}, key = "k", func = rapidKey({}, "up"), repetition = true},
            {mod = {}, key = "l", func = rapidKey({}, "right"), repetition = true},
            {mod = {"shift"}, key = "h", func = rapidKey({"shift"}, "left"), repetition = true},
            {mod = {"shift"}, key = "j", func = rapidKey({"shift"}, "down"), repetition = true},
            {mod = {"shift"}, key = "k", func = rapidKey({"shift"}, "up"), repetition = true},
            {mod = {"shift"}, key = "l", func = rapidKey({"shift"}, "right"), repetition = true},
            {mod = {"ctrl"}, key = "h", func = rapidKey({"ctrl"}, "left"), repetition = true},
            {mod = {"ctrl"}, key = "j", func = rapidKey({"ctrl"}, "down"), repetition = true},
            {mod = {"ctrl"}, key = "k", func = rapidKey({"ctrl"}, "up"), repetition = true},
            {mod = {"ctrl"}, key = "l", func = rapidKey({"ctrl"}, "right"), repetition = true},
            {mod = {"cmd"}, key = "h", func = rapidKey({"ctrl"}, "left"), repetition = true},
            {mod = {"cmd"}, key = "j", func = rapidKey({"ctrl"}, "down"), repetition = true},
            {mod = {"cmd"}, key = "k", func = rapidKey({"ctrl"}, "up"), repetition = true},
            {mod = {"cmd"}, key = "l", func = rapidKey({"ctrl"}, "right"), repetition = true},
            {mod = {}, key = "w", func = rapidKey({"alt"}, "right"), repetition = true},
            {mod = {}, key = "b", func = rapidKey({"alt"}, "left"), repetition = true},
            {mod = {"shift"}, key = "w", func = rapidKey({"shift", "alt"}, "right"), repetition = true},
            {mod = {"shift"}, key = "b", func = rapidKey({"shift", "alt"}, "left"), repetition = true},
            {mod = {}, key = "0", func = inputKey({"cmd"}, "left")},
            {mod = {}, key = "4", func = inputKey({"cmd"}, "right")},
            {mod = {"shift"}, key = "0", func = inputKey({"cmd", "shift"}, "left")},
            {mod = {"shift"}, key = "4", func = inputKey({"cmd", "shift"}, "right")},
            {mod = {}, key = "i", func = self.off},
            {mod = {}, key = "f", func = hs.hints.windowHints},
            {mod = {}, key = "p", func = inputKey({"cmd"}, "v"), repetition = true},
            {mod = {}, key = "y", func = inputKey({"cmd"}, "c")},
            {mod = {}, key = "d", func = inputKey({"cmd"}, "x")},
            {mod = {}, key = "x", func = rapidKey({}, "forwarddelete"), repetition = true},
            {mod = {"shift"}, key = "x", func = rapidKey({}, "DELETE"), repetition = true}
        },
        function(v)
            if v.repetition then
                mode:bind(v.mod, v.key, v.func, vim_end, v.func)
            else
                mode:bind(v.mod, v.key, v.func, vim_end)
            end
        end
    )

    self.on = function()
        mode:enter()
        setVimDisplay(true)
        mode.triggered = false
        mode.on = true
        show_status_bar(true)
    end

    self.off = function()
        setVimDisplay()
        mode:exit()

        local input_source = hs.keycodes.currentSourceID()

        if not mode.triggered then
            if not (input_source == inputEnglish) then
                hs.eventtap.keyStroke({}, "right")
                hs.keycodes.currentSourceID(inputEnglish)
                hs.eventtap.keyStroke({}, "escape")
            end
            hs.eventtap.keyStroke({}, "escape")
        end

        mode.triggered = true
        mode.on = false
        show_status_bar(false)
    end

    return self
end

function show_status_bar(stat)
    if stat then
        show_status_bar(false)
        boxes = {}
        hs.fnutils.each(
            hs.screen.allScreens(),
            function(scr)
                local box = hs.drawing.rectangle(hs.geometry.rect(0, 0, 0, 0))
                draw_rectangle(box, scr, 0, scr:fullFrame().w, hs.drawing.color.red)
                table.insert(boxes, box)
            end
        )
    else
        hs.fnutils.each(
            boxes,
            function(box)
                box:delete()
            end
        )
        boxes = {}
    end
end

function isInScreen(screen, win)
    return win:screen() == screen
end

function draw_rectangle(target_draw, screen, offset, width, fill_color)
    local screeng = screen:fullFrame()
    local screen_frame_height = screen:frame().y
    local screen_full_frame_height = screeng.y
    local height_delta = screen_frame_height - screen_full_frame_height
    local height = 23

    target_draw:setSize(hs.geometry.rect(screeng.x + offset, screen_full_frame_height, width, height))
    target_draw:setTopLeft(hs.geometry.point(screeng.x + offset, screen_full_frame_height))
    target_draw:setFillColor(fill_color)
    target_draw:setFill(true)
    target_draw:setAlpha(0.5)
    target_draw:setLevel(hs.drawing.windowLevels.overlay)
    target_draw:setStroke(false)
    target_draw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
    target_draw:show()
end

function setVimDisplay(state)
    if state then
        vim_icon:setTitle(cfg.icon.vim)
    else
        vim_icon:setTitle(cfg.icon.novim)
    end
end

function rapidKey(modifiers, key)
    modifiers = modifiers or {}
    return function()
        hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
        hs.timer.usleep(cfg.key_interval)
        hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
    end
end

function inputKey(modifiers, key)
    modifiers = modifiers or {}
    return function()
        hs.eventtap.keyStroke(modifiers, key)
    end
end

return obj
