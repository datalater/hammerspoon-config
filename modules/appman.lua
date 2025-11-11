local obj = {}
local app_mode = hs.hotkey.modal.new()

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

function obj:toggle(name)
    local target = normalizeTarget(name)

    return function()
        if target.bundleID then
            local front = hs.application.frontmostApplication()
            local ok, bundleID = pcall(function() return front:bundleID() end)
            
            if ok and bundleID == target.bundleID then
                return front:hide()
            end 

            local ok, res = pcall(hs.application.launchOrFocusByBundleID, target.bundleID)
            if ok and res then 
                return  
            end
        else
            local activated = hs.application.frontmostApplication()
            local path = string.lower(activated:path())

            if string.match(path, string.lower(name) .. "%.app$") then
                return activated:hide()
            end

            hs.application.launchOrFocus(name)
        end

        -- 👉 전환된 앱의 중앙으로 마우스 이동하고 싶으면 아래 주석 해제
        -- local screen = hs.window.focusedWindow():frame()
        -- local pt = hs.geometry.rectMidPoint(screen)
        -- hs.mouse.absolutePosition(pt)
    
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
