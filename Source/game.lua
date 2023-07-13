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
    }

    sprite.setBackgroundDrawingCallback(function()
        drawMaze(maze)
    end)

    function playdate.update()
        sprite.update()
    end

    player:moveTo(_playerCoordinate(game))
    return game
end

function _playerCoordinate(game)
    local size = game.params.size
    local shiftH = game.params.marginH + size / 2
    local shiftV = game.params.marginV + size / 2

    return (game.x - 1) * size + shiftH, (game.y - 1) * size + shiftV
end

function _newPosition(x, y, dir)
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
    game.player:moveTo(_playerCoordinate(game))
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

    x, y = _newPosition(x, y, dir)
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
    local x, y = _newPosition(game.x, game.y, opposites[move])
    _movePlayerTo(game, x, y)

    return true
end

function redo(game)
    if (#game.redos == 0) then
        return false
    end

    local move = table.remove(game.redos, #game.redos)
    table.insert(game.undos, move)
    local x, y = _newPosition(game.x, game.y, move)
    _movePlayerTo(game, x, y)

    return true
end