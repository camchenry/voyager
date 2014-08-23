start = {}

start.items = {

}

function start:enter()
    self.pilotFirstInput = Input:new(25, 100, 400, nil, font[28])
    self.pilotLastInput = Input:new(25, self.pilotFirstInput.y+75, self.pilotFirstInput.width, nil, font[28])

    self.pilotFirstInput.textLimit = 25
    self.pilotLastInput.textLimit = 25
    self.pilotFirstInput.singleWord = false
    self.pilotLastInput.singleWord = false

    self.pilotGender = nil


    self.pilotMale = Checkbox:new("MALE", 25, 300, nil, nil, font[28])
    self.pilotMale.activated = function() 
        self.pilotGender = "male"
        self.pilotFemale.selected = false
    end
	self.pilotMale.deactivated = function()
		self.pilotGender = nil
	end

    self.pilotFemale = Checkbox:new("FEMALE", self.pilotMale.width+150, 300, nil, nil, font[28])
    self.pilotFemale.activated = function() 
        self.pilotGender = "female"
        self.pilotMale.selected = false
    end
	self.pilotFemale.deactivated = function()
		self.pilotGender = nil
	end

    local text = "COMPLETE FORM >"
    self.completeForm = Button:new(text, love.window.getWidth()-love.graphics.getFont():getWidth(text)-25, love.window.getHeight()-80, nil, nil, font[28])
    self.completeForm.activated = function()
        self:continueToGame()
    end

    self.back = Button:new("< BACK", 25, love.window.getHeight()-80)
    self.back.activated = function()
        state.switch(menu)
    end
end

function start:validateForm()
	local errorMessage = "COMPLETE ALL FIELDS" -- default if form is invalid but reason cannot be determined
	
    local firstInput = self.pilotFirstInput.text:len() > 0
    local lastInput = self.pilotLastInput.text:len() > 0
    local gender = self.pilotGender == "male" or self.pilotGender == "female"
    local required = firstInput and lastInput and gender
	
	-- put in reverse order so that error messages give the upper forums priority (if multiple errors, firstInput error displayed, and so on)
	if not gender then errorMessage = "NO GENDER GIVEN" end
	if not lastInput then  errorMessage = "NO LAST NAME GIVEN" end
	if not firstInput then errorMessage = "NO FIRST NAME GIVEN" end
	
    return required, errorMessage
end

function start:continueToGame()
	local success, errorMessage = self:validateForm()
    if success then
        self:initializePlayer()
        the.economy = Economy:new()
        fx.reset()
        state.switch(game)
    else
        fx.text(3, errorMessage, 25, love.window.getHeight()-120, {255, 0, 0}) 
    end
end

function start:initializePlayer()
    local first = self.pilotFirstInput.text
    local last = self.pilotLastInput.text
    local gender = self.pilotGender
    the.system = StarSystem:new("default")
    the.player = Pilot:new(first, last, gender)
end

function start:leave()
    fx.reset()
end

function start:update(dt)

end

function start:keypressed(key, isrepeat)
    self.pilotFirstInput:keypressed(key, isrepeat)
    self.pilotLastInput:keypressed(key, isrepeat)
end

function start:mousepressed(x, y, mbutton)
    self.pilotMale:mousepressed(x, y, mbutton)
    self.pilotFemale:mousepressed(x, y, mbutton)
    self.completeForm:mousepressed(x, y, mbutton)
    self.back:mousepressed(x, y, mbutton)
end

function start:textinput(text)
    self.pilotFirstInput:textinput(text)
    self.pilotLastInput:textinput(text)
end

function start:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(fontBold[36])
    love.graphics.print("NEW PILOT FORM 36C-DL4 ", 25, 10)

    -- first and last name inputs

    self.pilotFirstInput:draw()
    self.pilotLastInput:draw()

    love.graphics.setFont(fontLight[18])
    love.graphics.print("FIRST NAME", self.pilotFirstInput.x, self.pilotFirstInput.y+40)
    love.graphics.print("LAST NAME", self.pilotLastInput.x, self.pilotLastInput.y+40)

    -- male and female buttons
    self.pilotMale:draw()
    self.pilotFemale:draw()
    
    self.completeForm:draw()
    self.back:draw()
end