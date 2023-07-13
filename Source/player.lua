import "CoreLibs/graphics"
import "CoreLibs/sprites"

local sprite = playdate.graphics.sprite
local gfx = playdate.graphics

class('Player').extends(sprite)

function Player:init()
	local textImage, _ = gfx.imageWithText("@", 32, 32)

    Player.super.init(self, textImage) -- this is critical
    self:moveTo(24, 24)
end

function Player:moveLeft()
    self:moveBy(-32, 0)
end

function Player:moveRight()
    self:moveBy(32, 0)
end

function Player:moveUp()
    self:moveBy(0, -32)
end

function Player:moveDown()
    self:moveBy(0, 32)
end

local sprite = Player(100, 100)

function playerSprite()
    local s = Player()
    s:add()
    return s
end
