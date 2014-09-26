intro = {}

intro.sequences = {
    "In the late 22nd century, the Terran Federation organized a mission to colonize distant star systems. It was a volunteer only mission and millions of people applied. Anyone, regardless of legal status could apply to the mission. It was an opportunity to start again in a new world without the past catching up to you. In 2178, the mission was approved, the crew were selected, and the ships were finally launched in 2182.",

    "A civil war broke out in 2193 between the Federation and the Rebels. The records of the ships were lost in the war, and they were forgotten entirely during the chaos of the war. More than 300 years later, the ship that you were on has finally arrived at its destination only to find that it is already inhabited. The Federation is granting amnesty to those who may have committed crimes in the past and is giving everyone on these ships some credits and a ship to help them start their new life."
}

function intro:enter()
    fx.flash(0.5, {0, 0, 0})

    self.currentSequence = 1
    self.switching = false

    self.continue = Button:new("Continue >", 100, love.graphics.getHeight()-100)
    self.continue.activated = function()
        self.currentSequence = self.currentSequence + 1
    end
end

function intro:update(dt)
    if self.switching then return end

    if self.currentSequence > #self.sequences then
        self.currentSequence = #self.sequences
        fx.fade(0.75, {0, 0, 0}, nil, state.switch, start)
        self.switching = true
    end
end

function intro:keypressed(key, isrepeat)
    if self.switching then return end

    if key == "escape" or key == "enter" then
        self.currentSequence = self.currentSequence + 1
    end
end

function intro:mousepressed(x, y, mbutton)
    if self.switching then return end

    self.continue:mousepressed(x, y, mbutton)
end

function intro:draw()
    local limit = math.min(1080, love.graphics.getWidth()-200)
    love.graphics.printf(self.sequences[self.currentSequence], 100, 100, limit, "left")

    if not self.switching then
        self.continue:draw()
    end

    fx.draw()
end