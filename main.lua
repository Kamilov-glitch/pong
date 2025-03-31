if arg[2] == "debug" then
    require("lldebugger").start()
  end
  
  local love_errorhandler = love.errorhandler

function love.load()
    Object = require "classic"

    gameState = "start"
    score = 0

    local player = require "player"
    local enemy = require "enemy"
    local ball = require "ball"

    math.randomseed(os.time())
    
    windowWidth, windowHeight = love.graphics.getDimensions()

    leftPaddle = enemy(20, windowHeight/2 - 40, 15, 80)
    rightPaddle = player(windowWidth - 35, windowHeight/2 - 40, 15, 80)

    gameBall = ball(windowWidth/2, windowHeight/2, 10)

    collisionSound = love.audio.newSource("assets/sounds/metal_hit.wav", "static")
end

function love.update(dt)
    if gameState == "playing" then
        leftPaddle:update(dt)
        rightPaddle:update(dt)
        gameBall:update(dt)
        
        -- Game over if ball goes past left or right edge
        if gameBall.x < 0 or gameBall.x > windowWidth then
            gameState = "gameover"
        end
    end
end

function love.draw()
    if gameState == "start" then
        love.graphics.print("Press Space to Start", 300, 250)
    elseif gameState == "playing" then
        leftPaddle:draw()
        rightPaddle:draw()
        gameBall:draw()
    elseif gameState == "gameover" then
        love.graphics.print("Game Over", 250, 250)
        love.graphics.print("Press Space to Restart", 250, 300)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        if gameState == "start" or gameState == "gameover" then
            gameState = "playing"
            -- Reset ball position to center of screen
            gameBall.x = windowWidth/2
            gameBall.y = windowHeight/2
            -- Randomize the ball direction
            gameBall:randomizeDirection()
            -- Also eset paddle positions
            leftPaddle.y = windowHeight/2 - 40
            rightPaddle.y = windowHeight/2 - 40
        end
    end
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.radius > b.x and
           a.y < b.y + b.height and
           a.y + a.radius > b.y
end