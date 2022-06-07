function onWarriorUnitManaChanged(params)
    if isMe(params.unitId) then
        evaluateWarriorPriority()
    end
end

function onWarriorCombatAdvantageChanged()
    getWidgetByName("Combat Advantage"):SetVal("value", getCombatAdvantage())
    evaluateWarriorPriority()
end

local CD_SETTER_MAP = {
    [2] = "Jagged Slice",
    [3] = "Animal Pounce",
    [6] = "Deadly Lunge",
    [29] = "Berserker",
    [30] = "Bloody Harvest"
}

function onWarriorActionPanelElementEffect(params)
    checkAllCDs(CD_SETTER_MAP, params)
    checkAllCDs(getWarriorUtilityCDMap(), params)
    evaluateWarriorPriority()
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
    evaluateWarriorPriority()
end

function onWarriorBuffRemoved(params)
    if not isMe(params.objectId) then
        return
    end

    checkAllBuffs(getWarriorBuffs(), params, false)
    checkAllBuffs(getWarriorUtilityBuffs(), params, false)
    evaluateWarriorPriority()
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
    getWidgetByName("Trinket"):Show(activate)
end

function initWarrior()
    addWidgetToList(createTextView("Combat Advantage", 40, 500, getCombatAdvantage()))
    addWidgetToList(createTextView("Destructive Attack", 40, 425, "1"))
    addWidgetToList(createTextView("Fracture", 90, 450, "2"))
    addWidgetToList(createTextView("Jagged Slice", 110, 500, "3"))
    addWidgetToList(createTextView("Animal Pounce", -10, 450, "4"))
    addWidgetToList(createTextView("Rapid Blow", -10, 550, "6"))
    addWidgetToList(createTextView("Deadly Lunge", 90, 550, "7"))
    addWidgetToList(createTextView("Berserker", -10, 650, "s6"))
    addWidgetToList(createTextView("Bloody Harvest", 90, 650, "s7"))
    addWidgetToList(createTextView("Trinket", 40, 625, "*"))
    initWarriorUtility(false)

    setTextColor(getWidgetByName("Trinket"), COLOR_TRINKET)

    evaluateWarriorPriority()
end