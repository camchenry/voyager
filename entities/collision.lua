collision = {}

function collision.findShip(fixture)
    local attachedBody = fixture:getBody()

    -- player shortcut
    if attachedBody == the.player.ship.body then
        return the.player.ship
    end 

    for i, entity in pairs(the.system.entities) do
        if entity.body == attachedBody then
            return entity
        end
    end
end

function collision.findProjectile(fixture)
    local attachedBody = fixture:getBody()

    for i, projectile in pairs(the.system.projectiles) do
        if projectile.body == attachedBody then
            return projectile
        end
    end
end

function collision.beginContact(objA, objB, contact)
    if objA:getUserData() == "projectile" and objB:getUserData() == "ship" then
        local ship = collision.findShip(objB)
        ship:takeDamage(collision.findProjectile(objA))
    elseif objA:getUserData() == "ship" and objB:getUserData() == "projectile" then
        local ship = collision.findShip(objA)
        ship:takeDamage(collision.findProjectile(objB))
    end

    if objA:getUserData() == "projectile" then
        objA:setUserData("destroy")
        contact:setEnabled(false)
    end

    if objB:getUserData() == "projectile" then
        objB:setUserData("destroy")
        contact:setEnabled(false)
    end
end

function collision.endContact(this, that, contact)

end

function collision.preSolve(this, that, contact)

end

function collision.postSolve(this, that, contact)

end