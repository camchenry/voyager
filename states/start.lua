start = {}

start.items = {

}

function start:enter()
    self.pilotFirstInput = Input:new(25, 150, 400, nil, font[24])
    self.pilotLastInput = Input:new(self.pilotFirstInput.x+self.pilotFirstInput.width, 150, 400, nil, font[24])

    self.pilotFirstInput.textLimit = 30
    self.pilotLastInput.textLimit = 30
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

    self.pilotFirstInput:draw()
    self.pilotLastInput:draw()

    love.graphics.setFont(fontLight[24])
    love.graphics.print("FIRST NAME", self.pilotFirstInput.x, self.pilotFirstInput.y+50)
    love.graphics.print("LAST NAME", self.pilotLastInput.x, self.pilotFirstInput.y+50)
end