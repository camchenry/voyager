Weapon = class("Weapon")

function Weapon:initialize(name, fireRate, parentShip)
    self.name = name
    self.fireRate = fireRate or 100 -- rounds per minute
    self.parentShip = parentShip

    self.heat = 0
end

function Weapon:update(dt)
    if self.heat > 0 then
        self.heat = self.heat - (self.fireRate/60) * dt
    elseif self.heat < 0 then
        self.heat = 0
    end
end

function Weapon:fire(origin, target)
    local proj = Projectile:new(self.parentShip, self, origin, target)

    table.insert(the.system.projectiles, proj)
end