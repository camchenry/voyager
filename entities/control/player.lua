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

    end,

    keypressed = function(key, isrepeat, ship, world, playership)
        if key == " " then
            ship.weapon:fire(ship, {x=love.mouse.getX(), y=love.mouse.getY()})
        end
    end
}