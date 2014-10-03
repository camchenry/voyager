PlayerControl = class("PlayerControl")

function PlayerControl:initialize(ship, world)
    self.ship = ship
    self.world = world or the.system.world
end

function PlayerControl:update(dt)
    if love.keyboard.isDown("w") then
        self.ship:thrustPrograde()
    elseif love.keyboard.isDown("s") then
        self.ship:thrustRetrograde()
    end

    if love.keyboard.isDown("a") then
        self.ship:turn(-1)
    elseif love.keyboard.isDown("d") then
        self.ship:turn(1)
    end
    if love.keyboard.isDown(" ") then
        self.ship.weapon:fire(self.ship, {x=love.mouse.getX(), y=love.mouse.getY()})
    end
end