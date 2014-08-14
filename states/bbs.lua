bbs = {}

function bbs:init()
	local bbsOptions = require 'data.missions'
	self.bbsList = BBS:new(bbsOptions)
	self.bbsList.returnMission = function (mission)
		the.player.mission = mission
		error(dump(the.player.mission))
	end
	
	self.leaveButton = Button:new("< LEAVE", 25, love.window.getHeight()-80, nil, nil, font[32], function() state.switch(landed) end)
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