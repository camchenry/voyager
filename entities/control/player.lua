PlayerControl = {
    update = function(ship, dt)

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

    end
}