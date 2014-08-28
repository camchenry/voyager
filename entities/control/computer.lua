
-- experimental state machinane implementation
-- from: http://replayism.com/code/finite-state-machine-lua/

local StateMachine = class("StateMachine")

function StateMachine:initialize(entity, currentState, previousState)
    --only entity and currentState required
    self.curState = currentState
    self.prevState = previousState
    self.entity = entity

    self.states = {}

    self.states[currentState.name] = currentState
    if previousState then
        self.states[previousState.name] = previousState
    end
end

function StateMachine:update()
    self.curState.execute(self.entity)
end

function StateMachine:addState(newState)
    self.states[newState.name] = newState
end

function StateMachine:changeState(newStateName)
    self.prevState = self.curState
    self.curState.exit(self.entity)
    self.curState = self.states[newStateName]
    self.curState.enter(self.entity)
end

function StateMachine:revertState()
    self:changeState(self.prevState.name)
end

function StateMachine:isInState(stateName)
    return stateName == self.curState.name
end

local State = class("State")

function State:initialize(name, enter, execute, exit)
    self.name = name

    --param: entity
    self.enter = enter or function() end
    self.execute = execute or function() end
    self.exit = exit or function() end
end

-----------------------------------------------



ComputerControl = class("ComputerControl")

function ComputerControl:initialize(ship, world)
    self.ship = ship
    self.world = world or the.system.world

    self:createAI()    
    self.stateMachine = StateMachine:new(self.ship, self.pursuitState)
    self.stateMachine:addState(self.pursuitState)
end

function ComputerControl:createAI()
    local function predictedPosition(ship, target)
        -- This will predict where a ship is going to be, with some amount of accuracy

        local velocity = vector(ship.body:getLinearVelocity())
        local position = vector(ship.body:getPosition())

        local targetVelocity = vector(target.body:getLinearVelocity())
        local targetPosition = vector(target.body:getPosition())

        -- T = how far ahead to predict (in frames)
        -- If T is a constant, it will have problems when a target is very close,
        -- because it's continuing to predict the target's position.

        -- This can be solved by having a dynamic value for T based on distance to target
        local distanceToTarget = (targetPosition - position):len()
        local T = (distanceToTarget / ship.maxSpeed)
        local predicted = targetPosition + targetVelocity*T
        return predicted
    end

    local function distance(ship, target)
        local position = vector(ship.body:getPosition())
        local targetPosition = vector(target.body:getPosition())

        return (targetPosition - position):len()
    end

    -- for more details on the steering behaviors
    -- see: http://www.red3d.com/cwr/steer/gdc99/

    self.pursuitState = State:new("pursuit")
    self.pursuitState.execute = function(ship)

        -- similar to leading a projectile shot, in order to effectively pursue
        -- a target you need to predict where it's going to be

        local selfVelocity = vector(ship.body:getLinearVelocity())
        local selfPosition = vector(ship.body:getPosition())

        local otherVelocity = vector(the.player.ship.body:getLinearVelocity())
        local otherPosition = vector(the.player.ship.body:getPosition())

        local predicted = predictedPosition(self.ship, the.player.ship)
        self.predictionVector = predicted

        local desired = (predicted - selfPosition):normalized() * self.ship.speed*2
        local steer = (desired - selfVelocity):limit(ship.maxForce)

        ship.body:applyForce(steer.x, steer.y)
        ship:turnToward(predicted)

        if distance(self.ship, the.player.ship) <= 900 and ship:facing(the.player.ship, math.rad(ship.weapon.spread*2)) then
            self.ship.weapon:fire(self.ship)
        end

        fx.text(love.timer.getDelta(), distance(self.ship, the.player.ship), 0, 200)
    end
end

function ComputerControl:update(dt)
    self.stateMachine:update()
end

function ComputerControl:keypressed(key, isrepeat)

end