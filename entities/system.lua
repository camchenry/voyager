-- This class contains all the data to create, draw, and update a star system

StarSystem = class("StarSystem")

function StarSystem:initialize(name, x, y)
    self.name = name
    self.x = x
    self.y = y
    self.entities = {}
    self.objects = {}

    self.world = love.physics.newWorld()
end

function StarSystem:addEntity(entity)
    table.insert(self.entities, entity)
end

function StarSystem:addObject(object)
    table.insert(self.objects, object)
end

function StarSystem:load(name)
    local starSystems = require 'data.systems'

    assert(starSystems[name] ~= nil, 'tried to load invalid star system: "'..name..'"')

    local systemData = starSystems[name]

    self.name = name
    self.objects = {}
    self.entities = {}

    -- add all objects
    for k, object in pairs(systemData.objects) do
        local class = _G[object.class]
        local newObject = class:new()
        newObject.name = object.data.name
        newObject.x = object.data.x
        newObject.y = object.data.y

        self:addObject(newObject)
    end

    -- worked fine
    return true
end

function StarSystem:entered()
    for comm, price in pairs(tradecenter.commodityPrices) do
        tradecenter.commodityPrices[comm] = tradecenter.commodityPrices[comm] + math.random(-50, 50)
    end
end

-- finds closest object to x, y within radius
function StarSystem:closestObject(x, y, radius)
    radius = radius or 80
    local min = math.huge
    local obj = nil

    for k, object in pairs(self.objects) do
        local d = math.sqrt((object.x - x)^2 + (object.y - y)^2)
        if d < min and d <= radius then
            min = d
            obj = object
        end
    end

    return obj, min
end

function StarSystem:update(dt)
    self.world:update(dt)

    for i, object in pairs(self.objects) do
        object:update(dt)
    end

    for i, entity in pairs(self.entities) do
        entity:update(dt)
    end
end

function StarSystem:draw()
    for i, object in pairs(self.objects) do
        object:draw()
    end

    for i, entity in pairs(self.entities) do
        entity:draw()
    end
end
