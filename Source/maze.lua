import "constants"
import "utils"

function generateMaze(width, height)
    local maze = {}

    local grids = {}
    local gx, gy = width * 2 + 1, height * 2 + 1
    local gridSize = gx * gy

    for i = 1, gridSize do
        grids[i] = true
    end

    local function canDig(x, y, index, dir)
        if (x < 1 or x > width or y < 1 or y > height) then
            return false
        end
        if (grids[index]) then
            return false
        end
        return true
    end

    local deltas = { N = -gx, E = 1, S = gx, W = -1 }
    local deltasX = { N = 0, E = 1, S = 0, W = -1 }
    local deltasY = { N = -1, E = 0, S = 1, W = 0 }

    local function canConnect(x, y, index, dir)
        -- check the cell is already digged yet the wall exists between cells
        x = x + deltasX[dir]
        y = y + deltasY[dir]
        if (x < 1 or x > width or y < 1 or y > height) then
            return nil
        end

        local delta = deltas[dir]
        return grids[index + delta] and not grids[index + delta * 2]
    end

    local function connectableWalls(x, y, index)
        -- returns wall directions where cells can be connected through
        local walls = {}

        if (canConnect(x, y, index, N)) then
            table.insert(walls, N)
        end
        if (canConnect(x, y, index, W)) then
            table.insert(walls, W)
        end
        if (canConnect(x, y, index, S)) then
            table.insert(walls, S)
        end
        if (canConnect(x, y, index, E)) then
            table.insert(walls, E)
        end
        return walls
    end

    local function connectableWall(x, y, index)
        -- returns wall directions where cells can be connected through
        local walls = connectableWalls(x, y, index)
        return randomPick(walls)
    end

    local function canDig(x, y, index, dir)
        -- check the cell is not digged
        x = x + deltasX[dir]
        y = y + deltasY[dir]
        if (x < 1 or x > width or y < 1 or y > height) then
            return nil
        end

        return grids[index + deltas[dir] * 2]
    end

    local function diggableWalls(x, y, index)
        -- returns directions where we can dig
        local walls = {}

        if (canDig(x, y, index, N)) then
            table.insert(walls, N)
        end
        if (canDig(x, y, index, W)) then
            table.insert(walls, W)
        end
        if (canDig(x, y, index, S)) then
            table.insert(walls, S)
        end
        if (canDig(x, y, index, E)) then
            table.insert(walls, E)
        end
        return walls
    end

    local function diggableWall(x, y, index)
        -- returns random direction where we can dig
        local walls = diggableWalls(x, y, index)
        return randomPick(walls)
    end

    local function randomDirection()
        return randomPick(directions)
    end

    local function pickUndiggedConnectable()
        while (true) do
            local x = math.random(width)
            local y = math.random(height)
            local index = _index(gx, x, y)
            if (grids[index]) then
                local dir = connectableWall(x, y, index)
                if (dir) then
                    return x, y, index, dir
                end
            end
        end
    end

    local count = width * height

    function dig(x, y, index)
        print("digging", x, y)
        grids[index] = false
        count = count - 1
    end

    function breakWall(x, y, index, dir)
        print("breaking wall", x, y, dir)
        grids[index + deltas[dir]] = false
    end

    local x, y = 1, 1
    local index = _index(gx, x, y)
    breakWall(x, y, index, N)
    dig(x, y, index)

    while (count) do
        dig(x, y, index)

        while (count > 0) do
            local dir = diggableWall(x, y, index)
            if (not dir) then
                print("end dig")
                break
            end

            breakWall(x, y, index, dir)

            index = index + deltas[dir] * 2
            x = x + deltasX[dir]
            y = y + deltasY[dir]
            dig(x, y, index)
        end

        if (count < 1) then
            index = _index(gx, width, height)
            breakWall(width, height, index, S)
            break
        end

        x, y, index, dir = pickUndiggedConnectable()
        breakWall(x, y, index, dir)
    end

    return {
        width = width,
        height = height,
        grids = grids,
        gx = gx,
        gy = gy,
    }
end

function mazeSize(maze)
    return maze.width, maze.height
end

function canMove(maze, x, y, dir)
    return not getWall(maze, x, y, dir)
end

function getWalls(maze, x, y)
    local grids = maze.grids
    local index = _index(maze.gx, x, y)
    return grids[index - maze.gx], grids[index + 1], grids[index + maze.gx], grids[index - 1]
end

function getWall(maze, x, y, dir)
    local index = _index(maze.gx, x, y)
    if (dir == N) then
        index = index - maze.gx
    elseif (dir == E) then
        index = index + 1
    elseif (dir == S) then
        index = index + maze.gx
    elseif (dir == W) then
        index = index - 1
    end
    return maze.grids[index]
end

function _index(gx, x, y)
    return (y * 2 - 1) * gx + x * 2
end