bbs = {}

function bbs:init()
	self.leaveButton = Button:new("< LEAVE", 25, love.window.getHeight()-80, nil, nil, font[32], function() state.switch(landed) end)
end

function bbs:enter()
	local controller = game.missionController
	local bbsOptions = controller:generateMissions(the.player.planet.name)

	self.bbsList = BBS:new(bbsOptions)
	
	-- returns mission data when accepted
	self.bbsList.returnMission = function (mission)
		local accepted, problem = controller:acceptMission(mission)

		if not accepted then
			fx.text(3, problem, 5, 5, {255, 0, 0})
		end

		return accepted
	end
end

function bbs:update()
	self.bbsList:update()
end

function bbs:mousepressed(x, y, mbutton)
	self.bbsList:mousepressed(x, y, mbutton)
	self.leaveButton:mousepressed(x, y, mbutton)
end

function bbs:draw()
	love.graphics.setFont(fontBold[40])
    love.graphics.print(the.player.planet.name..' > BBS', 25, 25)

	self.leaveButton:draw()
	self.bbsList:draw()
end