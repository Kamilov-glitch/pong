local Rectangle = Object:extend()

function Rectangle:new(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = 250
end

function Rectangle:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Rectangle