import "update"
import "player"
import "constants"

local sprite = playdate.graphics.sprite

N = "N"
E = "E"
S = "S"
W = "W"

function game(maze)
    local params = dimentionParams(maze)
    local player = playerSprite()

    local game = {
        maze = maze,
        player = player,
        params = params,
        x = 1,
        y = 1,
        undos = {},
        redos = {},
        targets = {},
    }

    sprite.setBackgroundDrawingCallback(function()
        drawMaze(maze)
    end)

    function playdate.update()
        idle(game)
        sprite.update()
    end

    player:moveTo(_playerCoordinate(game))
    return game
end

function idle(game)
    if (#game.targets == 0) then
        return
    end

    local player = game.player
    local x, y = player:getPosition()

    local target = game.targets[1]
    local tx, ty = target.x, target.y
    local dx, dy = tx - x, ty - y

    if (dx == 0 and dy == 0) then
        table.remove(game.targets, 1)
        return
    end

    local speed = 100 -- pixels per second
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
end

function _playerCoordinate(game)
    local size = game.params.size
    local shiftH = game.params.marginH + size / 2
    local shiftV = game.params.marginV + size / 2

    return (game.x - 1) * size + shiftH, (game.y - 1) * size + shiftV
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

    x, y = _playerCoordinate(game)
    table.insert(game.targets, { x = x, y = y })
    idle(game)
end

function moveTo(game, dir)
    local maze = game.maze
    local width, height = #maze[1], #maze
    local player = game.player
    local x, y = game.x, game.y

    local cell = maze[y][x]
    if (cell[dir]) then
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