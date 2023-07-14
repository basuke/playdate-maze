import "constants"
import "utils"

function generateMaze(width, height)
    local maze = {}

    for i = 1, height do
        maze[i] = {}
        for j = 1, width do
            maze[i][j] = { N = true, E = true, S = true, W = true, visited = false }
        end

    end

    function canDig(x, y)
        if (x < 1 or x > width or y < 1 or y > height) then
            return nil
        end

        local cell = maze[y][x]
        if (cell.visited) then
            return nil
        end
        cell.visited = true
        return cell
    end

    local stack = { {1, 1, "S"} }

    function dig(x, y, dir)
        local cell = maze[y][x]
        cell.visited = true
        cell[opposites[dir]] = false

        if (x == width and y == height) then
            cell.S = false
            return
        end

        local dirs = shuffle({ "N", "E", "S", "W" })

        for i = 1, #dirs do
            local dir = dirs[i]
            local nx = x
            local ny = y

            if (dir == "N") then
                ny = ny - 1
            elseif (dir == "E") then
                nx = nx + 1
            elseif (dir == "S") then
                ny = ny + 1
            elseif (dir == "W") then
                nx = nx - 1
            end

            local nextCell = canDig(nx, ny)
            if (nextCell) then
                cell[dir] = false
                nextCell[opposites[dir]] = false

                table.insert(stack, {nx, ny, dir})
            end
        end
    end

    while (#stack > 0) do
        local args = table.remove(stack, #stack)
        local x, y, dir = args[1], args[2], args[3]

        dig(x, y, dir)
    end

    return maze
end

function mazeSize(maze)
    return #maze[1], #maze
end

function canMove(maze, x, y, dir)
    local cell = maze[y][x]
    return not cell[dir]
end

function getWalls(maze, x, y)
    local cell = maze[y][x]
    return cell.N, cell.E, cell.S, cell.W
end
