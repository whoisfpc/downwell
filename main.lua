GameObject = require("GameObject")
Trail = require("Trail")
Timer = require("hump/timer")

function love.load()
    gameObjects = {}
    gameObject = createGameObject('GameObject', 100, 100)
    mainCanvas = love.graphics.newCanvas(320, 240)
    mainCanvas:setFilter('nearest', 'nearest')
    gameObjectCanvas = love.graphics.newCanvas(320, 240)
    gameObjectCanvas:setFilter('nearest', 'nearest')
    trailCanvas = love.graphics.newCanvas(320, 240)
    trailCanvas:setFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')
    trailLinesExtraDraw = {}
    Timer.every(0.1, function()
        for i = -360, 720, 2 do
            if love.math.random(1, 10) >= 2 then
                trailLinesExtraDraw[i] = false
            else
                trailLinesExtraDraw[i] = true
            end
        end
    end)
end

function love.update(dt)
    Timer.update(dt)
    for i = #gameObjects, 1, -1 do
        local gameObject = gameObjects[i]
        gameObject:update(dt)
        if gameObject.dead then
            table.remove(gameObjects, i)
        end
    end
end

function love.draw()
    love.graphics.setCanvas(trailCanvas)
    love.graphics.clear()
    for _, gameObject in ipairs(gameObjects) do
        if gameObject.type == 'Trail' then
            gameObject:draw()
        end
    end

    pushRotate(160, 120, gameObject.angle + math.pi / 2)
    love.graphics.setBlendMode('subtract')
    for i = -360, 720, 2 do
        love.graphics.line(i, -240, i, 480)
        if trailLinesExtraDraw[i] then
            love.graphics.line(i+1, -240, i+1, 480)
        end
    end
    love.graphics.setBlendMode('alpha')
    love.graphics.pop()    
    love.graphics.setCanvas()

    love.graphics.setCanvas(gameObjectCanvas)
    love.graphics.clear()
    for _, gameObject in ipairs(gameObjects) do
        if gameObject.type == 'GameObject' then
            gameObject:draw()
        end
    end
    love.graphics.setCanvas()

    love.graphics.setCanvas(mainCanvas)
    love.graphics.clear()
    love.graphics.draw(trailCanvas, 0, 0)
    love.graphics.draw(gameObjectCanvas, 0, 0)
    love.graphics.setCanvas()

    love.graphics.draw(mainCanvas, 0, 0, 0, 3, 3)
end

-- function love.mousepresed(x, y, button)
--     if button == 1 then
--         gameObject.dead = true
--     end
-- end

function createGameObject(type, x, y, opts)
    local gameObject = _G[type](type, x, y, opts)
    table.insert(gameObjects, gameObject)
    return gameObject
end

function randomp(min, max)
    return (min > max and (love.math.random() * (min - max) + max)) or (love.math.random() * (max - min) + min)
end

function pushRotate(x, y, r)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.translate(-x, -y)
end

function map(oldValue, oldMin, oldMax, newMin, newMax)
    local newMin = newMin or 0
    local newMax = newMax or 1
    local newValue = 0
    local oldRange = oldMax - oldMin
    if oldRange == 0 then
        newValue = newMin
    else
        local newRange = newMax - newMin
        newValue = (((oldValue - oldMin) * newRange) / oldRange) + newMin
    end
    return newValue
end