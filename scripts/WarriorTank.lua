local ENERGY_DESTRUCTIVE_ATTACK = 40
local ENERGY_FRACTURE = 25

function getDestructiveAttackTextColorAsTank()
    if hasBuff("Flaming Blade") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() > 75 then
        return getEnergy() >= ENERGY_DESTRUCTIVE_ATTACK and COLOR_BAD or COLOR_IMPOSSIBLE
    end

    if not hasBuff("Bloody Harvest") then
        return getEnergy() >= ENERGY_DESTRUCTIVE_ATTACK and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or COLOR_BAD
end

function getFractureTextColorAsTank()
    if not hasBuff("Flaming Blade") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() > 85 then
        return getEnergy() >= ENERGY_FRACTURE and COLOR_BAD or COLOR_IMPOSSIBLE
    end

    if not hasBuff("Bloody Harvest") then
        return getEnergy() >= ENERGY_FRACTURE and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or COLOR_BAD
end

function getRapidBlowTextColorForBurstAsTank()
    if not isOnCd("Deadly Lunge") and not hasBuff("Titan's Rage") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() < 25 then
        return COLOR_IMPOSSIBLE
    end

    if hasBuff("Flaming Blade") and getEnergy() < ENERGY_FRACTURE then
        return COLOR_NORMAL
    end

    if getEnergy() < ENERGY_DESTRUCTIVE_ATTACK then
        return COLOR_NORMAL
    end

    return avatar.GetWarriorCombatAdvantage() >= 45 and COLOR_NORMAL or COLOR_BAD
end

function getRapidBlowTextColorAsTank()
    if not isOnCd("Deadly Lunge") and not isOnCd("Bloody Harvest") and not hasBuff("Titan's Rage") then
        return nil
    end

    if hasBuff("Bloody Harvest") then
        return getRapidBlowTextColorForBurstAsTank()
    end

    if avatar.GetWarriorCombatAdvantage() < 25 then
        return nil
    end

    if hasBuff("Flaming Blade") then
        return getEnergy() < ENERGY_FRACTURE and COLOR_NORMAL or nil
    end

    return getEnergy() < ENERGY_DESTRUCTIVE_ATTACK and COLOR_NORMAL or nil
end

function getDeadlyLungeTextColorAsTank()
    if isOnCd("Deadly Lunge") or hasBuff("Titan's Rage") then
        return nil
    end

    return avatar.GetWarriorCombatAdvantage() >= 25 and COLOR_NORMAL or COLOR_IMPOSSIBLE
end

function getBloodyHarvestTextColorAsTank()
    if isOnCd("Bloody Harvest") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() < 30 then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

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
    evaluate("Deadly Lunge", getDeadlyLungeTextColorAsTank)
    evaluate("Destructive Attack", getDestructiveAttackTextColorAsTank)
    evaluate("Fracture", getFractureTextColorAsTank)
    evaluate("Rapid Blow", getRapidBlowTextColorAsTank)
    evaluate("Bloody Harvest", getBloodyHarvestTextColorAsTank)
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
    return { "Bloody Harvest", "Flaming Blade", "Titan's Rage" }
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