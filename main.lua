if arg[2] == "debug" then
    require("lldebugger").start()
  end
  
  local love_errorhandler = love.errorhandler

function love.load()
    Object = require "classic"

    gameState = "start"
    playerScore = 0
    enemyScore = 0

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

        if gameBall.x < 0 then
            playerScore = playerScore + 1
            gameBall.x = windowWidth/2
            gameBall.y = windowHeight/2
            gameBall:randomizeDirection()
        end

        if gameBall.x > windowWidth then
            enemyScore = enemyScore + 1
            gameBall.x = windowWidth/2
            gameBall.y = windowHeight/2
            gameBall:randomizeDirection()
        end

        if playerScore == 10 or enemyScore == 10 then
            gameState = "gameover"
        end
    end
end

function love.draw()
    if gameState == "start" then
        love.graphics.print("Press Space to Start", 300, 250)
    elseif gameState == "playing" then
        love.graphics.print("Enemy: " .. enemyScore, 50, 20)
        love.graphics.print("Player: " .. playerScore, windowWidth - 150, 20)
        leftPaddle:draw()
        rightPaddle:draw()
        gameBall:draw()
    elseif gameState == "gameover" then
        love.graphics.print("Game Over", 250, 250)
        love.graphics.print("Final Score: " .. playerScore .. " - " .. enemyScore, 250, 275)
        local fontSize = 32
        love.graphics.setFont(love.graphics.newFont(fontSize))
        
        if playerScore >= 10 then
            love.graphics.setColor(0, 0, 1) -- Blue for player win
            love.graphics.print("Player Wins!", windowWidth/2 - 100, 50)
        elseif enemyScore >= 10 then
            love.graphics.setColor(1, 0,0) -- Red for enemy win
            love.graphics.print("Enemy Wins!", windowWidth/2 - 100, 50)
        end
        
        -- Reset to default
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(12)) -- Reset to default font
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
            -- Reset scores
            playerScore = 0
            enemyScore = 0
        end
    end
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.radius > b.x and
           a.y < b.y + b.height and
           a.y + a.radius > b.y
end