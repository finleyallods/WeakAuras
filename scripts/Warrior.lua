local myId
local bloodyHarvestBuffId
local flamingBladeBuffId

local deadlyLungeCooldownStart
local deadlyLungeCooldownDuration
local jaggedSliceCooldownStart
local jaggedSliceCooldownDuration
local bloodyHarvestCooldownStart
local bloodyHarvestCooldownDuration
local animalPounceCooldownStart
local animalPounceCooldownDuration

Global("wtCombatAdvantage", nil)
Global("wtDestructiveAttack", nil)
Global("wtFracture", nil)
Global("wtJaggedSlice", nil)
Global("wtAnimalPounce", nil)
Global("wtRapidBlow", nil)
Global("wtDeadlyLunge", nil)
Global("wtBerserker", nil)
Global("wtBloodyHarvest", nil)
Global("wtTrinket", nil)

function hasFlamingBladeBuff()
    return flamingBladeBuffId ~= nil
end

function hasBoodyHarvestBuff()
    return bloodyHarvestBuffId ~= nil
end

function getEnergy()
    return unit.GetMana(myId).mana
end

function isAnimalPounceOnCooldown()
    return animalPounceCooldownStart ~= nil or animalPounceCooldownDuration ~= nil
end

function isDeadlyLungeOnCooldown()
    return deadlyLungeCooldownStart ~= nil or deadlyLungeCooldownDuration ~= nil
end

function isJaggedSliceOnCooldown()
    return jaggedSliceCooldownStart ~= nil or jaggedSliceCooldownDuration ~= nil
end

function isBloodyHarvestOnCooldown()
    return bloodyHarvestCooldownStart ~= nil or bloodyHarvestCooldownDuration ~= nil
end

function geAnimalPounceTextColor()
    if isAnimalPounceOnCooldown() then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() > 70 then
        return nil
    end

    if hasBoodyHarvestBuff() then
        return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or nil
    end

    return COLOR_NORMAL
end

function getDeadlyLungeTextColor()
    if isDeadlyLungeOnCooldown() then
        return nil
    end

    if hasBoodyHarvestBuff() then
        if avatar.GetWarriorCombatAdvantage() < 25 then
            return COLOR_IMPOSSIBLE
        else
            return COLOR_NORMAL
        end
    end

    if avatar.GetWarriorCombatAdvantage() >= 25 then
        return COLOR_BAD
    end

    return nil
end

function getBloodyHarvestTextColor()
    if isBloodyHarvestOnCooldown() then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() < 30 then
        return COLOR_IMPOSSIBLE
    end

    if avatar.GetWarriorCombatAdvantage() < 45 or isDeadlyLungeOnCooldown() then
        return COLOR_BAD
    end

    return COLOR_NORMAL
end

function getJaggedSliceTextColor()
    if isJaggedSliceOnCooldown() then
        return nil
    end

    if getEnergy() < 24 then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_DOT
end

function getDestructiveAttackTextColor()
    if hasFlamingBladeBuff() then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() > 75 then
        return getEnergy() >= 39 and COLOR_BAD or COLOR_IMPOSSIBLE
    end

    if not hasBoodyHarvestBuff()
    then
        return getEnergy() >= 39 and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or COLOR_BAD
end

function getFractureTextColor()
    if not hasFlamingBladeBuff() then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() > 75 then
        return getEnergy() >= 29 and COLOR_BAD or COLOR_IMPOSSIBLE
    end

    if not hasBoodyHarvestBuff()
    then
        return getEnergy() >= 29 and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or COLOR_BAD
end

function getRapidBlowTextColor()
    if not isDeadlyLungeOnCooldown() then
        return nil
    end

    if hasBoodyHarvestBuff() then
        return avatar.GetWarriorCombatAdvantage() >= 45 and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    if avatar.GetWarriorCombatAdvantage() > 85 then
        return COLOR_NORMAL
    end

    if avatar.GetWarriorCombatAdvantage() > 75 and hasFlamingBladeBuff() then
        return COLOR_NORMAL
    end

    return nil
end

function evaluate(widget, textColorGetter)
    if widget == nil then
        return
    end
    local textColor = textColorGetter()
    if textColor ~= nil then
        show(widget)
        setTextColor(widget, textColor)
    else
        hide(widget)
    end
end

