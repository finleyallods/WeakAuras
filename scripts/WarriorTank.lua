function getViciousSpinTextColor()
    if isOnCd("Vicious Spin") then
        return nil
    end

    if getEnergy() < 47 then
        return nil
    end

    return COLOR_AOE
end

function getTrampTextColor()
    if isOnCd("Tramp") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() < 55 then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function evaluateWarriorTankPriority()
    evaluate("Deadly Lunge", getDeadlyLungeTextColor)
    evaluate("Destructive Attack", getDestructiveAttackTextColor)
    evaluate("Fracture", getFractureTextColor)
    evaluate("Rapid Blow", getRapidBlowTextColor)
    evaluate("Bloody Harvest", getBloodyHarvestTextColor)
    evaluate("Berserker", getBerserkerTextColor)
    evaluate("Tramp", getTrampTextColor)
    evaluate("Vicious Spin", getViciousSpinTextColor)
    evaluateUtility()
end

function onWarriorTankUnitManaChanged(params)
    if isMe(params.unitId) then
        evaluateWarriorTankPriority()
    end
end

function onWarriorTankCombatAdvantageChanged()
    getWidgetByName("Combat Advantage"):SetVal("value", getCombatAdvantage())
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
    checkAllCDs(CD_SETTER_MAP, params)
    checkAllCDs(getWarriorUtilityCDMap(), params)
    evaluateWarriorTankPriority()
end

function getWarriorTankBuffs()
    return { "Bloody Harvest", "Flaming Blade" }
end

function onWarriorTankBuffAdded(params)
    if not isMe(params.objectId) then
        return
    end

    checkAllBuffs(getWarriorTankBuffs(), params, true)
    checkAllBuffs(getWarriorUtilityBuffs(), params, true)
    evaluateWarriorTankPriority()
end

function onWarriorTankBuffRemoved(params)
    if not isMe(params.objectId) then
        return
    end

    checkAllBuffs(getWarriorTankBuffs(), params, false)
    checkAllBuffs(getWarriorUtilityBuffs(), params, false)
    evaluateWarriorTankPriority()
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
    getWidgetByName("Trinket"):Show(activate)
end

function onEventUnitHealthChanged(params)
    if not isMe(params.target) then
        return
    end
    local hp = object.GetHealthInfo(params.target).valuePercents

    getWidgetByName("Health"):SetVal("value", tostring(hp))
end

function onEventAvatarWarriorDamagePoolChanged(params)
    getWidgetByName("Damage Pool"):SetVal("value", tostring(math.round(params.value / 1000)))
end

function initWarriorTank()
    addWidgetToList(createTextView("Combat Advantage", 40, 500, getCombatAdvantage()))
    addWidgetToList(createTextView("Destructive Attack", 40, 425, "1"))
    addWidgetToList(createTextView("Fracture", 90, 450, "2"))
    addWidgetToList(createTextView("Tramp", 110, 500, "3"))
    addWidgetToList(createTextView("Vicious Spin", -30, 500, "#"))
    addWidgetToList(createTextView("Rapid Blow", -10, 550, "6"))
    addWidgetToList(createTextView("Deadly Lunge", 90, 550, "7"))
    addWidgetToList(createTextView("Berserker", -10, 650, "s6"))
    addWidgetToList(createTextView("Bloody Harvest", 90, 650, "s7"))
    addWidgetToList(createTextView("Trinket", 40, 625, "*"))
    addWidgetToList(createTextView("Health", -200, 700, "100"))
    addWidgetToList(createTextView("Damage Pool", -110, 545, "0"))
    getWidgetByName("Damage Pool"):SetTextScale(0.75)

    common.RegisterEventHandler(onEventAvatarWarriorDamagePoolChanged, "EVENT_AVATAR_WARRIOR_DAMAGE_POOL_CHANGED")
    common.RegisterEventHandler(onEventUnitHealthChanged, "EVENT_UNIT_DAMAGE_RECEIVED")
    common.RegisterEventHandler(onEventUnitHealthChanged, "EVENT_HEALING_RECEIVED")

    initWarriorUtility(true)

    setTextColor(getWidgetByName("Trinket"), COLOR_TRINKET)

    evaluateWarriorTankPriority()
end