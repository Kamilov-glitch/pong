-- Debug mode activation
if arg[2] == "debug" then
    require("lldebugger").start()
end
  
local love_errorhandler = love.errorhandler

-- Constants (keeping original variable names to avoid breaking dependencies)
local WINNING_SCORE = 10

function love.load()
    -- Load dependencies
    Object = require "classic"

    -- Initialize game state
    gameState = "start"
    playerScore = 0
    enemyScore = 0

    -- Load game objects
    local player = require "player"
    local enemy = require "enemy"
    local ball = require "ball"

    -- Initialize random seed
    math.randomseed(os.time())
    
    -- Get window dimensions (must remain global for other files)
    windowWidth, windowHeight = love.graphics.getDimensions()

    -- Create game objects (must remain global for cross-file access)
    leftPaddle = enemy(20, windowHeight/2 - 40, 15, 80)
    rightPaddle = player(windowWidth - 35, windowHeight/2 - 40, 15, 80)
    gameBall = ball(windowWidth/2, windowHeight/2, 10)

    -- Load audio
    collisionSound = love.audio.newSource("assets/sounds/metal_hit.wav", "static")
end

function love.update(dt)
    if gameState == "playing" then
        -- Update game objects
        leftPaddle:update(dt)
        rightPaddle:update(dt)
        gameBall:update(dt)

        -- Check for scoring
        handleScoring()
        
        -- Check for game over
        if playerScore >= WINNING_SCORE or enemyScore >= WINNING_SCORE then
            gameState = "gameover"
        end
    end
end

-- Helper function to handle scoring
function handleScoring()
    if gameBall.x < 0 then
        playerScore = playerScore + 1
        resetBall()
    end

    if gameBall.x > windowWidth then
        enemyScore = enemyScore + 1
        resetBall()
    end
end

-- Helper function to reset ball position
function resetBall()
    gameBall.x = windowWidth/2
    gameBall.y = windowHeight/2
    gameBall:randomizeDirection()
end

function love.draw()
    if gameState == "start" then
        drawStartScreen()
    elseif gameState == "playing" then
        drawGameScreen()
    elseif gameState == "gameover" then
        drawGameOverScreen()
    end
end

function drawStartScreen()
    love.graphics.print("Press Space to Start", 300, 250)
end

function drawGameScreen()
    -- Draw scores
    love.graphics.print("Enemy: " .. enemyScore, 50, 20)
    love.graphics.print("Player: " .. playerScore, windowWidth - 150, 20)
    
    -- Draw game objects
    leftPaddle:draw()
    rightPaddle:draw()
    gameBall:draw()
end

function drawGameOverScreen()
    -- Draw game over text
    love.graphics.print("Game Over", 250, 250)
    love.graphics.print("Final Score: " .. playerScore .. " - " .. enemyScore, 250, 275)
    
    -- Set larger font for winner announcement
    local fontSize = 32
    love.graphics.setFont(love.graphics.newFont(fontSize))
    
    -- Show winner with appropriate color
    if playerScore >= WINNING_SCORE then
        love.graphics.setColor(0, 0, 1) -- Blue for player win
        love.graphics.print("Player Wins!", windowWidth/2 - 100, 50)
    elseif enemyScore >= WINNING_SCORE then
        love.graphics.setColor(1, 0, 0) -- Red for enemy win
        love.graphics.print("Enemy Wins!", windowWidth/2 - 100, 50)
    end
    
    -- Reset to default color and font
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(12))
    love.graphics.print("Press Space to Restart", 250, 300)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        if gameState == "start" or gameState == "gameover" then
            startNewGame()
        end
    end
end

-- Helper function to start/restart game
function startNewGame()
    gameState = "playing"
    
    -- Reset ball position
    resetBall()
    
    -- Reset paddle positions
    leftPaddle.y = windowHeight/2 - 40
    rightPaddle.y = windowHeight/2 - 40
    
    -- Reset scores
    playerScore = 0
    enemyScore = 0
end

-- Important: Keep this function unchanged for other files
function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.radius > b.x and
           a.y < b.y + b.height and
           a.y + a.radius > b.y
end