local gfx = playdate.graphics
local display = playdate.display

function dimentionParams(maze)
    local width = #maze[1]
    local height = #maze
    local size = 16

    local marginH = math.floor((display.getWidth() - width * size) / 2)
    local marginV = math.floor((display.getHeight() - height * size) / 2)

    return {
        width = width,
        height = height,
        size = size,
        wallThickness = 5,
        marginH = marginH,
        marginV = marginV,
    }
end

function drawMaze(maze)
    local params = dimentionParams(maze)
    local size = params.size

    gfx.clear(gfx.kColorWhite)
    gfx.setColor(gfx.kColorBlack)
    gfx.setLineWidth(params.wallThickness)
    gfx.setLineCapStyle(gfx.kLineCapStyleRound)

    for y = 1, #maze do
        local cells = maze[y]
        local top = (y - 1) * size + params.marginV
        local bottom = top + size

        for x = 1, #cells do
            local cell = cells[x]
            local left = (x - 1) * size + params.marginH
            local right = left + size

            if (cell.N) then
                gfx.drawLine(left, top, right, top)
            end
            if (cell.E) then
                gfx.drawLine(right, top, right, bottom)
            end
            if (cell.S) then
                gfx.drawLine(left, bottom, right, bottom)
            end
            if (cell.W) then
                gfx.drawLine(left, top, left, bottom)
            end
        end
    end
end

