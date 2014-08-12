PlayerControl = {
    update = function(ship, world, playership, dt)

        if love.keyboard.isDown("w") then
            ship:thrustPrograde()
        elseif love.keyboard.isDown("s") then
            ship:thrustRetrograde()
        end

        if love.keyboard.isDown("a") then
            ship:turn(-1)
        elseif love.keyboard.isDown("d") then
            ship:turn(1)
        end
<<<<<<< HEAD

        if love.keyboard.isDown(" ") then
            ship.weapon:fire(ship, {x=love.mouse.getX(), y=love.mouse.getY()})
        end
    end,
=======
		
		-- Automatically selects a planet if the ship is over it
		game.selectedObject = nil
		local x, y = ship.body:getPosition()
		
		for k, planet in pairs(the.system.objects) do
			if x >= planet.x - planet.radius - 10 and x <= planet.x + planet.radius + 10 and y >= planet.y - planet.radius - 10 and y <= planet.y + planet.radius + 10 then
				game.selectedObject = planet
				break
			end
		end
    end
>>>>>>> 2f23d84ac57ddfd33a79e15435ea0acc1d6c3344
}