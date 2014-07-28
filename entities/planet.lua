-- represents a Planet and any data relevant to ways you can interact with it

Planet = class("Planet")

function Planet:initialize()
    self.name = name
    self.x = 0
    self.y = 0
end

function Planet:canLand(ship)
    return true
end

function Planet:isHabitable()
    return true
end

function Planet:update(dt)

end

function Planet:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", self.x, self.y, 50)
end