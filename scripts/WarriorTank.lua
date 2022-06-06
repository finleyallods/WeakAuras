function getWarriorTankViciousSpinTextColor()
    if isViciousSpinOnCooldown() then
        return nil
    end

    if getEnergy() < 47 then
        return nil
    end

    return COLOR_AOE
end

function getWarriorTankDeadlyLungeTextColor()
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

function getWarriorTankBloodyHarvestTextColor()
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

function getWarriorTankTrampTextColor()
    if isTrampOnCooldown() then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() < 55 then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getWarriorTankDestructiveAttackTextColor()
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

function getWarriorTankFractureTextColor()
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

function getWarriorTankRapidBlowTextColor()
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

function evaluateWarriorTank(widgetGetter, textColorGetter)
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

function evaluateWarriorTankPriority()
    evaluateWarriorTank(getWtDeadlyLunge, getWarriorTankDeadlyLungeTextColor)
    evaluateWarriorTank(getWtTramp, getWarriorTankTrampTextColor)
    evaluateWarriorTank(getWtDestructiveAttack, getWarriorTankDestructiveAttackTextColor)
    evaluateWarriorTank(getWtFracture, getWarriorTankFractureTextColor)
    evaluateWarriorTank(getWtRapidBlow, getWarriorTankRapidBlowTextColor)
    evaluateWarriorTank(getWtBloodyHarvest, getWarriorTankBloodyHarvestTextColor)
    evaluateWarriorTank(getWtViciousSpin, getWarriorTankViciousSpinTextColor)
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
    [2] = setTrampCooldown,
    [4] = setViciousSpinCooldown,
    [6] = setDeadlyLungeCooldown,
    [30] = setBloodyHarvestCooldown
}

function onWarriorTankActionPanelElementEffect(params)
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

    evaluateWarriorTankPriority()
end

function onWarriorTankBuffAdded(params)
    if not isMe(params.objectId) then
        return
    end

    if userMods.FromWString(params.buffName) == "Bloody Harvest" then
        setBloodyHarvestBuff(params.buffId)
        evaluateWarriorTankPriority()
    elseif userMods.FromWString(params.buffName) == "Flaming Blade" then
        setFlamingBladeBuffId(params.buffId)
        evaluateWarriorTankPriority()
    end
end

function onWarriorTankBuffRemoved(params)
    if not isMe(params.objectId) then
        return
    end

    if userMods.FromWString(params.buffName) == "Bloody Harvest" then
        setBloodyHarvestBuff(nil)
        evaluateWarriorTankPriority()
    elseif userMods.FromWString(params.buffName) == "Flaming Blade" then
        setFlamingBladeBuffId(nil)
        evaluateWarriorTankPriority()
    end
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
    setMyId(avatar.GetId())
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