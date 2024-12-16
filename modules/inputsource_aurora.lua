local boxes = {}
local box_alpha = 0.5

local inputEnglish = "com.apple.keylayout.ABC"
local inputKorean = "com.apple.inputmethod.Korean"
local inputJapanese = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"

-- 입력 소스별 색상 매핑
-- @see https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/drawing/color/drawing_color.lua#L170
local input_source_colors = {
    [inputKorean] = hs.drawing.color.osx_green,
    [inputJapanese] = hs.drawing.color.x11.indianred
}
local default_color = hs.drawing.color.osx_green

-- 입력소스 변경 이벤트에 이벤트 리스너를 달아준다
hs.keycodes.inputSourceChanged(
    function()
        local input_source = hs.keycodes.currentSourceID()
        if input_source == inputEnglish then
            disable_show()
        else
            local color = input_source_colors[input_source] or default_color
            enable_show(color)
        end
    end
)

function enable_show(color)
    disable_show() -- 기존 표시 제거
    reset_boxes()
    hs.fnutils.each(
        hs.screen.allScreens(),
        function(scr)
            show_aurora(scr, color)
        end
    )
end

function disable_show()
    hs.fnutils.each(
        boxes,
        function(box)
            if not (box == nil) then
                box:delete()
            end
        end
    )
    reset_boxes()
end

function show_aurora(scr, color)
    local box = hs.drawing.rectangle(hs.geometry.rect(0, 0, 0, 0))
    draw_rectangle(box, scr, 0, scr:fullFrame().w, color)
    table.insert(boxes, box)
end

function reset_boxes()
    boxes = {}
end

function draw_rectangle(target_draw, screen, offset, width, fill_color)
    local screeng = screen:fullFrame()
    local screen_frame_height = screen:frame().y
    local screen_full_frame_height = screeng.y
    local height_delta = screen_frame_height - screen_full_frame_height
    local height = screen:frame().y

    target_draw:setSize(hs.geometry.rect(screeng.x + offset, screen_full_frame_height, width, height))
    target_draw:setTopLeft(hs.geometry.point(screeng.x + offset, screen_full_frame_height))
    target_draw:setFillColor(fill_color)
    target_draw:setFill(true)
    target_draw:setAlpha(box_alpha)
    target_draw:setLevel(hs.drawing.windowLevels.overlay)
    target_draw:setStroke(false)
    target_draw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
    target_draw:show()
end
