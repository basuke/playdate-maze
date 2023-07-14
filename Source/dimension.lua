function dimension(width, height)
    local cellSize = 16
    local minMargin = 8
    local clearance = 3 -- how many cells to keep visible around the edges

    local mx, my = width * cellSize, height * cellSize

    local sx, sy = playdate.display.getSize()

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

        playerPosition = function(x, y)
            local shiftH = marginH + cellSize / 2
            local shiftV = marginV + cellSize / 2
        
            return (x - 1) * cellSize + shiftH, (y - 1) * cellSize + shiftV
        end        
    }
end
