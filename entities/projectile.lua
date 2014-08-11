Projectile = class("Projectile")

function Projectile:initialize(parentShip, parentWeapon, origin)
    local origX, origY = origin.x or origin.body:getX(), origin.y or origin.body:getY()

    -- categories and masks are encoded as the bits of a 16 bit integer
    -- using tonumber() might make it a little bit more clear

    self.parentShip = parentShip
    self.parentWeapon = parentWeapon

    self.width = 40
    self.height = 2

    self.life = 3 -- seconds

    local angle = self.parentShip.body:getAngle()

    self.body = love.physics.newBody(the.system.world, origX, origY, "dynamic")
    local vx, vy = self.parentShip.body:getLinearVelocity()
    local velX = 750*math.cos(angle)+vx
    local velY = 750*math.sin(angle)+vy
    self.body:setLinearVelocity(velX, velY)
    self.body:setAngle(angle)
    self.body:setMass(0.01)
    self.body:setBullet(true)
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    if self.parentShip == the.player.ship then
        self.fixture:setCategory(1)
    else
        self.fixture:setCategory(2)
    end
end

function Projectile:update(dt)
    self.life = self.life - dt

    if self.life <= 0 then
        self.body:destroy()
        table.remove(the.system.projectiles, searchTable(the.system.projectiles, self))
    end
end

function Projectile:draw()
    -- placeholder
    love.graphics.setColor(127, 127, 127)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end