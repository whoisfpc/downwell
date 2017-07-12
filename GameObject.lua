local Object = require("classic/classic")
local GameObject = Object:extend()
Timer = require("hump/timer")
Vector = require("hump/vector")

function GameObject:new(type, x, y, opts)
    self.type = type
    self.x, self.y = x, y
    self.previousX, self.previousY = self.x, self.y
    local opts = opts or {}
    for k, v in pairs(opts) do
        self[k] = v
    end
    self.dead = false
    Timer.every(0.01, function()
        createGameObject('Trail', self.x, self.y,
            {r = 20, xm = self.xm, ym = self.ym, angle = self.angle})
    end)
end

function GameObject:update(dt, px, py)
    local x, y = love.mouse.getPosition()
    self.x = px or x / 3
    self.y = py or y / 3
    self.angle = math.atan2(self.y - self.previousY, self.x - self.previousX)
    self.vmag = Vector(self.x - self.previousX, self.y - self.previousY):len()
    self.xm = map(self.vmag, 0, 20, 1, 2)
    self.ym = map(self.vmag, 0, 20, 1, 0.25)
    self.previousX, self.previousY = self.x, self.y
end

function GameObject:draw()
    pushRotate(self.x, self.y, self.angle)
    love.graphics.ellipse('fill', self.x, self.y, self.xm * 15, self.ym * 15)
    love.graphics.pop()
end

return GameObject