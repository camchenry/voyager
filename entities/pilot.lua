-- This class represents the pilot (player)

Pilot = class("Pilot")

function Pilot:initialize(first, last, gender)
    self.firstName = first
    self.lastName = last
    self.name = first .. " " .. last
    self.gender = gender
end