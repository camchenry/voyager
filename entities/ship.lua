-- This contains all the variables for each (active) ship in the game
-- e.g. physics bodies and fixtures, and ship specifications (crew, armor, etc.)

Ship = class("Ship")

function Ship:initialize(world, controlScheme)
    if world == nil and the.system.world ~= nil then world = the.system.world end

    self.testShipImage = love.graphics.newImage('img/ship.png')

    self.scaleX = 0.75
    self.scaleY = 0.75

    self.width = self.testShipImage:getWidth()*self.scaleX
    self.height = self.testShipImage:getHeight()*self.scaleY

    -- physics objects
    self.body = love.physics.newBody(world, 100, 100, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setMask(2) -- assume don't collide with non-player bullets (aka bullets made by this ship)
    self.fixture:setCategory(2)
    self.fixture:setUserData("ship")

    -- control scheme (assume ComputerControl as default)
    self.controlScheme = controlScheme or ComputerControl
    self.controlScheme = self.controlScheme:new(self, the.system.world)

    -- cheating factor, to help AI overcome the fact that they are really dumb
    local m = 1

    if controlScheme == ComputerControl then
        m = 2
    end

    -- physics properties
    self.mass = 3
    self.torque = 800*m
    self.angularDamping = 15
    self.inertia = 11 -- more inertia = more resistance to force
    self.speed = 350*m
    self.maxSpeed = 250
    self.maxForce = 350*m

    -- ship properties
    self.maxCargo = 20
    self.cargo = {}

    for i, commodity in pairs(the.economy.commodities) do
        self.cargo[commodity] = 0
    end

    self.jumpTime = 2.5
    self.jumpCountdown = 0
    self.engagingJump = false

    -- ship combat properties
    self.maxHull = 1000000
    self.hull = self.maxHull

    self.jumping = false
    self.destroyed = false

    self.weapon = Weapon:new("gun thing", 55, 200, 5, self)

    self.body:setMass(self.mass)
    self.body:setAngularDamping(self.angularDamping)
    self.body:setInertia(self.inertia)
    self.body:setFixedRotation(false)
end

function Ship:update(dt)
    if self.destroyed then self:destroy() return end

    self.weapon:update(dt)

    if not self.jumping then 
        self.controlScheme:update(dt)
        self:limitSpeed()
    elseif self.jumping and self.engagingJump then
        self:turnToward(starmap:angleTo(starmap.selectedSystem))
    elseif self.jumping and not self.engagingJump then
        self.body:setInertia(1)
        self.body:setMass(0.005)

        self:thrustPrograde()
    end
end

function Ship:keypressed(key, isrepeat)
    if self.controlScheme.keypressed ~= nil and not self.jumping then
        self.controlScheme:keypressed(key, isrepeat)
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
        local targX = target.x or target.body:getX()
        local targY = target.y or target.body:getY()
        target = vector(targX - self.body:getX(), targY - self.body:getY())
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

function Ship:normalizeAngle(angle)
    while angle < -math.pi do
        angle = angle + 2*math.pi
    end

    while angle > math.pi do
        angle = angle - 2*math.pi
    end

    return angle
end

function Ship:facing(target, tolerance)
    -- tolerance for how close it has to be to target angle
    tolerance = tolerance or math.rad(5)

    local targX, targY = target.x or target.body:getX(), target.y or target.body:getY()
    local shipX, shipY = self.body:getPosition()

    local angleToTarget = math.atan2(targX - shipX, targY - shipY)
    angleToTarget = self:normalizeAngle(angleToTarget)

    local shipAngle = -self.body:getAngle()
    shipAngle = self:normalizeAngle(shipAngle)

    local difference = shipAngle - angleToTarget
    difference = self:normalizeAngle(difference) + math.pi/2

    return math.abs(difference) <= tolerance, difference
end

function Ship:limitSpeed()
    local velocity  = vector(self.body:getLinearVelocity())

    velocity = velocity:limit(self.maxSpeed)

    self.body:setLinearVelocity(velocity.x, velocity.y)
end

function Ship:thrustPrograde()
    local dx = self.speed*math.cos(self.body:getAngle())
    local dy = self.speed*math.sin(self.body:getAngle())

    local v = vector(dx, dy):limit(self.maxForce)

    self.body:applyForce(v.x, v.y)
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

function Ship:getCargoValue()
    local sum = 0
    for commodity, amount in pairs(self.cargo) do
        sum = sum + amount*the.economy.prices[commodity]
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

function Ship:takeDamage(projectile)
    self.hull = self.hull - projectile.parentWeapon.damage

    if self.hull <= 0 then
        self.hull = 0
        self.destroyed = true
    end
end

function Ship:destroy()
    local i = searchTable(the.system.entities, self)
    if i ~= nil then
        table.remove(the.system.entities, i)
    end

    self.body:destroy()
end

function Ship:draw()
    if self.destroyed then return end

    --love.graphics.setColor(127, 127, 127)
    --love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(255, 255, 255)

    love.graphics.draw(self.testShipImage, self.body:getX() , self.body:getY(), self.body:getAngle()+math.pi/2, self.scaleX, self.scaleY, self.testShipImage:getWidth()/2, self.testShipImage:getHeight()/2)

    if self.controlScheme.predictionVector ~= nil then
        love.graphics.circle("line", self.controlScheme.predictionVector.x, self.controlScheme.predictionVector.y, 8)
    end
end