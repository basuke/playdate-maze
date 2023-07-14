if (not import) then
    import = require
end

import "simple"

local maze = generateMaze(36, 36)

if (playdate) then
    import "update"
    import "game"

    local game = game(maze)

    function playdate.upButtonDown()
        moveTo(game, N)
    end

    function playdate.downButtonDown()
        moveTo(game, S)
    end

    function playdate.leftButtonDown()
        moveTo(game, W)
    end

    function playdate.rightButtonDown()
        moveTo(game, E)
    end

    function playdate.cranked(change)
        local threashold = 15
        if change > threashold then
            redo(game)
        elseif change < -threashold then
            undo(game)
        end
    
    end    
else    
    import "cui"
    printMaza(maze)
end
