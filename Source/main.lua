if (not import) then
    import = require
end

import "simple"

local maze = generateMaze(12, 7)

if (playdate) then
    import "update"
    function playdate.update()
        drawMaze(maze)
    end
else
    import "cui"
    printMaza(maze)
end
