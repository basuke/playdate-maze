import "maze"

function dimension(maze)
    local width, height = mazeSize(maze)
    local cellSize = 24
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

    d = {
        size = function() return width, height end,
        cellSize = cellSize,
        wallThickness = 5,
        marginH = marginH,
        marginV = marginV,
        screenSize = function() return sx, sy end,
        viewSize = function() return vx, vy end,

        minOffset = function() return 0, 0 end,
        maxOffset = function() return (vx - sx), (vy - sy) end,

        capOffset = function(ox, oy)
            local minx, miny = d.minOffset()
            local maxx, maxy = d.maxOffset()
            return math.min(maxx, math.max(minx, ox)), math.min(maxy, math.max(miny, oy))
        end,

        offset = function(x, y)
            x = x - sx / 2
            y = y - sy / 2
            return d.capOffset(x, y)
        end,

        playerPosition = function(x, y)
            local shiftH = marginH + cellSize / 2
            local shiftV = marginV + cellSize / 2
        
            return (x - 1) * cellSize + shiftH, (y - 1) * cellSize + shiftV
        end        
    }
    return d
end
