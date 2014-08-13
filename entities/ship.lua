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
    self.fixture:setMask(2) -- assume don't collide with non-player bullets (aka bullets made by this ship)
    self.fixture:setCategory(3)
    self.fixture:setUserData("ship")

    -- control scheme (assume ComputerControl as default)
    self.controlScheme = controlScheme or ComputerControl
    self.controlScheme = self.controlScheme:new(self, the.system.world)

    -- physics properties
    self.mass = 3.25
    self.torque = 250
    self.angularDamping = 20
    self.inertia = 10 -- more inertia = more resistance to force
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

    self.weapon = Weapon:new("gun thing", 200, self)

    self.body:setMass(self.mass)
    self.body:setAngularDamping(self.angularDamping)
    self.body:setInertia(self.inertia)
end

function Ship:update(dt)
    self.controlScheme:update(dt)
    self.weapon:update(dt)
end

function Ship:keypressed(key, isrepeat)
    if self.controlScheme.keypressed ~= nil then
        self.controlScheme.keypressed(key, isrepeat, self, the.system.world, the.player.ship)
    end
end

-- if direction is 1, turn clockwise
-- if direction is -1, turn anticlockwise
function Ship:turn(direction)
    assert(direction == 1 or direction == -1)

    self.body:applyTorque(self.torque * direction)
end

function Ship:turnToward(target)
    if type(target) == 'number' then
        target = {
            x = math.cos(target),
            y = math.sin(target)
        }
    elseif not vector.isvector(target) then
        target = vector(target.body:getX() - self.body:getX(), target.body:getY() - self.body:getY())
    end

    if self:facing(target) then
        return
    end

    local rotX = math.cos(self.body:getAngle())
    local rotY = math.sin(self.body:getAngle())

    -- Determine if we should turn left or right
    -- http://stackoverflow.com/questions/14807287/how-can-i-determine-whether-its-faster-to-face-an-object-rotating-clockwise-or
    
    if target.x * rotY > target.y * rotX then
        self:turn(-1)
    else
        self:turn(1)
    end
end

function Ship:facing(target, tolerance)
    -- tolerance for how close it has to be to target angle
    tolerance = tolerance or math.rad(10)

    local angleToTarget = math.atan2(target.y, target.x)
    angleToTarget = angleToTarget % (2*math.pi)

    local shipAngle = self.body:getAngle() % (2*math.pi)

    -- the absolute difference between current rotation and target angle
    local difference = math.abs(shipAngle - angleToTarget)

    return difference <= tolerance
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