Powerups = Class{}

function Powerups:init()
    spawnPowerBalls = false
    spawnPowerKey = false

    self.x_powerBalls = math.random(16, 400)
    self.y_powerBalls = math.random(80, 105)

    self.x_powerKey = math.random(16, 400)
    self.y_powerKey = math.random(80, 105)

    self.width = 16
    self.height = 16

    self.dy_powerBalls = 0
    self.dy_powerKey = 0

    self.timer = 0
    self.removePowerBalls = false
    self.removePowerKey = false
end

local spawnTimePowerBalls = 2
local spawnTimePowerKey = 3

function Powerups:update(dt)
    self.timer = self.timer + dt

    if self.timer >= spawnTimePowerBalls then
        spawnPowerBalls = true
        self.dy_powerBalls = POWERUPS_SPEED
    else
        spawnPowerBalls = false
    end

    if self.timer >= spawnTimePowerKey then
        spawnPowerKey = true
        self.dy_powerKey = POWERUPS_SPEED
    else
        spawnPowerKey = false
    end

    self.y_powerBalls = self.y_powerBalls + self.dy_powerBalls
    self.y_powerKey = self.y_powerKey + self.dy_powerKey
end

function Powerups:collidesPowerBalls(paddle)
    if self.x_powerBalls > paddle.x + paddle.width or paddle.x > self.x_powerBalls + self.width then
        return false
    end
    if paddle.y > self.y_powerBalls + self.height then
        return false
    end 

    self.removePowerBalls = true
    return true
end

function Powerups:collidesPowerKey(paddle)
    if self.x_powerKey > paddle.x + paddle.width or paddle.x > self.x_powerKey + self.width then
        return false
    end
    if paddle.y > self.y_powerKey + self.height then
        return false
    end 

    self.removePowerKey = true
    return true
end

function Powerups:renderPowerBalls()
    if spawnPowerBalls and not self.removePowerBalls then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][1], self.x_powerBalls, self.y_powerBalls)
    end
end

function Powerups:renderPowerKey()
    if spawnPowerKey and not self.removePowerKey then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][2], self.x_powerKey, self.y_powerKey) 
    end
end    





