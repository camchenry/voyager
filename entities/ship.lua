-- This contains all the variables for each (active) ship in the game
-- e.g. physics bodies and fixtures, and ship specifications (crew, armor, etc.)

Ship = class("Ship")

function Ship:initialize(world)
    if world == nil and the.system.world ~= nil then world = the.system.world end

    self.width = 100
    self.height = 300

    -- physics objects
    self.body = love.physics.newBody(world, 50, 50, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
end

function Ship:update(dt)
    if love.keyboard.isDown("w") then
        self.body:applyForce(0, -100)
    elseif love.keyboard.isDown("s") then
        self.body:applyForce(0, 100)
    end

    if love.keyboard.isDown("a") then
        self.body:applyForce(-100, 0)
    elseif love.keyboard.isDown("d") then
        self.body:applyForce(100, 0)
    end
end

function Ship:draw()
    -- placeholder
    love.graphics.setColor(127, 127, 127)
    love.graphics.rectangle("fill", self.body:getX(), self.body:getY(), self.width, self.height)

    love.graphics.setColor(255, 255, 255)
    love.graphics.print(self.body:getX())
end