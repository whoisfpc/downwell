local Object = require("classic/classic")
local Timer = require("hump/timer")

function Trail:new(x, y, opts)
    self.dead = false
    self.x, self.y = x, y
    local opts = opts or {}
    for k, v in pair(opts) do
        self[k] = v
    end

    Timer.after(0.15, function() self.dead = true end)
end

function Trail:update(dt)

end

function Trail:draw()
    love.graphics.circle('fill', self.x, self.y, self.r)
end

return Trail