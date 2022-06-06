local myId

local warriorState = {
    myId = nil,
    bloodyHarvestBuffId = nil,
    flamingBladeBuffId = nil,
    turtleBuffId = nil,
    adrenalineSurgeBuffId = nil,
    deadlyLungeCooldownStart = nil,
    deadlyLungeCooldownDuration = nil,
    jaggedSliceCooldownStart = nil,
    jaggedSliceCooldownDuration = nil,
    animalPounceCooldownStart = nil,
    animalPounceCooldownDuration = nil,
    trampCooldownStart = nil,
    trampCooldownDuration = nil,
    bloodyHarvestCooldownStart = nil,
    bloodyHarvestCooldownDuration = nil,
    viciousSpinCooldownStart = nil,
    viciousSpinCooldownDuration = nil,
    turtleCooldownStart = nil,
    turtleCooldownDuration = nil,
    adrenalineSurgeCooldownStart = nil,
    adrenalineSurgeCooldownDuration = nil
}

--function getWarriorState()
--    return warriorState
--end

function setMyId(id)
    myId = id
end

function isMe(id)
    return id == myId
end

function setBloodyHarvestBuff(buffId)
    warriorState.bloodyHarvestBuffId = buffId
end

function setFlamingBladeBuffId(buffId)
    warriorState.flamingBladeBuffId = buffId
end

function setTurtleBuffId(buffId)
    warriorState.turtleBuffId = buffId
end

function setAdrenalineSurgeBuffId(buffId)
    warriorState.adrenalineSurgeBuffId = buffId
end

function setDeadlyLungeCooldown(timeStamp, duration)
    warriorState.deadlyLungeCooldownStart = timeStamp
    warriorState.deadlyLungeCooldownDuration = duration
end

function setJaggedSliceCooldown(timeStamp, duration)
    warriorState.jaggedSliceCooldownStart = timeStamp
    warriorState.jaggedSliceCooldownDuration = duration
end

function setAnimalPounceCooldown(timeStamp, duration)
    warriorState.animalPounceCooldownStart = timeStamp
    warriorState.animalPounceCooldownDuration = duration
end

function setTrampCooldown(timeStamp, duration)
    warriorState.trampCooldownStart = timeStamp
    warriorState.trampCooldownDuration = duration
end

function setBloodyHarvestCooldown(timeStamp, duration)
    warriorState.bloodyHarvestCooldownStart = timeStamp
    warriorState.bloodyHarvestCooldownDuration = duration
end

function setViciousSpinCooldown(timeStamp, duration)
    warriorState.viciousSpinCooldownStart = timeStamp
    warriorState.viciousSpinCooldownDuration = duration
end

function setTurtleCooldown(timeStamp, duration)
    warriorState.turtleCooldownStart = timeStamp
    warriorState.turtleCooldownDuration = duration
end

function setAdrenalineSurgeCooldown(timeStamp, duration)
    warriorState.adrenalineSurgeCooldownStart = timeStamp
    warriorState.adrenalineSurgeCooldownDuration = duration
end

function hasFlamingBladeBuff()
    return warriorState.flamingBladeBuffId ~= nil
end

function hasBoodyHarvestBuff()
    return warriorState.bloodyHarvestBuffId ~= nil
end

function hasTurtleBuff()
    return warriorState.turtleBuffId ~= nil
end

function hasAdrenalineSurgeBuff()
    return warriorState.adrenalineSurgeBuffId ~= nil
end

function getEnergy()
    return unit.GetMana(myId).mana
end

function isViciousSpinOnCooldown()
    return warriorState.viciousSpinCooldownStart ~= nil or warriorState.viciousSpinCooldownDuration ~= nil
end

function isDeadlyLungeOnCooldown()
    return warriorState.deadlyLungeCooldownStart ~= nil or warriorState.deadlyLungeCooldownDuration ~= nil
end

function isTrampOnCooldown()
    return warriorState.trampCooldownStart ~= nil or warriorState.trampCooldownDuration ~= nil
end

function isBloodyHarvestOnCooldown()
    return warriorState.bloodyHarvestCooldownStart ~= nil or warriorState.bloodyHarvestCooldownDuration ~= nil
end

function getCombatAdvantage()
    return tostring(avatar.GetWarriorCombatAdvantage())
end

function isAnimalPounceOnCooldown()
    return warriorState.animalPounceCooldownStart ~= nil or warriorState.animalPounceCooldownDuration ~= nil
end

function isJaggedSliceOnCooldown()
    return warriorState.jaggedSliceCooldownStart ~= nil or warriorState.jaggedSliceCooldownDuration ~= nil
end

function isTurtleOnCooldown()
    return warriorState.turtleCooldownStart ~= nil or warriorState.turtleCooldownDuration ~= nil
end

function isAdrenalineSurgeOnCooldown()
    return warriorState.adrenalineSurgeCooldownStart ~= nil or warriorState.adrenalineSurgeCooldownStart ~= nil
end
