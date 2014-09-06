Collision = class("Collision")

function Collision:initialize()

end

function Collision.static.findShip(fixture)
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

function Collision.static.findProjectile(fixture)
    local attachedBody = fixture:getBody()

    for i, projectile in pairs(the.system.projectiles) do
        if projectile.body == attachedBody then
            return projectile
        end
    end
end


-- this is in dire need of refactoring

function Collision.beginContact(objA, objB, contact)
    if objA:getUserData() == "projectile" and objB:getUserData() == "ship" then
        local ship = Collision.findShip(objB)
        ship:takeDamage(Collision.findProjectile(objA))
    elseif objA:getUserData() == "ship" and objB:getUserData() == "projectile" then
        local ship = Collision.findShip(objA)
        ship:takeDamage(Collision.findProjectile(objB))
    elseif objA:getUserData() == "ship" and objB:getUserData() == "ship" then
        contact:setEnabled(false)
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

function Collision.endContact(this, that, contact)

end

function Collision.preSolve(this, that, contact)

end

function Collision.postSolve(this, that, contact)

end