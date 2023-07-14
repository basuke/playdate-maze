import "update"
import "player"
import "constants"

local gfx = playdate.graphics
local sprite = gfx.sprite

N = "N"
E = "E"
S = "S"
W = "W"

function game(maze)
    local params = dimentionParams(#maze[1], #maze)
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
        x -= ox
        y -= oy
        drawMaze(maze, params, ox, oy, x, y, x + width, y +height)
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

    _newOffset(game)

    gfx.setDrawOffset(game.offsetX, game.offsetY)
    player:moveBy(dx, dy)
    sprite.redrawBackground()
end

function _newOffset(game)
    local ox, oy = game.offsetX, game.offsetY
    local player, params = game.player, game.params
    local x, y = player.x, player.y
    -- local vx, vy = params.visibleSize()
    -- local fx, fy = params.freeSize()

    -- vx, vy = vx + ox, vy + oy
    -- fx, fy = fx + ox, fy + oy

    function calc(oy, y, size, limit, margin)
        if (y > 100) then
            oy = -(y - 100)
        end

        if (oy > 0) then
            oy = 0
        end

        if (oy < 0) then
            oy = 0
        end

        return oy
    end

    game.offsetX, game.offsetY = ox, oy
end

function _playerCoordinate(game)
    local size = game.params.cellSize
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