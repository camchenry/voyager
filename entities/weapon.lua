Weapon = class("Weapon")

function Weapon:initialize(name, damage, fireRate, spread, parentShip)
    self.name = name
    self.damage = damage or 50 -- hull points?
    self.fireRate = fireRate or 100 -- rounds per minute
    self.spread = spread or 5 -- degrees (converted to radians)
    self.parentShip = parentShip

    self.heat = 0
end

function Weapon:update(dt)
    if self.heat > 0 then
        self.heat = self.heat - (self.fireRate/60) * dt
    end
end

function Weapon:fire(origin)
    assert(origin ~= nil, "did not include origin point for weapon:fire()")

    if self.heat <= 0 then
        self.heat = 1 
        local proj = Projectile:new(self.parentShip, self, origin, target)

        table.insert(the.system.projectiles, proj)
    end
end