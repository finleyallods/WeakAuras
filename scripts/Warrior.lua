function geAnimalPounceTextColor()
    if isOnCd("Animal Pounce") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() > 70 then
        return nil
    end

    if hasBuff("Bloody Harvest") then
        return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or nil
    end

    return COLOR_NORMAL
end

function getDeadlyLungeTextColor()
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

function getBloodyHarvestTextColor()
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

function getJaggedSliceTextColor()
    if isOnCd("Jagged Slice") then
        return nil
    end

    if getEnergy() < 24 then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_DOT
end

function getDestructiveAttackTextColor()
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

function getFractureTextColor()
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

function getRapidBlowTextColor()
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

function evaluatePriority()
    evaluate(getWtDeadlyLunge, getDeadlyLungeTextColor)
    evaluate(getWtJaggedSlice, getJaggedSliceTextColor)
    evaluate(getWtDestructiveAttack, getDestructiveAttackTextColor)
    evaluate(getWtFracture, getFractureTextColor)
    evaluate(getWtRapidBlow, getRapidBlowTextColor)
    evaluate(getWtBloodyHarvest, getBloodyHarvestTextColor)
    evaluate(getWtAnimalPounce, geAnimalPounceTextColor)
    evaluateUtility()
end

function onWarriorUnitManaChanged(params)
    if isMe(params.unitId) then
        evaluatePriority()
    end
end

function onWarriorCombatAdvantageChanged()
    getWtCombatAdvantage():SetVal("value", getCombatAdvantage())
    evaluatePriority()
end

local CD_SETTER_MAP = {
    [2] = "Jagged Slice",
    [3] = "Animal Pounce",
    [6] = "Deadly Lunge",
    [29] = "Berserker",
    [30] = "Bloody Harvest"
}

function onWarriorActionPanelElementEffect(params)
    checkAllCDs(CD_SETTER_MAP, params, setCD)
    checkAllCDs(getWarriorUtilityCDMap(), params, setCD)
    evaluatePriority()
end

function getWarriorBuffs()
    return {"Bloody Harvest", "Flaming Blade"}
end

function onWarriorBuffAdded(params)
    if not isMe(params.objectId) then
        return
    end

    checkAllBuffs(getWarriorBuffs(), params, true)
    checkAllBuffs(getWarriorUtilityBuffs(), params, true)
end

function onWarriorBuffRemoved(params)
    if not isMe(params.objectId) then
        return
    end

    checkAllBuffs(getWarriorBuffs(), params, false)
    checkAllBuffs(getWarriorUtilityBuffs(), params, false)
end

function onWarriorEventEquipmentItemEffect(params)
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

function initWarrior()
    setWtCombatAdvantage(createTextView("CombatAdvantage", 40, 500, getCombatAdvantage()))
    setWtDestructiveAttack(createTextView("DestructiveAttack", 40, 425, "1"))
    setWtFracture(createTextView("Fracture", 90, 450, "2"))
    setWtJaggedSlice(createTextView("JaggedSlice", 110, 500, "3"))
    setWtAnimalPounce(createTextView("AnimalPounce", -10, 450, "4"))
    setWtRapidBlow(createTextView("RapidBlow", -10, 550, "6"))
    setWtDeadlyLunge(createTextView("DeadlyLunge", 90, 550, "7"))
    setWtBerserker(createTextView("Berserker", -10, 650, "s6"))
    setWtBloodyHarvest(createTextView("BloodyHarvest", 90, 650, "s7"))
    setWtTrinket(createTextView("Trinket", 40, 625, "*"))
    initWarriorUtility()

    setTextColor(getWtTrinket(), COLOR_TRINKET)

    evaluatePriority()
end