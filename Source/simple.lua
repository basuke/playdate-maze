function generateMaze(width, height)
    local maze = {}

    local opposites = { N = "S", E = "W", S = "N", W = "E" }

    for i = 1, height do
        maze[i] = {}
        for j = 1, width do
            maze[i][j] = { N = true, E = true, S = true, W = true, visited = false }
        end

    end

    function canDig(x, y)
        if (x < 1 or x > width or y < 1 or y > height) then
            return false
        end

        local cell = maze[y][x]
        return not cell.visited
    end

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

            if (canDig(nx, ny)) then
                cell[dir] = false
                dig(nx, ny, dir)
            end
        end
    end

    dig(1, 1, "S")

    return maze
end

function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

function printMaza(maze)
    function printLine(cells, dir)
        local line = ""
        for x = 1, #cells do
            cell = cells[x]
            if (cell[dir]) then
                line = line .. "####"
            else
                line = line .. "#  #"
            end
        end
        print(line)
    end

    for y = 1, #maze do
        local cells = maze[y]

        printLine(cells, "N")
        local line = ""
        for x = 1, #cells do
            cell = cells[x]
            if (cell.W) then
                line = line .. "#"
            else
                line = line .. " "
            end
            line = line .. "  "
            if (cell.E) then
                line = line .. "#"
            else
                line = line .. " "
            end
        end
        print(line)

        if (y == #maze) then
            printLine(cells, "S")
        end
    end
end
