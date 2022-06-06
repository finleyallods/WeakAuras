-- ui

local wtCombatAdvantage
local wtDestructiveAttack
local wtFracture
local wtJaggedSlice
local wtAnimalPounce
local wtTramp
local wtViciousSpin
local wtRapidBlow
local wtDeadlyLunge
local wtBerserker
local wtBloodyHarvest
local wtTrinket

function getWtCombatAdvantage()
    return wtCombatAdvantage
end

function getWtDestructiveAttack()
    return wtDestructiveAttack
end

function getWtFracture()
    return wtFracture
end

function getWtJaggedSlice()
    return wtJaggedSlice
end

function getWtAnimalPounce()
    return wtAnimalPounce
end

function getWtTramp()
    return wtTramp
end

function getWtViciousSpin()
    return wtViciousSpin
end

function getWtRapidBlow()
    return wtRapidBlow
end

function getWtDeadlyLunge()
    return wtDeadlyLunge
end

function getWtBerserker()
    return wtBerserker
end

function getWtBloodyHarvest()
    return wtBloodyHarvest
end

function getWtTrinket()
    return wtTrinket
end

function setWtCombatAdvantage(widget)
    wtCombatAdvantage = widget
end

function setWtDestructiveAttack(widget)
    wtDestructiveAttack = widget
end

function setWtFracture(widget)
    wtFracture = widget
end

function setWtJaggedSlice(widget)
    wtJaggedSlice = widget
end

function setWtAnimalPounce(widget)
    wtAnimalPounce = widget
end

function setWtTramp(widget)
    wtTramp = widget
end

function setWtViciousSpin(widget)
    wtViciousSpin = widget
end

function setWtRapidBlow(widget)
    wtRapidBlow = widget
end

function setWtDeadlyLunge(widget)
    wtDeadlyLunge = widget
end

function setWtBerserker(widget)
    wtBerserker = widget
end

function setWtBloodyHarvest(widget)
    wtBloodyHarvest = widget
end

function setWtTrinket(widget)
    wtTrinket = widget
end

function clearWarrior()
    destroyWidget(wtJaggedSlice)
    destroyWidget(wtAnimalPounce)
    destroyWidget(wtCombatAdvantage)
    destroyWidget(wtDestructiveAttack)
    destroyWidget(wtFracture)
    destroyWidget(wtTramp)
    destroyWidget(wtViciousSpin)
    destroyWidget(wtRapidBlow)
    destroyWidget(wtDeadlyLunge)
    destroyWidget(wtBerserker)
    destroyWidget(wtBloodyHarvest)
    destroyWidget(wtTrinket)
end

-- state

local myId

local bloodyHarvestBuffId
local flamingBladeBuffId

local deadlyLungeCooldownStart
local deadlyLungeCooldownDuration
local jaggedSliceCooldownStart
local jaggedSliceCooldownDuration
local animalPounceCooldownStart
local animalPounceCooldownDuration
local trampCooldownStart
local trampCooldownDuration
local bloodyHarvestCooldownStart
local bloodyHarvestCooldownDuration
local viciousSpinCooldownStart
local viciousSpinCooldownDuration

function setMyId(id)
    myId = id
end

function isMe(id)
    return id == myId
end

function setBloodyHarvestBuff(buffId)
    bloodyHarvestBuffId = buffId
end

function setFlamingBladeBuffId(buffId)
    flamingBladeBuffId = buffId
end

function setDeadlyLungeCooldown(timeStamp, duration)
    deadlyLungeCooldownStart = timeStamp
    deadlyLungeCooldownDuration = duration
end

function setJaggedSliceCooldown(timeStamp, duration)
    jaggedSliceCooldownStart = timeStamp
    jaggedSliceCooldownDuration = duration
end

function setAnimalPounceCooldown(timeStamp, duration)
    animalPounceCooldownStart = timeStamp
    animalPounceCooldownDuration = duration
end

function setTrampCooldown(timeStamp, duration)
    trampCooldownStart = timeStamp
    trampCooldownDuration = duration
end

function setBloodyHarvestCooldown(timeStamp, duration)
    bloodyHarvestCooldownStart = timeStamp
    bloodyHarvestCooldownDuration = duration
end

function setViciousSpinCooldown(timeStamp, duration)
    viciousSpinCooldownStart = timeStamp
    viciousSpinCooldownDuration = duration
end

function hasFlamingBladeBuff()
    return flamingBladeBuffId ~= nil
end

function hasBoodyHarvestBuff()
    return bloodyHarvestBuffId ~= nil
end

function getEnergy()
    return unit.GetMana(myId).mana
end

function isViciousSpinOnCooldown()
    return viciousSpinCooldownStart ~= nil or viciousSpinCooldownDuration ~= nil
end

function isDeadlyLungeOnCooldown()
    return deadlyLungeCooldownStart ~= nil or deadlyLungeCooldownDuration ~= nil
end

function isTrampOnCooldown()
    return trampCooldownStart ~= nil or trampCooldownDuration ~= nil
end

function isBloodyHarvestOnCooldown()
    return bloodyHarvestCooldownStart ~= nil or bloodyHarvestCooldownDuration ~= nil
end

function getCombatAdvantage()
    return tostring(avatar.GetWarriorCombatAdvantage())
end

function isAnimalPounceOnCooldown()
    return animalPounceCooldownStart ~= nil or animalPounceCooldownDuration ~= nil
end

function isJaggedSliceOnCooldown()
    return jaggedSliceCooldownStart ~= nil or jaggedSliceCooldownDuration ~= nil
end
