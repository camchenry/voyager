Projectile = class("Projectile")

function Projectile:initialize(parentShip, parentWeapon, origin, target)
    local origX, origY = origin.x or origin.body:getX(), origin.y or origin.body:getY()
    local targX, targY = target.x or target.body:getX(), target.y or target.body:getY() 

    self.parentShip = parentShip
    self.parentWeapon = parentWeapon

    self.width = 100
    self.height = 20

    local angle = self.parentShip.body:getAngle()

    self.body = love.physics.newBody(the.system.world, origX, origY, "dynamic")
    self.body:setLinearVelocity(300*math.cos(angle), 300*math.sin(angle))
    self.body:setAngle(angle)
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setFilterData(1, 1, -1)
end

function Projectile:update(dt)
    
end

function Projectile:draw()
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