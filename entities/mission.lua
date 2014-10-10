MissionController = class('MissionController')

NOT_ENOUGH_CARGO_SPACE = 1

MissionController.static.PROBLEM_MESSAGES = {
	[NOT_ENOUGH_CARGO_SPACE] = "Not enough available cargo space. 1 ton required."
}

function MissionController:initialize()
	self.missions = {}
	self.availableMissions = {}
end

-- returns list of accepted missions that haven't been completed yet
function MissionController:getActiveMissions()
	return self.missions
end

function MissionController:getAvailableMissions()
	return self.availableMissions
end

-- tries to accept a mission
-- returns whether you can accept or not (boolean), and the problem (string)
function MissionController:acceptMission(mission)
	local canAccept, problem = self:canAcceptMission(mission)

	if canAccept then
		table.insert(self.missions, mission)
	end

	if problem ~= nil then
		problem = MissionController.PROBLEM_MESSAGES[problem]
	end

	return canAccept, problem
end

-- returns whether you can accept the mission or not (boolean), and why not (number)
function MissionController:canAcceptMission(mission)
	-- at least 1 ton of cargo space
	if the.player.ship.maxCargo == the.player.ship:getCargoMass() then
		return false, NOT_ENOUGH_CARGO_SPACE
	end

	-- player can accept mission
	return true, nil
end

-- check all missions to see if they have been completed
function MissionController:checkCompletion()
	for i, mission in ipairs(self.missions) do
		if mission:isComplete() then
			the.player.credits = the.player.credits + mission.pay
			the.player.ship.maxCargo = the.player.ship.maxCargo + 1 -- restores cargo space
			self.missions[i] = nil
			fx.text(3, 'Completed Mission:'..mission.name..'\nPayment: '..mission.pay..'c', 5, 350, {255, 0, 0}) 
		end
	end
end

-- generate a list of Missions
function MissionController:generateMissions(currentPlanet)
	local missions = {}
	local missionNum = math.random(1, 5)

	for i=1, missionNum do
		local planet, system = starmap:getRandomPlanet()

		-- mission destination can't be the current system/planet
		while planet == the.player.planet or system == the.player.location do
			planet, system = starmap:getRandomPlanet()
		end

		if math.random() > 0.5 then
			table.insert(missions, Mission:new(currentPlanet, planet, system))
		else
			table.insert(missions, BountyMission:new(system))
		end
	end
	
	return missions
end

function MissionController:update()
	self.availableMissions = self:generateMissions(the.player.planet.name)
end

-- returns a list of Missions that have destinations in a specific system
function MissionController:getMissionsInSystem(system)
	local missions = {}

	-- loop through all missions
    for k, mission in pairs(self.missions) do 
    	-- only add missions with destinations in the system specified
    	if mission.destinationSystem == system then
    		table.insert(missions, mission)
    	end
    end

    return missions
end


Mission = class('Mission')
function Mission:initialize(start, destinationPlanet, destinationSystem)
	self.name = 'Delivery to '..destinationPlanet
	self.description = 'Take a package to '..destinationPlanet..' in the '..destinationSystem..' system.'

	self.pay = math.floor(starmap:distanceTo(destinationSystem))
	self.pay = self.pay + math.floor(math.random(-self.pay/4, self.pay/4))

	self.start = start
	self.destination = destinationPlanet
	self.destinationSystem = destinationSystem
end

function Mission:isComplete()
	return self.destination == the.player.planet.name
end

BountyMission = class('BountyMission')
function BountyMission:initialize(destinationSystem)
	self.name = "Bounty"
	self.description = "Kill a wanted pilot that is currently hiding in the "..destinationSystem.." system."

	self.pay = 100

	self.destinationSystem = destinationSystem
	self.target = Ship:new()
end

function BountyMission:isComplete()
	return self.target.destroyed
end