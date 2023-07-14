import = require

require "maze"

function printMaza(maze)
    local mx, my = mazeSize(maze)

    function hline(y, dir)
        local line = ""
        for x = 1, mx do
            local n, e, s, w = getWalls(maze, x, y)
            if ((dir == N and n) or (dir == S and s)) then
                line = line .. "####"
            else
                line = line .. "#  #"
            end
        end
        return line
    end

    for y = 1, my do
        print(hline(y, "N"))
        local line = ""
        for x = 1, mx do
            local n, e, s, w = getWalls(maze, x, y)

            if (w) then
                line = line .. "#"
            else
                line = line .. " "
            end
            line = line .. "  "
            if (e) then
                line = line .. "#"
            else
                line = line .. " "
            end
        end
        print(line)
    end
    print(hline(my, "S"))
end

local maze = generateMaze(20, 20)
printMaza(maze)
