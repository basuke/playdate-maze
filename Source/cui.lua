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
