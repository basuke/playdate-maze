import "update"
import "player"

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
    }

    sprite.setBackgroundDrawingCallback(function()
        drawMaze(maze)
    end)

    function playdate.update()
        sprite.update()
    end

    player:moveTo(playerPosition(game))
    return game
end

function playerPosition(game)
    local size = game.params.size
    local shiftH = game.params.marginH + size / 2
    local shiftV = game.params.marginV + size / 2

    return (game.x - 1) * size + shiftH, (game.y - 1) * size + shiftV
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

    if (dir == N) then
        y = y - 1
    elseif (dir == E) then
        x = x + 1
    elseif (dir == S) then
        y = y + 1
    elseif (dir == W) then
        x = x - 1
    end

    if y < 1 or y > height or x < 1 or x > width then
        return false
    end

    game.x = x
    game.y = y
    player:moveTo(playerPosition(game))

    return true
end