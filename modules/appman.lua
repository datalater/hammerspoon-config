local obj = {}
local app_mode = hs.hotkey.modal.new()

local function escape_lua_pattern(s)
    return (s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
end

local function matchesBundleByName(app, name)
    if not app or not name then return false end
    local p = app:path()
    if not p then
        -- Fallback to exact display name when path is unavailable
        return app:name() == name
    end
    local lp = string.lower(p)
    local escaped = escape_lua_pattern(string.lower(name))
    local needle = "/" .. escaped .. "%.app$"
    return string.match(lp, needle) ~= nil
end

local function normalizeTarget(target)
    local normalized
    if type(target) == "string" then
        normalized = {name = target}
    elseif type(target) == "table" then
        normalized = {
            name = target.name or target[1],
            bundleID = target.bundleID or target.bundleId or target.id,
            path = target.path
        }
    else
        error("toggle target must be a string or table", 2)
    end

    if normalized.path then
        local abs = hs.fs and hs.fs.pathToAbsolute(normalized.path) or nil
        normalized.path = abs or normalized.path
        normalized._pathLower = string.lower(normalized.path)
    end

    if not (normalized.name or normalized.bundleID or normalized.path) then
        error("toggle target requires at least one of name, bundleID, or path", 2)
    end

    return normalized
end

local function matchesTarget(app, target)
    if not app or not target then return false end

    if target.bundleID then
        local ok, bundleID = pcall(function() return app:bundleID() end)
        if ok and bundleID == target.bundleID then return true end
    end

    if target._pathLower then
        local p = app:path()
        if p and string.lower(p) == target._pathLower then
            return true
        end
    end

    if target.name then
        return matchesBundleByName(app, target.name)
    end

    return false
end

local function findRunningApp(target)
    for _, a in ipairs(hs.application.runningApplications()) do
        if matchesTarget(a, target) then
            return a
        end
    end
    return nil
end

local function launchTarget(target)
    if target.bundleID then
        local ok, res = pcall(hs.application.launchOrFocusByBundleID, target.bundleID)
        if ok and res then return true end
    end

    if target.path then
        local ok = hs.application.launchOrFocus(target.path)
        if ok then return true end
    end

    if target.name then
        return hs.application.launchOrFocus(target.name)
    end

    return false
end

local function focusWindow(win)
    if not win then return end
    if win:isMinimized() then win:unminimize() end
    win:focus()
end

function obj:toggle(name)
    local target = normalizeTarget(name)
    return function()
        local front = hs.application.frontmostApplication()
        if front and matchesTarget(front, target) then
            return front:hide()
        end

        -- Prefer activating a running app that exactly matches the bundle name
        local app = findRunningApp(target)
        if app then
            app:unhide()
            app:activate(true)
            local win = app:mainWindow() or app:focusedWindow()
            if not win then
                local wins = app:allWindows()
                if #wins > 0 then win = wins[1] end
            end
            focusWindow(win)
        else
            launchTarget(target)
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
