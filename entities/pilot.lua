-- This class represents the pilot (player)

Pilot = class("Pilot")

function Pilot:initialize(first, last, gender)
    self.firstName = first
    self.lastName = last
    self.name = first .. " " .. last
    self.gender = gender

    self.ship = Ship:new(the.system.world)
    self.location = "Sol"
    self.planet = nil

    self.credits = 25000
end

function Pilot:jump()
    local system = starmap.selectedSystem
    if system == nil then return false end

    assert(system ~= self.location)

    self.ship.jumping = true

    -- system is selected, time to jump
    self.ship.body:setLinearVelocity(0, 0)
	self.ship.body:setPosition(50, 50) -- Places the ship near the center of the system

    fx.flash(0.5, {255, 255, 255})

    if the.system:load(system) then
        self.location = system
    end

    the.system:entered()

    starmap.selectedSystem = nil

    self.ship.jumping = false
end