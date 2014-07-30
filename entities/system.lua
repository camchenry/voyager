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
