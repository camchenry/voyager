-- This class represents the pilot (player)

Pilot = class("Pilot")

function Pilot:initialize(first, last, gender)
    self.firstName = first
    self.lastName = last
    self.name = first .. " " .. last
    self.gender = gender

    self.ship = Ship:new(the.system.world, PlayerControl)
    self.ship.fixture:setMask(1)
    self.location = "Sol"
    self.planet = nil

    self.credits = 25000
end

function Pilot:jump()
    local system = starmap.selectedSystem
    if system == nil then return false end

    assert(system ~= nil)
    assert(system ~= self.location)

    self.ship.jumping = true

    -- system is selected, time to jump

    self.ship.jumpCountdown = self.ship.jumpTime
    self.ship.engagingJump = true

    tween(self.ship.jumpTime, self.ship, {jumpCountdown = 0}, nil, function()
        self.ship.engagingJump = false

        wait(2, function()
            self:completeJump()
        end)
    end)

    
end

function Pilot:completeJump()
    local system = starmap.selectedSystem
    if system == nil then return false end

    fx.flash(0.5, {255, 255, 255})

    if the.system:load(system) then
        self.location = system
    else
        error('star system did not load properly')
    end

    the.system:entered()

    starmap.selectedSystem = nil

    self.ship.jumping = false
    self.ship.engagingJump = false

    local angle = starmap:angleTo(system)
    local x = math.cos(angle)*750
    local y = math.sin(angle)*750

    self.ship.body:setPosition(-x, -y)
    self.ship.body:setInertia(self.ship.inertia)
    self.ship.body:setMass(self.ship.mass)
    self.ship.body:setActive(true)
end