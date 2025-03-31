local Ball = Object:extend()

function Ball:new(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.baseSpeed = 300
    self.speedX = 0
    self.speedY = 0
    self.maxSpeed = 600  -- Cap the maximum speed
    self.speedIncrement = 15  -- Speed increases with each hit
    self:randomizeDirection()
end

function Ball:update(dt)
    -- Check paddle collisions with angle modification
    if checkCollision(self, leftPaddle) then
        -- Calculate where on the paddle the ball hit (0 = top, 1 = bottom)
        local hitPosition = (self.y - leftPaddle.y) / leftPaddle.height
        self:deflect(hitPosition, 1)
        
        -- Play collision sound
        love.audio.play(collisionSound)
    elseif checkCollision(self, rightPaddle) then
        -- Calculate where on the paddle the ball hit (0 = top, 1 = bottom)
        local hitPosition = (self.y - rightPaddle.y) / rightPaddle.height
        self:deflect(hitPosition, -1)
        
        -- Play collision sound
        love.audio.play(collisionSound)
    end
    
    -- Ball bounces off top and bottom walls
    if self.y - self.radius < 0 then
        self.y = self.radius  -- Prevent sticking to the wall
        self.speedY = math.abs(self.speedY)
    elseif self.y + self.radius > windowHeight then
        self.y = windowHeight - self.radius  -- Prevent sticking to the wall
        self.speedY = -math.abs(self.speedY)
    end

    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt
end

-- New function to handle paddle deflections with angle changes
function Ball:deflect(hitPosition, direction)
    -- Increase ball speed slightly with each hit (up to max speed)
    local currentSpeed = math.sqrt(self.speedX^2 + self.speedY^2)
    local newSpeed = math.min(currentSpeed + self.speedIncrement, self.maxSpeed)
    
    -- Calculate new angle based on where the ball hit the paddle
    -- Center hit (0.5) = straight reflection
    -- Top hit (0.0) = upward angle
    -- Bottom hit (1.0) = downward angle
    local angle = (hitPosition - 0.5) * math.pi * 0.7  -- 0.7 controls the max deflection angle
    
    -- Set new velocities
    self.speedX = direction * newSpeed * math.cos(angle)
    self.speedY = newSpeed * math.sin(angle)
    
    -- Add a small offset to push the ball outside the paddle
    self.x = self.x + direction * (self.radius + 1)
end

function Ball:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

function Ball:randomizeDirection()
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
    self.speedX = self.baseSpeed * math.cos(angle)
    self.speedY = self.baseSpeed * math.sin(angle)
end

return Ball