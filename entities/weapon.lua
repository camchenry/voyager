Weapon = class("Weapon")

function Weapon:initialize(name, fireRate)
    self.name = name
    self.fireRate = fireRate or 100 -- rounds per minute

    self.heat = 0
end

function Weapon:update(dt)
    if self.heat > 0 then
        self.heat = self.heat - (self.fireRate/60) * dt
    elseif self.heat < 0 then
        self.heat = 0
    end
end

function Weapon:fire()
    
end