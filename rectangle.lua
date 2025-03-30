local Rectangle = Object:extend()

function Rectangle:new(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = 250
end

function Rectangle:update(dt)
    if love.keyboard.isDown("up") then
        self.y = math.max(0, self.y - self.speed * dt)
    elseif love.keyboard.isDown("down") then
        self.y = math.min(love.graphics.getHeight() - self.height, self.y + self.speed * dt)
    end
end

function Rectangle:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Rectangle