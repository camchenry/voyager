MissionController = class('MissionController')

function MissionController:initialize()
	self.missions = {}
end

function MissionController:newMission(mission)
	table.insert(self.missions, mission)
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