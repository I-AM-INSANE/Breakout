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
    gBonusBalls = false
    gBonusKey = false
end

local spawnTimePowerBalls = math.random(3, 15)
local spawnTimePowerKey = math.random(10,25)

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
    if paddle.y > self.y_powerBalls + self.height or paddle.y < self.y_powerBalls - 8 then
        return false
    end 

    gBonusBalls = true

    return true

end

function Powerups:collidesPowerKey(paddle)
    if self.x_powerKey > paddle.x + paddle.width or paddle.x > self.x_powerKey + self.width then
        return false
    end
    if paddle.y > self.y_powerKey + self.height or paddle.y < self.y_powerKey - 8 then
        return false
    end 

    gBonusKey = true
    return true
end

function Powerups:renderPowerBalls()
    if spawnPowerBalls and not gBonusBalls then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][1], self.x_powerBalls, self.y_powerBalls)
    end
end

function Powerups:renderPowerKey()
    if spawnPowerKey and not gBonusKey then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][2], self.x_powerKey, self.y_powerKey) 
    end
end    





