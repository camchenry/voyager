start = {}

start.items = {

}

function start:enter()
    self.pilotFirstInput = Input:new(25, 100, 400, nil, font[28])
    self.pilotLastInput = Input:new(25, self.pilotFirstInput.y+75, self.pilotFirstInput.width, nil, font[28])

    self.pilotFirstInput.textLimit = 25
    self.pilotLastInput.textLimit = 25
    self.pilotFirstInput.singleWord = true
    self.pilotLastInput.singleWord = true

    self.pilotGender = nil


    self.pilotMale = Button:new("MALE", 70, 280, nil, nil, font[28], function() self.pilotGender = "male" end)
    self.pilotFemale = Button:new("FEMALE", self.pilotMale.width+150, 280, nil, nil, font[28], function() self.pilotGender = "female" end)

    self.completeForm = Button:new("COMPLETE FORM >", 25, love.window.getHeight()-80, nil, nil, font[28], function() self:continueToGame() end)
end

function start:validateForm()
    local firstInput = self.pilotFirstInput.text:len() > 1
    local lastInput = self.pilotLastInput.text:len() > 1
    local gender = self.pilotGender == "male" or self.pilotGender == "female"
    local required = firstInput and lastInput and gender
    return required
end

function start:continueToGame()
    if self:validateForm() then
        self:initializePlayer()
        state.switch(game)
    else
        fx.fadeText(1, 4, "COMPLETE ALL FIELDS", 25, love.window.getHeight()-120, {255, 0, 0}) 
    end
end

function start:initializePlayer()
    local first = self.pilotFirstInput.text
    local last = self.pilotLastInput.text
    local gender = self.pilotGender
    the.system = game.systems["Sol"]
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

    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", self.pilotMale.x-40, self.pilotMale.y+10, 30, 30)
    if self.pilotGender == "male" then
        love.graphics.line(self.pilotMale.x-40, self.pilotMale.y+10, self.pilotMale.x-10, self.pilotMale.y+40)
    end

    love.graphics.rectangle("line", self.pilotFemale.x-40, self.pilotFemale.y+10, 30, 30)
    if self.pilotGender == "female" then
        love.graphics.line(self.pilotFemale.x-40, self.pilotFemale.y+10, self.pilotFemale.x-10, self.pilotFemale.y+40)
    end

    -- trade contract selection

    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 25, 370, 450, 270)

    love.graphics.print("NO TRADE CONTRACTS FOUND", 35, 375)

    self.completeForm:draw()
end