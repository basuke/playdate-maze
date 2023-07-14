local gfx = playdate.graphics
local display = playdate.display

function dimentionParams(width, height)
    local cellSize = 16
    local minMargin = 8
    local clearance = 3 -- how many cells to keep visible around the edges

    local mx, my = width * cellSize, height * cellSize

    local sx, sy = display.getSize()

    local function calcMargin(s, m)
        local margin = math.floor((s - m) / 2)
        if (margin < minMargin) then
            return minMargin
        end
        return margin
    end

    local marginH, marginV = calcMargin(sx, mx), calcMargin(sy, my)

    local vx, vy = mx + marginH * 2, my + marginV * 2
    local fx, fy = sx - clearance * cellSize, sy - clearance * cellSize

    return {
        size = function() return width, height end,
        width = width,
        height = height,
        cellSize = cellSize,
        wallThickness = 5,
        marginH = marginH,
        marginV = marginV,
        mazeSize = function() return width, height end,
        screenSize = function() return sx, sy end,
        viewRect = function(ox, oy) return vx, vy end,
        freeSize = function () return fx, fy end,
    }
end

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

