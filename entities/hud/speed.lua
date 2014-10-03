SpeedDisplay = class("SpeedDisplay")

function SpeedDisplay:initialize()
    self.ratio = 1
end

function SpeedDisplay:update(dt)
    self.ratio = (math.min(the.player.ship:getSpeed(), the.player.ship.maxSpeed) / the.player.ship.maxSpeed)

    self.ratio = round(self.ratio, 5)

    self.x = love.window.getWidth()/2
    self.y = love.window.getHeight()/2

    self.radius = love.window.getHeight()/2 - 100
end

function SpeedDisplay:draw()
    love.graphics.setColor(200, 200, 200)
    love.graphics.setLineWidth(1)

    filled_arc(self.x, self.y, self.radius+8, -math.pi/4, -math.pi/4 + (math.pi/2 * self.ratio), 2500)
    local x = self.x + math.cos(math.pi/4)*self.radius+13
    local y = self.y + math.sin(math.pi/4)*self.radius+13

    love.graphics.setFont(fontLight[18])
    love.graphics.setColor(255, 255, 255)
    local value = round(the.player.ship:getSpeed(), 0)
    love.graphics.print(tostring(value)..' km/h', x, y)

    love.graphics.origin()
end