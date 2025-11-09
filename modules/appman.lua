local obj = {}
local app_mode = hs.hotkey.modal.new()

local function findRunningAppByExactName(name)
    for _, a in ipairs(hs.application.runningApplications()) do
        if a and a:name() == name then
            return a
        end
    end
    return nil
end

function obj:toggle(name)
    return function()
        local front = hs.application.frontmostApplication()
        if front then
            local p = front:path()
            if p then
                local lp = string.lower(p)
                local needle = string.lower(name) .. "%.app$"
                if string.match(lp, needle) then
                    return front:hide()
                end
            end
        end

        -- Prefer activating a running app that exactly matches the given name
        local app = findRunningAppByExactName(name)
        if app then
            app:unhide()
            app:activate(true)
            local win = app:mainWindow() or app:focusedWindow()
            if not win then
                local wins = app:allWindows()
                if #wins > 0 then win = wins[1] end
            end
            if win then win:focus() end
        else
            hs.application.launchOrFocus(name)
        end

        -- Safely move the mouse to the focused window's center if available
        local fw = hs.window.focusedWindow()
        if fw then
            local pt = hs.geometry.rectMidPoint(fw:frame())
            hs.mouse.setAbsolutePosition(pt)
        end
        app_mode.triggered = true
    end
end

local function focusScreen(screen)
    local windows = hs.fnutils.filter(hs.window.orderedWindows(), hs.fnutils.partial(isInScreen, screen))
    local windowToFocus = #windows > 0 and windows[1] or hs.window.desktop()
    windowToFocus:focus()

    -- Move mouse to center of screen
    local center = hs.geometry.rectMidPoint(screen:fullFrame())
    hs.mouse.setAbsolutePosition(center)
end

function obj.focusPreviousScreen()
    focusScreen(hs.window.focusedWindow():screen():previous())
end

function obj.focusNextScreen()
    focusScreen(hs.window.focusedWindow():screen():next())
end

function obj:init(mod, key)
    -- app_mode:bind({}, ';', function() hs.window.focusedWindow():focusWindowWest() end)
    -- app_mode:bind({}, '/', function() hs.window.focusedWindow():focusWindowSouth() end)
    -- app_mode:bind({}, '[', function() hs.window.focusedWindow():focusWindowNorth() end)
    -- app_mode:bind({}, '\'', function() hs.window.focusedWindow():focusWindowEast() end)

    return self
end

return obj
