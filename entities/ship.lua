-- This contains all the objects for each (active) ship in the game
-- e.g. physics bodies and fixtures, and ship specifications (crew, armor, etc.)

Ship = class("Ship")

function Ship:initialize(world)
    self.width = 100
    self.height = 300

    -- physics objects
    self.body = love.physics.newBody(world, 50, 50, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
end

function Ship:update(dt)
    self.body:applyForce(50, 10)
end

function Ship:draw()
    -- placeholder
    love.graphics.setColor(127, 127, 127)
    love.graphics.rectangle("fill", self.body:getX(), self.body:getY(), self.width, self.height)

    love.graphics.setColor(255, 255, 255)
    love.graphics.print(self.body:getX())
end