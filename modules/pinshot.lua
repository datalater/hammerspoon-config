local obj = {}
local mouseCircles = {}

function obj.show()
    mouseHighlight()
end

function obj.clear() 
    last = mouseCircles[#mouseCircles]
    if last then last:delete() end

    table.remove(mouseCircles)
end

function obj.clearAll()
    print(hs.inspect.inspect(#mouseCircles))
    print(hs.inspect.inspect(mouseCircles))
    
    if #mouseCircles ~= 0 then
        hs.fnutils.each(mouseCircles, function(circle)
            circle:delete()
        end)
        mouseCircles = {}
    end
end

function mouseHighlight()
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x - 40,
                                                     mousepoint.y - 40, 80, 80))
    mouseCircle:setStrokeColor({
        ["red"] = 1,
        ["blue"] = 0,
        ["green"] = 0,
        ["alpha"] = 1
    })
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    table.insert(mouseCircles, mouseCircle)
end

return obj
