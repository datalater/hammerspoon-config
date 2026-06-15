local left, right = 0, 1
local top, mid = 0, 1

local half_width, full_width = 2, 1
local half_height, full_height = 2, 1
local copied_window_frame = nil
local copied_window_frame_key = "hammerspoon_winmove_copied_window_frame"
local copied_window_frame_loaded = false

local function clone_frame(frame)
    return {
        x = frame.x,
        y = frame.y,
        w = frame.w,
        h = frame.h
    }
end

local function is_number(value)
    return type(value) == "number"
end

local function is_valid_frame(frame)
    if type(frame) ~= "table" then
        return false
    end

    return is_number(frame.x)
        and is_number(frame.y)
        and is_number(frame.w)
        and is_number(frame.h)
end

local function load_copied_window_frame()
    if copied_window_frame then
        return copied_window_frame
    end

    if copied_window_frame_loaded then
        return nil
    end

    copied_window_frame_loaded = true
    local stored_frame = hs.settings.get(copied_window_frame_key)
    if not is_valid_frame(stored_frame) then
        return nil
    end

    copied_window_frame = clone_frame(stored_frame)
    return copied_window_frame
end

local function save_copied_window_frame(frame)
    if not is_valid_frame(frame) then
        return false
    end

    copied_window_frame = clone_frame(frame)
    copied_window_frame_loaded = true
    hs.settings.set(copied_window_frame_key, copied_window_frame)
    return true
end

local function rounded(value)
    return math.floor(value + 0.5)
end

local function format_frame(frame)
    return string.format("x:%d y:%d w:%d h:%d", rounded(frame.x), rounded(frame.y), rounded(frame.w), rounded(frame.h))
end

local function copy_focused_window_frame()
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert.show("No focused window")
        return
    end

    local frame = clone_frame(win:frame())
    if not save_copied_window_frame(frame) then
        hs.alert.show("Failed to save frame")
        return
    end

    hs.alert.show(string.format("Saved frame: %s", format_frame(frame)))
end

local function apply_copied_window_frame()
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert.show("No focused window")
        return
    end

    local frame = load_copied_window_frame()
    if not frame then
        hs.alert.show("No copied frame")
        return
    end

    win:setFrame(clone_frame(frame))
    hs.alert.show(string.format("Applied frame: %s", format_frame(frame)))
end

local function show_copied_window_frame()
    local frame = load_copied_window_frame()
    if not frame then
        hs.alert.show("No copied frame")
        return
    end

    hs.alert.show(string.format("Copied frame: %s", format_frame(frame)))
end

local function move_win(xx, yy, ww, hh)
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()
        f.x = max.x + (max.w / 2) * xx
        f.y = max.y + (max.h / 2) * yy
        f.w = max.w / ww
        f.h = max.h / hh
        win:setFrame(f)
    end
end

--- Move the focused window to the coords by the ratio of current window.
-- @param {number} xr - The ratio of translation to x.
-- @param {number} yr - The ratio of translation to y.
-- @param {number} wr - The ratio of width of current window.
-- @param {number} hr - The ratio of height of current window.
local function move_win_by_ratio(xr, yr, wr, hr)
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()
        f.x = max.x + (max.w * xr)
        f.y = max.y + (max.h * yr)
        f.w = max.w * wr
        f.h = max.h * hr
        win:setFrame(f)
    end
end

local function left_padding_plus(size)
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()
        prevX = f.x
        prevW = f.w

        f.x = f.x - size

        if f.x < max.x then
            f.x = max.x
        end

        f.w = f.w + (prevX - f.x)
        win:setFrame(f)
    end
end

local function right_padding_plus(size)
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()

        f.w = f.w + size
        fRight = f.x + f.w
        maxRight = max.x + max.w

        if fRight > maxRight then
            f.w = maxRight - f.x
        end

        win:setFrame(f)
    end
end

