import "game"

local game = game()

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
