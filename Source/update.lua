local gfx = playdate.graphics

function drawMaze(maze, params, ox, oy, left, top, right, bottom)
    local cellSize = params.cellSize
    local thicknes = params.wallThickness

    left = left - thicknes
    right = right + thicknes
    top = top - thicknes
    bottom = bottom + thicknes

    gfx.clear(gfx.kColorWhite)
    gfx.setColor(gfx.kColorBlack)
    gfx.setLineWidth(params.wallThickness)
    gfx.setLineCapStyle(gfx.kLineCapStyleRound)

    function drawLine(x0, y0, x1, y1)
        if (x1 < left or x0 > right or y1 < top or y0 > bottom) then
            return
        end
        gfx.drawLine(ox + x0, oy + y0, ox + x1, oy + y1)
    end

    for y = 1, #maze do
        local cells = maze[y]
        local y0 = (y - 1) * cellSize + params.marginV
        local y1 = y0 + cellSize

        for x = 1, #cells do
            local cell = cells[x]
            local x0 = (x - 1) * cellSize + params.marginH
            local x1 = x0 + cellSize

            if (cell.N) then
                drawLine(x0, y0, x1, y0)
            end
            if (cell.E) then
                drawLine(x1, y0, x1, y1)
            end
            if (cell.S) then
                drawLine(x0, y1, x1, y1)
            end
            if (cell.W) then
                drawLine(x0, y0, x0, y1)
            end
        end
    end
end

