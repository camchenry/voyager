options = {}

function options:enter()
    vsync = Checkbox:new("vsync", 5, 5)
end

function options:update(dt)

end

function options:keypressed(key, isrepeat)

end

function options:mousepressed(x, y, button)
	if button == 'l' then
		vsync:mousepressed(x, y)
	end
end

function options:draw()
	vsync:draw()
end
