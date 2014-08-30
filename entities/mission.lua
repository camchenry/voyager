MissionController = class('MissionController')

function MissionController:initialize()
	self.missions = {}
end

function MissionController:newMission(mission)
	if the.player.ship.maxCargo - the.player.ship:getCargoMass() > 0 then
		the.player.ship.maxCargo = the.player.ship.maxCargo - 1 -- each package decreases max cargo space
		mission.accepted = true
		table.insert(self.missions, mission)
		return true
	else
		return false
	end
	
end

function MissionController:checkCompletion()
	for i, mission in ipairs(self.missions) do
		if mission.destination == the.player.planet.name then
			the.player.credits = the.player.credits + mission.pay
			the.player.ship.maxCargo = the.player.ship.maxCargo + 1 -- restores cargo space
			self.missions[i] = nil
			fx.text(3, 'Completed Mission: Delivery to '..the.player.planet.name..'\nPayment: '..mission.pay..'c', 5, 5, {255, 0, 0}) 
		end
	end
end


function MissionController:find(missionType, from, to)
	if self.missions then
		for k, mission in pairs(self.missions) do
			if mission.name == missionType and mission.start == from and mission.destination == to then
				return true
			end
		end
	end
end

function MissionController:getMissions(currentPlanet)
	local missions = {}

	local starSystems = require 'data.systems'
	
	local missionNum = 5
	for systemName, system in pairs(starSystems) do
		for j, planet in pairs(system.objects) do
			if planet.data.name ~= currentPlanet then
				if #missions < missionNum then
					if not self:find('Delivery', currentPlanet, planet.data.name) then
						if math.random(5) == 1 then
							table.insert(missions, Mission:new(currentPlanet, planet.data.name, systemName))
						end
					end
				end
			end
		end
	end
	
	return missions
end

function MissionController:getMissionsInSystem(system)
	local missions = {}

	-- loop through all missions
    for k, mission in pairs(self.missions) do 
    	-- loop through all system objects
    	for k, obj in pairs(starmap.rawSystemData[system].objects) do
    		-- check to see if a mission matches up with one of the planets
    		if mission.destination == obj.data.name then
    			table.insert(missions, mission)
    		end
    	end
    end

    return missions
end


Mission = class('Mission')
function Mission:initialize(start, destinationPlanet, destinationSystem)
	self.name = 'Delivery to '..destinationPlanet
	self.pay = math.random(5000, 20000)
	self.desc = 'Take a package to '..destinationPlanet..' in '..destinationSystem..'.'
	self.start = start
	self.destination = destinationPlanet
	self.destinationSystem = destinationSystem
end