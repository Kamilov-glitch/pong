local rectangle = require "rectangle"
local Enemy = rectangle:extend()

function Enemy:new(x, y, width, height)
    Enemy.super.new(self, x, y, width, height)
    
    -- Reduced speed makes it physically unable to catch every ball
    self.speed = 180
    
    -- Target position that the AI tries to move toward
    self.targetY = self.y
    
    -- How quickly the AI updates its target (lower = more human-like delay)
    self.reactionSpeed = 0.65
    
    -- How accurately the AI predicts where the ball will be 
    -- (scales from 0.5 near center to 0.9 when ball is close)
    self.accuracy = 0.7
end

function Enemy:update(dt)
    -- Only actively track the ball when it's moving toward the AI
    if gameBall.speedX < 0 then
        -- Calculate "perfect" target (center of paddle aligned with ball)
        local perfectY = gameBall.y - self.height/2
        
        -- Calculate accuracy based on ball's X position (more accurate as ball gets closer)
        local distanceFactor = 1 - (gameBall.x / windowWidth)
        local currentAccuracy = 0.5 + (self.accuracy * distanceFactor)
        
        -- Add some error based on current accuracy
        local errorAmount = (1 - currentAccuracy) * windowHeight * 0.3
        local targetError = math.random(-errorAmount, errorAmount)
        
        -- Update our target position (with error) gradually
        local idealTarget = perfectY + targetError
        self.targetY = self.targetY + (idealTarget - self.targetY) * self.reactionSpeed * dt * 10
    else
        -- When ball is moving away, drift toward center with some randomness
        local centerY = windowHeight/2 - self.height/2
        self.targetY = self.targetY + (centerY - self.targetY) * dt
    end
    
    -- Move toward the target position
    if self.y < self.targetY then
        self.y = math.min(self.targetY, self.y + self.speed * dt)
    elseif self.y > self.targetY then
        self.y = math.max(self.targetY, self.y - self.speed * dt)
    end
    
    -- Keep paddle in bounds
    self.y = math.max(0, math.min(love.graphics.getHeight() - self.height, self.y))
end

return Enemy