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
