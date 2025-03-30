local Ball = Object:extend()

function Ball:new(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.speedX = 200
    self.speedY = 200
end

function Ball:update(dt)
    if checkCollision(self, leftPaddle) or checkCollision(self, rightPaddle) then
        self.speedX = -self.speedX

        -- Add a small offset to push the ball outside the paddle
        if self.speedX > 0 then
            self.x = self.x + 1
        else
            self.x = self.x - 1
        end
    end
     -- Ball bounces off top and bottom walls
     if self.y - self.radius < 0 or self.y + self.radius > windowHeight then
        self.speedY = -self.speedY
    end
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt
end

function Ball:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Ball
