intro = {}

intro.sequences = {
    "In the late 22nd century, the Terran Federation organized a mission to colonize distant star systems. It was a volunteer only mission and millions of people applied. Anyone, regardless of legal status could apply to the mission. It was an opportunity to start again in a new world without the past catching up to you. In 2178, the mission was approved, the crew were selected, and the ships were finally launched in 2182.",

    "A civil war broke out in 2193 between the Federation and the Rebels. The records of the ships were lost in the war, and they were forgotten entirely during the chaos of the war. More than 300 years later, the ship that you were on has finally arrived at its destination only to find that it is already inhabited. The Federation is granting amnesty to those who may have committed crimes in the past and is giving everyone on these ships some credits and a ship to help them start their new life."
}

function intro:enter()
    fx.flash(0.5, {0, 0, 0})

    self.currentSequence = 1

    for i, seq in pairs(self.sequences) do
        wait(i*25, function() self.currentSequence = self.currentSequence + 1 end)
    end
end

function intro:update(dt)
    if self.currentSequence > #self.sequences then
        fx.reset()
        state.switch(start)
    end
end

function intro:keypressed(key, isrepeat)
    if key == "escape" or key == "enter" then
        self.currentSequence = self.currentSequence + 1
    end
end

function intro:mousepressed(x, y, mbutton)
    self.currentSequence = self.currentSequence + 1
end

function intro:draw()
    local limit = math.min(1080, love.graphics.getWidth()-200)
    love.graphics.printf(self.sequences[self.currentSequence], 100, 100, limit, "left")

    fx.draw()
end