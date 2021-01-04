Powerups = Class{}

function Powerups:init()
    spawnPowerBalls = false
    spawnPowerKey = false

    self.x_PowerBalls = math.random(16, 400)
    self.y_PowerBalls = math.random(80, 110)

    self.x_PowerKey = math.random(16, 400)
    self.y_PowerKey = math.random(80, 110)

    self.width = 16
    self.height = 16

    self.dy_powerBalls = 0
    self.dy_powerKey = 0

    self.timer = 0

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

    self.y_PowerBalls = self.y_PowerBalls + self.dy_powerBalls
    self.y_PowerKey = self.y_PowerKey + self.dy_powerKey
end

function Powerups:render()
    if spawnPowerBalls then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][1], self.x_PowerBalls, self.y_PowerBalls)
    end
    if spawnPowerKey then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][2], self.x_PowerKey, self.y_PowerKey) 
    end
end    