function evaluatePriority()
    evaluate(wtDeadlyLunge, getDeadlyLungeTextColor)
    evaluate(wtJaggedSlice, getJaggedSliceTextColor)
    evaluate(wtDestructiveAttack, getDestructiveAttackTextColor)
    evaluate(wtFracture, getFractureTextColor)
    evaluate(wtRapidBlow, getRapidBlowTextColor)
    evaluate(wtBloodyHarvest, getBloodyHarvestTextColor)
    evaluate(wtAnimalPounce, geAnimalPounceTextColor)
end

function onUnitManaChanged(params)
    if params.unitId == myId then
        evaluatePriority()
    end
end

function getCombatAdvantage()
    return tostring(avatar.GetWarriorCombatAdvantage())
end

function onWarriorCombatAdvantageChanged()
    wtCombatAdvantage:SetVal("value", getCombatAdvantage())
    evaluatePriority()
end

function onWarriorActionPanelElementEffect(params)
    if params.effect < 1 or params.effect > 2 then
        return
    end

    if params.effect == 1 and params.duration < 1500 then
        return
    end

    local activate = params.effect == 2

    local timeStamp = params.effect == 1 and common.GetLocalDateTime() or nil

    if params.index == 2 then
        jaggedSliceCooldownStart = timeStamp
        jaggedSliceCooldownDuration = params.duration
    elseif params.index == 3 then
        animalPounceCooldownStart = timeStamp
        animalPounceCooldownDuration = params.duration
    elseif params.index == 6 then
        deadlyLungeCooldownStart = timeStamp
        deadlyLungeCooldownDuration = params.duration
    elseif params.index == 29 then
        wtBerserker:Show(activate)
    elseif params.index == 30 then
        bloodyHarvestCooldownStart = timeStamp
        bloodyHarvestCooldownDuration = params.duration
    end

    evaluatePriority()
end

function onWarriorBuffAdded(params)
    if params.objectId ~= myId then
        return
    end

    if userMods.FromWString(params.buffName) == "Bloody Harvest" then
        bloodyHarvestBuffId = params.buffId
        evaluatePriority()
    elseif userMods.FromWString(params.buffName) == "Flaming Blade" then
        flamingBladeBuffId = params.buffId
        evaluatePriority()
    end
end

function onWarriorBuffRemoved(params)
    if params.objectId ~= myId then
        return
    end

    if userMods.FromWString(params.buffName) == "Bloody Harvest" then
        bloodyHarvestBuffId = nil
        evaluatePriority()
    elseif userMods.FromWString(params.buffName) == "Flaming Blade" then
        flamingBladeBuffId = nil
        evaluatePriority()
    end
end

function onEventEquipmentItemEffect(params)
    if params.slot ~= DRESS_SLOT_TRINKET or params.slotType ~= ITEM_CONT_EQUIPMENT then
        return
    end

    if params.effect ~= EFFECT_TYPE_COOLDOWN_STARTED and params.effect ~= EFFECT_TYPE_COOLDOWN_FINISHED  then
        return
    end

    if params.effect == EFFECT_TYPE_COOLDOWN_STARTED and params.duration < 1500 then
        return
    end

    local activate = params.effect == EFFECT_TYPE_COOLDOWN_FINISHED
    wtTrinket:Show(activate)
end

function initWarrior()
    myId = avatar.GetId()
    wtCombatAdvantage = createTextView("CombatAdvantage", 40, 500, getCombatAdvantage())
    wtDestructiveAttack = createTextView("DestructiveAttack", 40, 425, "1")
    wtFracture = createTextView("Fracture", 90, 450, "2")
    wtJaggedSlice = createTextView("JaggedSlice", 110, 500, "3")
    wtAnimalPounce = createTextView("AnimalPounce", -10, 450, "4")
    wtRapidBlow = createTextView("RapidBlow", -10, 550, "6")
    wtDeadlyLunge = createTextView("DeadlyLunge", 90, 550, "7")
    wtBerserker = createTextView("Berserker", -10, 650, "s6")
    wtBloodyHarvest = createTextView("BloodyHarvest", 90, 650, "s7")
    wtTrinket = createTextView("Trinket", 40, 625, "*")

    setTextColor(wtTrinket, COLOR_TRINKET)

    common.RegisterEventHandler(onWarriorCombatAdvantageChanged, "EVENT_AVATAR_WARRIOR_COMBAT_ADVANTAGE_CHANGED")
    common.RegisterEventHandler(onUnitManaChanged, " EVENT_UNIT_MANA_CHANGED")
    common.RegisterEventHandler(onEventEquipmentItemEffect, "EVENT_EQUIPMENT_ITEM_EFFECT")

    evaluatePriority()
end