
local READY = "ready"
local RUNNING = "running"
local FAILED = "failed"

Action = class("Action")
function Action:initialize(task)
    self.task = task
    self.completed = false
end

function Action:update(creatureAI)
    if self.completed then return READY end
    self.completed = self.task(creatureAI)
    return RUNNING
end

Condition = class("Condition")
function Condition:initialize(condition)
    self.condition = condition
end

function Condition:update(creatureAI)
    return self.condition(creatureAI) and READY or FAILED
end

Inverter = class("Inverter")
function Inverter:initialize(cond)
    self.condition = cond.condition
end

function Inverter:update(creatureAI)
    return not self.condition(creatureAI) and READY or FAILED
end

Selector = class("Selector")
function Selector:initialize(children)
    self.children = children
end

function Selector:update(creatureAI)
    for i, child in ipairs(self.children) do
        local status = child:update(creatureAI)

        if status == RUNNING then
            return RUNNING
        elseif status == READY then
            if i == #self.children then
                self:resetChildren()
                return READY
            end
        end
    end
    return READY
end

function Selector:resetChildren()
    for i, child in ipairs(self.children) do
        child.completed = false
    end
end

Sequence = class("Sequence")
function Sequence:initialize(children)
    self.children = children
    self.last = nil
    self.completed = false
end

function Sequence:update(creatureAI)
    if self.completed then return READY end

    local last = 1

    if self.last and self.last ~= #self.children then
        last = self.last + 1
    end

    for i = last, #self.children do
        local child = self.children[i]:update(creatureAI)

        if child == RUNNING then
            self.last = i
            return RUNNING
        elseif child == FAILED then
            self.last = nil
            self:resetChildren()
            return FAILED
        elseif child == READY then
            if i == #self.children then
                self.last = nil
                self:resetChildren()
                self.completed = true
                return READY
            end
        end
    end

end

function Sequence:resetChildren()
    for i, child in ipairs(self.children) do
        child.completed = false
    end
end

-------------------

local TRUE = function() return true end
local FALSE = function() return false end

ComputerControl = class("ComputerControl")

function ComputerControl:initialize(ship, world)
    self.ship = ship
    self.world = world or the.system.world

    self:createAI()    
end

function ComputerControl:createAI()
    local isShipFacingPlayer = Condition(function()
        return self.ship:facing(the.player.ship)
    end)
    local isNotShipFacingPlayer = Inverter(isShipFacingPlayer)
    local isNearPlayer = Condition(function()
        local x, y = self.ship.body:getPosition()
        local x2, y2 = the.player.ship.body:getPosition()
        return math.sqrt((x2 - x)^2 + (y2 - y)^2) < 250
    end)
    local isPlayerAttacking = Condition(function()
        if the.player.ship.destroyed then return false end
        return the.player.ship:facing(self.ship, math.rad(35))
    end)

    local doFaceThePlayer = Action(function()
        self.ship:turnToward(the.player.ship)
        return self.ship:facing(the.player.ship)
    end)
    local doFacePredictedPosition = Action(function()
        -- Instead of shooting where the ship is now, it needs to fire where the
        -- ship will be in the future, with some degree of accuracy.

        local selfVelocity = vector(self.ship.body:getLinearVelocity())
        local selfPosition = vector(self.ship.body:getPosition())

        local otherVelocity = vector(the.player.ship.body:getLinearVelocity())
        local otherPosition = vector(the.player.ship.body:getPosition())

        -- T = how far ahead to predict (in frames)
        -- If T is a constant, it will have problems when a target is very close,
        -- because it's continuing to predict the target's position.

        -- This can be solved by having a dynamic value for T based on distance to target
        local distanceToTarget = (otherPosition - selfPosition):len()
        local T = (distanceToTarget / 750)
        fx.text(love.timer.getDelta(), tostring(T), 0, 250)
        self.predictionVector = otherPosition + (otherVelocity)*T

        local point = {
            x = self.predictionVector.x,
            y = self.predictionVector.y,
        }

        self.ship:turnToward(point)
        return self.ship:facing(point, math.rad(5))
    end)
    local doFireWeapon = Action(function()
        self.ship.weapon:fire(self.ship)
        return true
    end)
    local doMoveTowardPlayer = Action(function()
        --self.ship:thrustPrograde()
        return true
    end)
    local doEvade = Action(function()
        self.ship:thrustRetrograde()
        self.ship:thrustRetrograde()
        self.ship:thrustRetrograde()
        return true
    end)

    self.seekAndDestroy = Selector{
        --Sequence{
        --    isPlayerAttacking,
        --    isNearPlayer,
        --    doEvade
        --},
        Sequence{
            doFacePredictedPosition,
            doFireWeapon
        }
    }

    self.stayCloseAndFollow = Selector{
        Sequence{
            doFaceThePlayer,
            Inverter(isNearPlayer),
            doMoveTowardPlayer,
        }
    }

    self.none = Selector{}

    self.behavior = self.seekAndDestroy
end

function ComputerControl:update(dt)
    self.behavior:update()

    if the.player.ship.destroyed then
        self.behavior = self.none
    end
end

function ComputerControl:keypressed(key, isrepeat)
    --[[if the.player.ship:getCargoValue() > 6000 then
        self.behavior = self.seekAndDestroy
    else
        self.behavior = self.seekAndDestroy
    end]]
end