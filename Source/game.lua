import "update"
import "player"
import "constants"
import "dimension"
import "maze"

local gfx = playdate.graphics
local sprite = gfx.sprite

function game()
    local maze = generateMaze(28, 28)
    local params = dimension(maze)
    local player = playerSprite()

    local game = {
        maze = maze,
        player = player,
        params = params,
        x = 1,
        y = 1,
        offsetX = 0,
        offsetY = 0,
        undos = {},
        redos = {},
        targets = {},
    }

    gfx.setDrawOffset(0, 0)

    sprite.setBackgroundDrawingCallback(function(x, y, width, height)
        local ox, oy = game.offsetX, game.offsetY
        x += ox
        y += oy
        drawMaze(maze, params, ox, oy, x, y, x + width, y +height)
    end)

    function playdate.update()
        idle(game)
        sprite.update()
    end

    player:moveTo(params.playerPosition(1, 1))

    return game
end

function idle(game)
    if (#game.targets > 0) then
        local player = game.player
        local x, y = player:getPosition()

        local target = game.targets[1]
        local tx, ty = target[1], target[2]
        local dx, dy = tx - x, ty - y
    
        if (dx == 0 and dy == 0) then
            table.remove(game.targets, 1)
            return
        end
    
        local speed = 160 -- pixels per second
        local dp = speed / playdate.getFPS()
    
        if (dx > 0 and dx > dp) then
            dx = dp
        elseif (dx < 0 and dx < -dp) then
            dx = -dp
        end
    
        if (dy > 0 and dy > dp) then
            dy = dp
        elseif (dy < 0 and dy < -dp) then
            dy = -dp
        end
        player:moveBy(dx, dy)
    else
        local buttonStates = playdate.getButtonState()
        if (buttonStates & playdate.kButtonUp ~= 0) then
            moveTo(game, N)
        elseif (buttonStates & playdate.kButtonDown ~= 0) then
            moveTo(game, S)
        elseif (buttonStates & playdate.kButtonLeft ~= 0) then
            moveTo(game, W)
        elseif (buttonStates & playdate.kButtonRight ~= 0) then
            moveTo(game, E)
        end
    end

    _newOffset(game)

    gfx.setDrawOffset(-game.offsetX, -game.offsetY)
    sprite.redrawBackground()
end

function _newOffset(game)
    local player, params = game.player, game.params
    local x, y = player.x, player.y
    local ox, oy = params.offset(x, y)
    game.offsetX, game.offsetY = ox, oy
end

function _newLocation(x, y, dir)
    if (dir == N) then
        y = y - 1
    elseif (dir == E) then
        x = x + 1
    elseif (dir == S) then
        y = y + 1
    elseif (dir == W) then
        x = x - 1
    end

    return x, y
end

function _movePlayerTo(game, x, y)
    game.x = x
    game.y = y

    table.insert(game.targets, { game.params.playerPosition(x, y) })
    idle(game)
end

function moveTo(game, dir)
    local width, height = game.params.size()
    local player = game.player
    local x, y = game.x, game.y

    if (not canMove(game.maze, x, y, dir)) then
        return false
    end

    x, y = _newLocation(x, y, dir)
    if y < 1 or y > height or x < 1 or x > width then
        return false
    end

    _movePlayerTo(game, x, y)
    table.insert(game.undos, dir)
    game.redos = {}

    return true
end

function undo(game)
    if (#game.undos == 0) then
        return false
    end

    local move = table.remove(game.undos, #game.undos)
    table.insert(game.redos, move)
    local x, y = _newLocation(game.x, game.y, opposites[move])
    _movePlayerTo(game, x, y)

    return true
end

function redo(game)
    if (#game.redos == 0) then
        return false
    end

    local move = table.remove(game.redos, #game.redos)
    table.insert(game.undos, move)
    local x, y = _newLocation(game.x, game.y, move)
    _movePlayerTo(game, x, y)

    return true
end