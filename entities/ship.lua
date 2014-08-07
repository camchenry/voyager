-- This contains all the variables for each (active) ship in the game
-- e.g. physics bodies and fixtures, and ship specifications (crew, armor, etc.)

Ship = class("Ship")

function Ship:initialize(world, controlScheme)
    if world == nil and the.system.world ~= nil then world = the.system.world end

    self.width = 150
    self.height = 50

    -- physics objects
    self.body = love.physics.newBody(world, 27, 100, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    -- control scheme (assume ComputerControl as default)
    self.controlScheme = controlScheme or ComputerControl

    -- physics properties
    self.mass = 4
    self.torque = 250
    self.angularDamping = 20
    self.inertia = 10
    self.speed = 250
    self.maxSpeed = 300

    -- ship properties
    self.maxCargo = 20
    self.cargo = {
        ["Equipment"] = 5,
        ["Medical Supplies"] = 10,
        ["Ore"] = 2,
        ["Metal"] = 0,
    }

    self.jumping = false

    self.body:setMass(self.mass)
    self.body:setAngularDamping(self.angularDamping)
    self.body:setInertia(self.inertia)
end

function Ship:update(dt)
    self.controlScheme.update(self, dt)
end

-- if direction is 1, turn clockwise
-- if direction is -1, turn anticlockwise
function Ship:turn(direction)
    assert(direction == 1 or direction == -1)

    self.body:applyTorque(self.torque * direction)
end

function Ship:thrustPrograde()
    local dx = self.speed*math.cos(self.body:getAngle())
    local dy = self.speed*math.sin(self.body:getAngle())

    self.body:applyForce(dx, dy)
end

function Ship:thrustRetrograde()
    local dx = self.speed*math.cos(self.body:getAngle())
    local dy = self.speed*math.sin(self.body:getAngle())

    self.body:applyForce(-dx, -dy)
end

function Ship:stop()
    self.body:setLinearVelocity(0, 0)
end

function Ship:getCommodityMass(commodity)
    assert(commodity ~= nil, 'commodity was nil')
    return self.cargo[commodity]
end

function Ship:getCargoMass()
    local sum = 0
    for commodity, amount in pairs(self.cargo) do
        sum = sum + amount
    end
    return sum
end

function Ship:addCargo(commodity, amount)
    self.cargo[commodity] = self.cargo[commodity] + amount
end

function Ship:removeCargo(commodity, amount)
    if amount > self.cargo[commodity] then
        self.cargo[commodity] = 0
    else
        self.cargo[commodity] = self.cargo[commodity] - amount
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