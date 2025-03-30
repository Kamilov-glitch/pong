local Ball = Object:extend()

function Ball:new(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.speedX = 200
    self.speedY = 200
    self:randomizeDirection()
end

function Ball:update(dt)
    if checkCollision(self, leftPaddle) or checkCollision(self, rightPaddle) then
        self.speedX = -self.speedX

        -- Play collision sound
        love.audio.play(collisionSound)

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

function Ball:randomizeDirection()
    -- Use a base speed to maintain consistent speed
    local baseSpeed = 300
    
    -- Create more interesting angles by ensuring significant vertical component
    -- Choose an angle between 30-60 or 120-150 degrees (for going right)
    -- or between 210-240 or 300-330 degrees (for going left)
    local angle
    if math.random() < 0.5 then
        -- Left direction
        if math.random() < 0.5 then
            angle = math.rad(math.random(210, 240)) -- Down-left
        else
            angle = math.rad(math.random(300, 330)) -- Up-left
        end
    else
        -- Right direction
        if math.random() < 0.5 then
            angle = math.rad(math.random(30, 60))  -- Down-right
        else
            angle = math.rad(math.random(120, 150)) -- Up-right
        end
    end
    
    -- Set velocity components based on angle with consistent speed
    self.speedX = baseSpeed * math.cos(angle)
    self.speedY = baseSpeed * math.sin(angle)
end

return Ball