local function flex_left()
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()
        prevX = f.x

        f.x = max.x
        f.w = f.w + (prevX - f.x)

        win:setFrame(f)
    end
end

local function flex_right()
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()

        maxRight = max.x + max.w
        f.w = maxRight - f.x

        win:setFrame(f)
    end
end

local function flex_top()
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()
        prevY = f.y

        f.y = max.y
        f.h = f.h + (prevY - f.y)

        win:setFrame(f)
    end
end

local function flex_bottom()
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()

        maxBottom = max.y + max.h
        f.h = maxBottom - f.y

        win:setFrame(f)
    end
end

local function move_left()
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()

        f.x = max.x

        win:setFrame(f)
    end
end

local function move_right()
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()

        maxRight = max.x + max.w
        fRight = f.x + f.w
        f.x = f.x + (maxRight - fRight)

        win:setFrame(f)
    end
end

local function move_center()
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()

        diffLeft = f.x - max.x
        maxRight = max.x + max.w
        fRight = f.x + f.w
        diffRight = maxRight - fRight
        diff = diffLeft + diffRight

        f.x = max.x + (diff / 2)

        win:setFrame(f)
    end
end

local function send_window_prev_screen()
    local win = hs.window.focusedWindow()
    local nextScreen = win:screen():previous()
    win:moveToScreen(nextScreen)
end

local function send_window_next_screen()
    local win = hs.window.focusedWindow()
    local nextScreen = win:screen():next()
    win:moveToScreen(nextScreen)
end

return {
    ["default"] = move_win((left + right) / 2, top, half_width, full_height),
    ["left_bottom"] = move_win(left, mid, half_width, half_height),
    ["bottom"] = move_win(left, mid, full_width, half_height),
    ["right_bottom"] = move_win(right, mid, half_width, half_height),
    ["left"] = move_win(left, top, half_width, full_height),
    ["full_screen"] = move_win(left, top, full_width, full_height),
    ["right"] = move_win(right, top, half_width, full_height),
    ["left_top"] = move_win(left, top, half_width, half_height),
    ["top"] = move_win(left, top, full_width, half_height),
    ["right_top"] = move_win(right, top, half_width, half_height),

    ["left_main"] = move_win_by_ratio(0, 0, 1 - 2 / 7, 1),
    ["center_main"] = move_win_by_ratio(1 / 7, 0, 1 - 2 / 7, 1),
    ["right_main"] = move_win_by_ratio(2 / 7, 0, 1 - 2 / 7, 1),
    ["left_sub"] = move_win_by_ratio(0, 0, 2 / 7, 1),
    ["right_sub"] = move_win_by_ratio(5 / 7, 0, 2 / 7, 1),

    ["left_main_2"] = move_win_by_ratio(0, 0, 1 - 2 / 5, 1),
    ["center_main_2"] = move_win_by_ratio(1 / 5, 0, 1 - 2 / 5, 1),
    ["right_main_2"] = move_win_by_ratio(2 / 5, 0, 1 - 2 / 5, 1),
    ["left_sub_2"] = move_win_by_ratio(0, 0, 2 / 5, 1),
    ["right_sub_2"] = move_win_by_ratio(3 / 5, 0, 2 / 5, 1),

    ["left_padding_plus"] = left_padding_plus(20),
    ["right_padding_plus"] = right_padding_plus(10),

    ["flex_left"] = flex_left(),
    ["flex_right"] = flex_right(),
    ["flex_top"] = flex_top(),
    ["flex_bottom"] = flex_bottom(),
    
    ["move_left"] = move_left(),
    ["move_center"] = move_center(),
    ["move_right"] = move_right(),

    ["copy_frame"] = copy_focused_window_frame,
    ["apply_frame"] = apply_copied_window_frame,
    ["show_frame"] = show_copied_window_frame,
    
    ["prev_screen"] = send_window_prev_screen,
    ["next_screen"] = send_window_next_screen
}
