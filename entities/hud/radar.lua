Radar = class('Radar')

function Radar:initialize()
    self.x = 90
    self.y = love.window.getHeight() - 90
end

function Radar:update(dt)

end

function Radar:draw()
    love.graphics.setColor(255, 255, 255)
    if the.system.objects ~= nil then
        for i, system in pairs(the.system.objects) do
            love.graphics.circle("fill", )
        end
    end

    love.graphics.setColor(44, 44, 44, 200)
    love.graphics.circle("fill", self.x, self.y, 80)
end