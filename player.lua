local rectangle = require "rectangle"
local Player = rectangle:extend()

function Player:new(x, y, width, height)
    Player.super.new(self, x, y, width, height)
end

function Player:update(dt)
    if love.keyboard.isDown("up") then
        self.y = math.max(0, self.y - self.speed * dt)
    elseif love.keyboard.isDown("down") then
        self.y = math.min(love.graphics.getHeight() - self.height, self.y + self.speed * dt)
    end
end

return Player