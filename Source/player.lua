import "CoreLibs/graphics"
import "CoreLibs/sprites"

local sprite = playdate.graphics.sprite
local gfx = playdate.graphics

class('Player').extends(sprite)

function Player:init()
	local textImage, _ = gfx.imageWithText("@", 32, 32)

    Player.super.init(self, textImage) -- this is critical
end

function playerSprite()
    local s = Player()
    s:add()
    return s
end
