GameObject = require("GameObject")
Timer = require("hump/timer")

function love.load()
    timer = Timer()
    gameObjects = {}
    gameObject = createGameObject('GameObject', 100, 100)
    mainCanvas = love.graphics.newCanvas(320, 240)
    mainCanvas:setFilter('nearest', 'nearest')
end

function love.update(dt)
    timer.update(dt)
    for i = #gameObjects, 1, -1 do
        local gameObject = gameObjects[i]
        gameObject:update(dt)
        if gameObject.dead then
            table.remove(gameObjects, i)
        end
    end
end

function love.draw()
    love.graphics.setCanvas(mainCanvas)
    love.graphics.clear()
    for _, gameObject in ipairs(gameObjects) do
        gameObject:draw()
    end
    love.graphics.setCanvas()
    love.graphics.draw(mainCanvas, 0, 0, 0, 3, 3)
end

function love.mousepresed(x, y, button)
    if button == 1 then
        gameObject.dead = true
    end
end

function createGameObject(type, x, y, opts)
    local gameObject = _G[type](x, y, opts)
    table.insert(gameObjects, gameObject)
    return gameObject
end