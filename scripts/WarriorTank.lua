function getWarriorTankViciousSpinTextColor()
    if isOnCd("Vicious Spin") then
        return nil
    end

    if getEnergy() < 47 then
        return nil
    end

    return COLOR_AOE
end

function getWarriorTankDeadlyLungeTextColor()
    if isOnCd("Deadly Lunge") then
        return nil
    end

    if hasBuff("Bloody Harvest") then
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

function getWarriorTankBloodyHarvestTextColor()
    if isOnCd("Bloody Harvest") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() < 30 then
        return COLOR_IMPOSSIBLE
    end

    if avatar.GetWarriorCombatAdvantage() < 45 or isOnCd("Deadly Lunge") then
        return COLOR_BAD
    end

    return COLOR_NORMAL
end

function getWarriorTankTrampTextColor()
    if isOnCd("Tramp") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() < 55 then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getWarriorTankDestructiveAttackTextColor()
    if hasBuff("Flaming Blade") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() > 75 then
        return getEnergy() >= 39 and COLOR_BAD or COLOR_IMPOSSIBLE
    end

    if not hasBuff("Bloody Harvest")
    then
        return getEnergy() >= 39 and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or COLOR_BAD
end

function getWarriorTankFractureTextColor()
    if not hasBuff("Flaming Blade") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() > 75 then
        return getEnergy() >= 29 and COLOR_BAD or COLOR_IMPOSSIBLE
    end

    if not hasBuff("Bloody Harvest")
    then
        return getEnergy() >= 29 and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or COLOR_BAD
end

function getWarriorTankRapidBlowTextColor()
    if not isOnCd("Deadly Lunge") then
        return nil
    end

    if hasBuff("Bloody Harvest") then
        return avatar.GetWarriorCombatAdvantage() >= 45 and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    if avatar.GetWarriorCombatAdvantage() > 85 then
        return COLOR_NORMAL
    end

    if avatar.GetWarriorCombatAdvantage() > 75 and hasBuff("Flaming Blade") then
        return COLOR_NORMAL
    end

    return nil
end

function getWarriorTankBerserkerTextColor()
    return isOnCd("Berserker")
end

function evaluateWarriorTankPriority()
    evaluate(getWtDeadlyLunge, getWarriorTankDeadlyLungeTextColor)
    evaluate(getWtTramp, getWarriorTankTrampTextColor)
    evaluate(getWtDestructiveAttack, getWarriorTankDestructiveAttackTextColor)
    evaluate(getWtFracture, getWarriorTankFractureTextColor)
    evaluate(getWtRapidBlow, getWarriorTankRapidBlowTextColor)
    evaluate(getWtBloodyHarvest, getWarriorTankBloodyHarvestTextColor)
    evaluate(getWtViciousSpin, getWarriorTankViciousSpinTextColor)
    evaluate(getWtBerserker, getWarriorTankBerserkerTextColor)
end

function onWarriorTankUnitManaChanged(params)
    if isMe(params.unitId) then
        evaluateWarriorTankPriority()
    end
end

function onWarriorTankCombatAdvantageChanged()
    getWtCombatAdvantage():SetVal("value", getCombatAdvantage())
    evaluateWarriorTankPriority()
end

local CD_SETTER_MAP = {
    [2] = "Tramp",
    [4] = "Vicious Spin",
    [6] = "Deadly Lunge",
    [29] = "Berserker",
    [30] = "Bloody Harvest"
}

function onWarriorTankActionPanelElementEffect(params)
    checkAllCDs(CD_SETTER_MAP, params, setCD)
    checkAllCDs(getWarriorUtilityCDMap(), params, setCD)
    evaluateWarriorTankPriority()
end

function getWarriorTankBuffs()
    return {"Bloody Harvest", "Flaming Blade"}
end

function onWarriorTankBuffAdded(params)
    if not isMe(params.objectId) then
        return
    end

    checkAllBuffs(getWarriorTankBuffs(), params, true)
    checkAllBuffs(getWarriorUtilityBuffs(), params, true)
end

function onWarriorTankBuffRemoved(params)
    if not isMe(params.objectId) then
        return
    end

    checkAllBuffs(getWarriorTankBuffs(), params, false)
    checkAllBuffs(getWarriorUtilityBuffs(), params, false)
end

function onWarriorTankEventEquipmentItemEffect(params)
    if params.slot ~= DRESS_SLOT_TRINKET or params.slotType ~= ITEM_CONT_EQUIPMENT then
        return
    end

    if params.effect ~= EFFECT_TYPE_COOLDOWN_STARTED and params.effect ~= EFFECT_TYPE_COOLDOWN_FINISHED then
        return
    end

    if params.effect == EFFECT_TYPE_COOLDOWN_STARTED and params.duration < 1500 then
        return
    end

    local activate = params.effect == EFFECT_TYPE_COOLDOWN_FINISHED
    getWtTrinket():Show(activate)
end

function initWarriorTank()
    setWtCombatAdvantage(createTextView("CombatAdvantage", 40, 500, getCombatAdvantage()))
    setWtDestructiveAttack(createTextView("DestructiveAttack", 40, 425, "1"))
    setWtFracture(createTextView("Fracture", 90, 450, "2"))
    setWtTramp(createTextView("Tramp", 110, 500, "3"))
    setWtViciousSpin(createTextView("ViciousSpin", -30, 500, "#"))
    setWtRapidBlow(createTextView("RapidBlow", -10, 550, "6"))
    setWtDeadlyLunge(createTextView("DeadlyLunge", 90, 550, "7"))
    setWtBerserker(createTextView("Berserker", -10, 650, "s6"))
    setWtBloodyHarvest(createTextView("BloodyHarvest", 90, 650, "s7"))
    setWtTrinket(createTextView("Trinket", 40, 625, "*"))

    setTextColor(getWtTrinket(), COLOR_TRINKET)

    evaluateWarriorTankPriority()
end