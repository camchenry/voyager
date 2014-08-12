collision = {}

function collision.beginContact(objA, objB, contact)
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