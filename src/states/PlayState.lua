--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.ball2 = params.ball2
    self.ball3 = params.ball3
    self.level = params.level

    self.powerups = Powerups()

    self.recoverPoints = 5000

    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

    self.ball2.dx = math.random(-100, 100)
    self.ball2.dy = math.random(-40, -60)

    self.ball3.dx = math.random(-100, 100)
    self.ball3.dy = math.random(-40, -60)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    self.ball:update(dt)
    if gBonusBalls then
        self.ball2:update(dt)
        self.ball3:update(dt)
    end


    self.powerups:update(dt)

    if self.ball:collides(self.paddle) then
        -- raise ball above paddle in case it goes below it, then reverse dy
        self.ball.y = self.paddle.y - 8
        self.ball.dy = -self.ball.dy


        --
        -- tweak angle of bounce based on where it hits the paddle
        --

        -- if we hit the paddle on its left side while moving left...
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
        
        -- else if we hit the paddle on its right side while moving right...
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end

        gSounds['paddle-hit']:play()
    end

    if self.ball2:collides(self.paddle) then
        -- raise ball2 above paddle in case it goes below it, then reverse dy
        self.ball2.y = self.paddle.y - 8
        self.ball2.dy = -self.ball2.dy

        --
        -- tweak angle of bounce based on where it hits the paddle
        --

        -- if we hit the paddle on its left side while moving left...
        if self.ball2.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball2.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball2.x))
        
        -- else if we hit the paddle on its right side while moving right...
        elseif self.ball2.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball2.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball2.x))
        end

        gSounds['paddle-hit']:play()
    end

    if self.ball3:collides(self.paddle) then
        -- raise ball3 above paddle in case it goes below it, then reverse dy
        self.ball3.y = self.paddle.y - 8
        self.ball3.dy = -self.ball3.dy

        --
        -- tweak angle of bounce based on where it hits the paddle
        --

        -- if we hit the paddle on its left side while moving left...
        if self.ball3.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball3.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball3.x))
        
        -- else if we hit the paddle on its right side while moving right...
        elseif self.ball3.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball3.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball3.x))
        end

        gSounds['paddle-hit']:play()
    end

    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            if brick.blocked > 1 then 
                self.score = self.score + (brick.tier * 200 + brick.color * 25)
            end

            brick:hit()

            if self.score > self.recoverPoints then
                self.health = math.min(3, self.health + 1)
                self.recoverPoints = self.recoverPoints + math.min(100000, self.recoverPoints * 2)
                gSounds['recover']:play()
            end
            if self:checkVictory() then
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    ball = self.ball,
                    ball2 = self.ball2,
                    ball3 = self.ball3,
                    recoverPoints = self.recoverPoints
                })
            end
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - 8
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8
            else
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + 16
            end
            if math.abs(self.ball.dy) < 150 then
                self.ball.dy = self.ball.dy * 1.02
            end
            break
        end

        if brick.inPlay and self.ball2:collides(brick) then
            self.score = self.score + (brick.tier * 200 + brick.color * 25)
            brick:hit()

            if self.score > self.recoverPoints then
                self.health = math.min(3, self.health + 1)
                self.recoverPoints = self.recoverPoints + math.min(100000, self.recoverPoints * 2)
                gSounds['recover']:play()
            end

            if self:checkVictory() then
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    ball = self.ball,
                    ball2 = self.ball2,
                    ball3 = self.ball3,
                    recoverPoints = self.recoverPoints
                })
            end

            if self.ball2.x + 2 < brick.x and self.ball2.dx > 0 then
                self.ball2.dx = -self.ball2.dx
                self.ball2.x = brick.x - 8
            elseif self.ball2.x + 6 > brick.x + brick.width and self.ball2.dx < 0 then
                self.ball2.dx = -self.ball2.dx
                self.ball2.x = brick.x + 32
            elseif self.ball2.y < brick.y then
                self.ball2.dy = -self.ball2.dy
                self.ball2.y = brick.y - 8
            else
                self.ball2.dy = -self.ball2.dy
                self.ball2.y = brick.y + 16
            end
            if math.abs(self.ball2.dy) < 150 then
                self.ball2.dy = self.ball2.dy * 1.02
            end
            break
        end

        if brick.inPlay and self.ball3:collides(brick) then
            self.score = self.score + (brick.tier * 200 + brick.color * 25)
            brick:hit()

            if self.score > self.recoverPoints then
                self.health = math.min(3, self.health + 1)
                self.recoverPoints = self.recoverPoints + math.min(100000, self.recoverPoints * 2)
                gSounds['recover']:play()
            end

            if self:checkVictory() then
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    ball = self.ball,
                    ball2 = self.ball2,
                    ball3 = self.ball3,
                    recoverPoints = self.recoverPoints
                })
            end

            if self.ball3.x + 2 < brick.x and self.ball3.dx > 0 then
                self.ball3.dx = -self.ball3.dx
                self.ball3.x = brick.x - 8
            elseif self.ball3.x + 6 > brick.x + brick.width and self.ball3.dx < 0 then
                self.ball3.dx = -self.ball3.dx
                self.ball3.x = brick.x + 32
            elseif self.ball3.y < brick.y then
                self.ball3.dy = -self.ball3.dy
                self.ball3.y = brick.y - 8
            else
                self.ball3.dy = -self.ball3.dy
                self.ball3.y = brick.y + 16
            end
            if math.abs(self.ball3.dy) < 150 then
                self.ball3.dy = self.ball3.dy * 1.02
            end
            break
        end
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    if self.ball2.y >= VIRTUAL_HEIGHT then
        self.ball2.dy = 0
        self.ball2.dx = 0
    end

    if self.ball3.y >= VIRTUAL_HEIGHT then
        self.ball3.dy = 0
        self.ball3.dx = 0
    end

    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
                recoverPoints = self.recoverPoints
            })
        end
    end
    

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    self.ball:render()
    if gBonusBalls then
        self.ball2:render()
        self.ball3:render()
    end

    if not self.powerups:collidesPowerBalls(self.paddle) then
        self.powerups:renderPowerBalls()
    end
    if not self.powerups:collidesPowerKey(self.paddle) then
        self.powerups:renderPowerKey()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end