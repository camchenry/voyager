-- This contains all the variables for each (active) ship in the game
-- e.g. physics bodies and fixtures, and ship specifications (crew, armor, etc.)

Ship = class("Ship")

function Ship:initialize(world)
    if world == nil and the.system.world ~= nil then world = the.system.world end

    self.width = 150
    self.height = 50

    -- physics objects
    self.body = love.physics.newBody(world, 50, 50, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    -- physics properties
    self.mass = 4
    self.torque = 250
    self.angularDamping = 20
    self.inertia = 10
    self.speed = 250
    self.maxSpeed = 300

    self.body:setMass(self.mass)
    self.body:setAngularDamping(self.angularDamping)
    self.body:setInertia(self.inertia)
end

function Ship:update(dt)
    local dx = self.speed*math.cos(self.body:getAngle())
    local dy = self.speed*math.sin(self.body:getAngle())

    if love.keyboard.isDown("w") then
        self.body:applyForce(dx, dy)
    elseif love.keyboard.isDown("s") then
        self.body:applyForce(-dx, -dy)
    end

    if love.keyboard.isDown("a") then
        self.body:applyTorque(-self.torque)
    elseif love.keyboard.isDown("d") then
        self.body:applyTorque(self.torque)
    end
end

function Ship:draw()
    -- placeholder
    love.graphics.setColor(127, 127, 127)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))

    love.graphics.setColor(255, 0, 0)
    local points = {self.body:getWorldPoints(
        self.width, 
        0
    )}
    love.graphics.line(self.body:getX(), self.body:getY(), points[1], points[2])
end