
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
        return self.ship:facing({x=the.player.ship.body:getX(), y=the.player.ship.body:getY()})
    end)
    local isNotShipFacingPlayer = Condition(function()
        return not self.ship:facing({x=the.player.ship.body:getX(), y=the.player.ship.body:getY()})
    end)
    local updated = false

    local doFaceThePlayer = Action(function()
        self.ship:turnToward(the.player.ship)
        return self.ship:facing({x=the.player.ship.body:getX(), y=the.player.ship.body:getY()})
    end)
    local doFireWeapon = Action(function()
        self.ship.weapon:fire(self.ship)
        return true
    end)

    self.behavior = Selector{
        Sequence{
            isNotShipFacingPlayer,
            doFaceThePlayer
        },
        Sequence{
            isShipFacingPlayer,
            doFireWeapon
        }
    }
end

function ComputerControl:update(dt)
    self.behavior:update()
end