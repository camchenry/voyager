-- This class contains all the data to create, draw, and update a star system

StarSystem = class("StarSystem")

function StarSystem:initialize(name, x, y)
    self.name = name
    self.x = x
    self.y = y
    self.entities = {}
    self.objects = {}
    self.projectiles = {}

    self.world = love.physics.newWorld()
end

function StarSystem:addEntity(entity)
    table.insert(self.entities, entity)
    return entity
end

function StarSystem:addObject(object)
    table.insert(self.objects, object)
    return object
end

function StarSystem:load(name)
    local starSystems = require 'data.systems'

    assert(starSystems[name] ~= nil, 'tried to load invalid star system: "'..name..'"')

    local systemData = starSystems[name]

    self.name = name
    self.x = systemData.x
    self.y = systemData.y
    self.faction = systemData.faction
    if self.faction == nil then
        self.faction = "Neutral"
    end

    self.objects = {}
    self.entities = {}
    self.projectiles = {}

    -- purge all physics objects, except the player ship
    for i, body in pairs(self.world:getBodyList()) do
        if body ~= the.player.ship.body and self:isActiveBody(body) then
            body:destroy()
        end
    end

    assert(systemData.objects ~= nil)

    -- add all objects
    for k, object in pairs(systemData.objects) do
        local class = _G[object.class]
        local newObject = class:new()
        newObject.name = object.data.name
        newObject.x = object.data.x
        newObject.y = object.data.y
		newObject.pointer = object.data.pointer

		newObject:load()
        self:addObject(newObject)
    end

    -- add mission ships
    for i, mission in pairs(game.missionController:getActiveMissions()) do
        if mission:isInstanceOf(BountyMission) and mission.destinationSystem == self.name then
            mission.target.body:setPosition(math.random(-1000, 1000)-200, math.random(-1000, 1000)+200)
            self:addEntity(mission.target)
        end
    end

    -- worked fine
    return true
end

function StarSystem:entered()
    the.economy:update()

    --local ship = the.system:addEntity(Ship:new())
    --ship.body:setPosition(math.random(-1000, 1000)-200, math.random(-1000, 1000)+200)
end

-- finds closest object to x, y within radius
function StarSystem:closestObject(x, y, radius)
    radius = radius or 100
    local min = math.huge
    local obj = nil

    for k, object in pairs(self.objects) do
        local d = math.sqrt((object.x - x)^2 + (object.y - y)^2)
        if (d < min) and (d <= radius) then
            min = d
            obj = object
        end
    end

    return obj, min
end

function StarSystem:isActiveBody(body)
    for k, obj in pairs(self.entities) do
        if obj.body == body then
            return true
        end
    end
end

function StarSystem:hasPlanet(planet)
    for k, obj in pairs(self.objects) do
        if obj.name == planet then
            return true
        end
    end
end

function StarSystem:keypressed(key, isrepeat)
    for i, entity in pairs(self.entities) do
        if entity.keypressed ~= nil then
            entity:keypressed(key, isrepeat, the.system.world, the.player.ship)
        end
    end
end

function StarSystem:update(dt)
    self.world:update(dt)

    for i, object in pairs(self.objects) do
        object:update(dt)
    end

    for i, entity in pairs(self.entities) do
        entity:update(dt)
    end

    for i, proj in pairs(self.projectiles) do
        proj:update(dt)
    end

    for i, proj in pairs(self.projectiles) do
        if proj.fixture:getUserData() == "destroy" then
            proj:destroy()
        end
    end
end

function StarSystem:draw()
    for i, object in pairs(self.objects) do
        object:draw()
    end

    for i, entity in pairs(self.entities) do
        entity:draw()
    end

    for i, proj in pairs(self.projectiles) do
        proj:draw()
    end
end
