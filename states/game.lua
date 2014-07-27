game = {}

function game:init()
    the.system = self.systems["Sol"]

    the.system:addEntity(the.player.ship)
end

-- initialize all star systems and load them into self.systems
function game:loadSystems()
    self.systems = {}

    local starSystems = require 'data.systems'

    for systemName, systemData in pairs(starSystems) do
        local system = StarSystem:new(systemName)

        -- add all objects
        for k, object in pairs(systemData.objects) do
            local class = _G[object.class]
            local newObject = class:new()
            newObject.name = object.data.name
            newObject.x = object.data.x
            newObject.y = object.data.y

            system:addObject(newObject)
        end

        self.systems[systemName] = system
    end
end

function game:load(file, ignoreError)
    if ignoreError ~= false then ignoreError = true end

    local ok, data = pcall(love.filesystem.read, file)

    if ok then
        ok, data = pcall(loadstring('return ' .. data))
        
        if not ok then
            if ignoreError then
                data = {}
            else
                error("could not deserialize storage data: " .. self.data)
            end
        end
    else
        if not ignoreError then
            error("could not load storage from disk: " .. data)
        end
    end

    return data, ok
end

function game:enter()
    
end

function game:update(dt)
    the.system:update(dt)
end

function game:keypressed(key, isrepeat)

end

function game:draw()
    love.graphics.setColor(255, 255, 255)

    love.graphics.print(the.system.name)

    local x = -the.player.ship.body:getX() + love.window.getWidth()/2 - the.player.ship.width/2
    local y = -the.player.ship.body:getY() + love.window.getHeight()/2 - the.player.ship.height/2
    love.graphics.translate(x, y)

    the.system:draw()
end