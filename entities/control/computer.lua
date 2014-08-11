ComputerControl = {
    update = function(ship, world, playership, dt)

        local facing = ship:facing({x=playership.body:getX(), y=playership.body:getY()})

        if not facing then
            ship:turnToward(playership)
        end

        if facing then
            ship:thrustPrograde()
            ship.weapon:fire(ship)
        end

    end
}