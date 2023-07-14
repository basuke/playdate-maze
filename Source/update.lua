import "maze"

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
    gfx.setLineWidth(thicknes)
    gfx.setLineCapStyle(gfx.kLineCapStyleRound)

    function drawLine(x0, y0, x1, y1)
        if (x1 < left or x0 > right or y1 < top or y0 > bottom) then
            return
        end
        gfx.drawLine(x0 - ox, y0 - oy, x1 - ox, y1 - oy)
    end

    local mx, my = mazeSize(maze)
    local n, e, s, w

    for y = 1, my do
        local y0 = (y - 1) * cellSize + params.marginV
        local y1 = y0 + cellSize

        for x = 1, mx do
            local x0 = (x - 1) * cellSize + params.marginH
            local x1 = x0 + cellSize

            n, e, s, w = getWalls(maze, x, y)
            if (n) then
                drawLine(x0, y0, x1, y0)
            end
            if (w) then
                drawLine(x0, y0, x0, y1)
            end
            if (x == mx and e) then
                drawLine(x1, y0, x1, y1)
            end
            if (y == my and s) then
                drawLine(x0, y1, x1, y1)
            end
        end
    end
end

