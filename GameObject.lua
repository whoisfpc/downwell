local Object = require("classic/classic")
local GameObject = Object:extend()
local Timer = require("hump/timer")

function GameObject:new(x, y, opts)
    self.x, self.y = x, y
    local opts = opts or {}
    for k, v in pairs(opts) do
        self[k] = v
    end
    self.dead = false
    Timer.every(0.01, function() createGameObject('Trail', self.x, self.y, {r = 25}) end)
end

function GameObject:update(dt)
    local x, y = love.mouse.getPosition() 
    self.x, self.y = x / 3, y / 3
end

function GameObject:draw()
    love.graphics.circle('fill', self.x, self.y, 25)
end

return GameObject