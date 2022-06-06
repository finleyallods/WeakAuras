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

function evaluate(widgetGetter, textColorGetter)
    local widget = widgetGetter and widgetGetter()

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
    evaluate(getWtDeadlyLunge, getDeadlyLungeTextColor)
    evaluate(getWtJaggedSlice, getJaggedSliceTextColor)
    evaluate(getWtDestructiveAttack, getDestructiveAttackTextColor)
    evaluate(getWtFracture, getFractureTextColor)
    evaluate(getWtRapidBlow, getRapidBlowTextColor)
    evaluate(getWtBloodyHarvest, getBloodyHarvestTextColor)
    evaluate(getWtAnimalPounce, geAnimalPounceTextColor)
end

function onWarriorUnitManaChanged(params)
    if isMe(params.unitId) then
        evaluatePriority()
        evaluateUtility()
    end
end

function onWarriorCombatAdvantageChanged()
    getWtCombatAdvantage():SetVal("value", getCombatAdvantage())
    evaluatePriority()
    evaluateUtility()
end

local CD_SETTER_MAP = {
    [2] = setJaggedSliceCooldown,
    [3] = setAnimalPounceCooldown,
    [6] = setDeadlyLungeCooldown,
    [30] = setBloodyHarvestCooldown
}

function onWarriorActionPanelElementEffect(params)
    if params.effect < 1 or params.effect > 2 then
        return
    end

    if params.effect == 1 and params.duration < 1500 then
        return
    end

    local timeStamp = params.effect == 1 and common.GetLocalDateTime() or nil

    for key, value in pairs(CD_SETTER_MAP) do
        if params.index == key then
            value(timeStamp, params.duration)
        end
    end

    if params.index == 29 then
        getWtBerserker():Show(params.effect == 2)
    end

    onWarriorUtilityActionPanelElementEffect(params)
    evaluatePriority()
end

function onWarriorBuffAdded(params)
    if not isMe(params.objectId) then
        return
    end

    if userMods.FromWString(params.buffName) == "Bloody Harvest" then
        setBloodyHarvestBuff(params.buffId)
        evaluatePriority()
    elseif userMods.FromWString(params.buffName) == "Flaming Blade" then
        setFlamingBladeBuffId(params.buffId)
        evaluatePriority()
    else
        onWarriorUtilityBuffAdded(params)
    end
end

function onWarriorBuffRemoved(params)
    if not isMe(params.objectId) then
        return
    end

    if userMods.FromWString(params.buffName) == "Bloody Harvest" then
        setBloodyHarvestBuff(nil)
        evaluatePriority()
    elseif userMods.FromWString(params.buffName) == "Flaming Blade" then
        setFlamingBladeBuffId(nil)
        evaluatePriority()
    else
        onWarriorUtilityBuffRemoved(params)
    end
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
    setMyId(avatar.GetId())
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