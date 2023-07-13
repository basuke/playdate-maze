local gfx = playdate.graphics
local display = playdate.display

function drawMaze(maze)
    local width = #maze[1]
    local height = #maze

    local size = 32
    local marginH = (display.getWidth() - width * size) / 2
    local marginV = (display.getHeight() - height * size) / 2

    gfx.clear(gfx.kColorWhite)
    gfx.setColor(gfx.kColorBlack)
    gfx.setLineWidth(5)
    gfx.setLineCapStyle(gfx.kLineCapStyleRound)

    for y = 1, #maze do
        local cells = maze[y]
        local top = (y - 1) * size + marginV
        local bottom = top + size

        for x = 1, #cells do
            local cell = cells[x]
            local left = (x - 1) * size + marginH
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

