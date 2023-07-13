if (not import) then
    import = require
end

import "simple"

local maze = generateMaze(12, 7)

if (playdate) then
    import "update"
    import "player"

    local sprite = playdate.graphics.sprite

    local s = playerSprite()

    sprite.setBackgroundDrawingCallback(function()
        drawMaze(maze)
    end)

    function playdate.update()
        sprite.update()
    end

    function playdate.upButtonDown()
        s:moveUp()
    end

    function playdate.downButtonDown()
        s:moveDown()
    end

    function playdate.leftButtonDown()
        s:moveLeft()
    end

    function playdate.rightButtonDown()
        s:moveRight()
    end
else    
    import "cui"
    printMaza(maze)
end
