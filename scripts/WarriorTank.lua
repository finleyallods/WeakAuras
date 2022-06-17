local SECOND = 1000

local ENERGY_DESTRUCTIVE_ATTACK = 40
local ENERGY_FRACTURE = 25

local FLAMING_BLADE = "Flaming Blade"
local DESTRUCTIVE_ATTACK = "Destructive Attack"
local FRACTURE = "Fracture"
local TRAMP = "Tramp"
local VICIOUS_SPIN = "Vicious Spin"
local RAPID_BLOW = "Rapid Blow"
local DEADLY_LUNGE = "Deadly Lunge"
local BERSERKER = "Berserker"
local BLOODY_HARVEST = "Bloody Harvest"
local TITANS_RAGE = "Titan’s Rage"

function getRapidBlowTextColorAsTank()
    if shouldTramp() or shouldBuildCombatAdvantage() then
        return COLOR_NONE
    end

    if hasBuff(TITANS_RAGE) then
        return COLOR_GOOD
    end

    if hasBuff(BLOODY_HARVEST) and can(DEADLY_LUNGE) then
        return COLOR_NONE
    end

    if can(BLOODY_HARVEST) then
        return COLOR_SECOND
    end

    return avatar.GetWarriorCombatAdvantage() >= 20 and COLOR_NORMAL or COLOR_IMPOSSIBLE
end

function getDeadlyLungeTextColorAsTank()
    if isOnCd(DEADLY_LUNGE) then
        return COLOR_NONE
    end

    if shouldTramp() or shouldBuildCombatAdvantage() or hasBuff(TITANS_RAGE) then
        return COLOR_NONE
    end
    return avatar.GetWarriorCombatAdvantage() >= 25 and COLOR_NORMAL or COLOR_IMPOSSIBLE
end

function getBloodyHarvestTextColorAsTank()
    if isOnCd(BLOODY_HARVEST) then
        return getMsOnCd(BLOODY_HARVEST) < 3 * SECOND and COLOR_NORMAL or COLOR_NONE
    end

    if avatar.GetWarriorCombatAdvantage() < 30 then
        return COLOR_IMPOSSIBLE
    end

    if getMsOnCd(TRAMP) < 7000 then
        return COLOR_GOOD
    end

    return COLOR_BAD
end

function getViciousSpinTextColor()
    if isOnCd(VICIOUS_SPIN) then
        return COLOR_NONE
    end

    if getEnergy() < 47 then
        return hasBuff(TITANS_RAGE) and COLOR_IMPOSSIBLE or COLOR_NONE
    end

    return hasBuff(TITANS_RAGE) and COLOR_AOE or COLOR_BAD
end

function getTrampTextColor()
    if hasBuff(TITANS_RAGE) then
        return COLOR_BUFF
    end

    if isOnCd(TRAMP) then
        return COLOR_NONE
    end

    local bloodyHarvest = can(BLOODY_HARVEST) or hasBuff(BLOODY_HARVEST)

    if avatar.GetWarriorCombatAdvantage() < 55 then
        return bloodyHarvest and COLOR_IMPOSSIBLE or COLOR_NONE
    end

    if can(BLOODY_HARVEST) then
        return COLOR_SECOND
    end

    return hasBuff(BLOODY_HARVEST) and COLOR_GOOD or COLOR_BAD
end

function shouldTramp()
    return hasBuff(BLOODY_HARVEST) and can(TRAMP) and avatar.GetWarriorCombatAdvantage() >= 55
end

function getCombatAdvantageBuilderAsTank()
    if hasBuff(FLAMING_BLADE) and getEnergy() >= ENERGY_FRACTURE then
        return FRACTURE
    end

    if not hasBuff(FLAMING_BLADE) and getEnergy() >= ENERGY_DESTRUCTIVE_ATTACK then
        return DESTRUCTIVE_ATTACK
    end

    return nil
end

function shouldBuildCombatAdvantageAsTank()
    if not getCombatAdvantageBuilderAsTank() or shouldTramp() then
        return false
    end

    if getMsOnCd(TRAMP) < 2 * SECOND and hasBuff(BLOODY_HARVEST) and avatar.GetWarriorCombatAdvantage() < 55 then
        return true
    end

    if getMsOnCd(TRAMP) < SECOND and hasBuff(BLOODY_HARVEST) and avatar.GetWarriorCombatAdvantage() < 68 and not hasBuff(FLAMING_BLADE) then
        return true
    end

    if not hasBuff(TITANS_RAGE) and can(DEADLY_LUNGE) and avatar.GetWarriorCombatAdvantage() >= 25 then
        return false
    end

    if avatar.GetWarriorCombatAdvantage() < 55 then
        return true
    end

    if hasBuff(BLOODY_HARVEST) then
        return false
    end

    if not hasBuff(FLAMING_BLADE) then
        return avatar.GetWarriorCombatAdvantage() <= 68
    end

    return avatar.GetWarriorCombatAdvantage() <= 83
end

local lastBloodyHarvestText
local lastTrampText

function evaluateWarriorTankPriority()
    local priority = {
        [DESTRUCTIVE_ATTACK] = COLOR_NONE,
        [FRACTURE] = COLOR_NONE,
    }

    if shouldBuildCombatAdvantageAsTank() then
        priority[getCombatAdvantageBuilderAsTank()] = COLOR_NORMAL
    end

    priority[DEADLY_LUNGE] = getDeadlyLungeTextColorAsTank()
    priority[RAPID_BLOW] = getRapidBlowTextColorAsTank()
    priority[BLOODY_HARVEST] = getBloodyHarvestTextColorAsTank()
    priority[BERSERKER] = getBerserkerTextColor()
    priority[TRAMP] = getTrampTextColor()
    priority[VICIOUS_SPIN] = getViciousSpinTextColor()

    local trampText
    local bloodyHarvestText

    if hasBuff(TITANS_RAGE) then
        trampText = "(" .. math.round(getMsOnBuff(TITANS_RAGE) / SECOND) .. ")"
    else
        trampText = "3"
    end

    if trampText == "3" and lastTrampText ~= "3" then
        getWidgetByName(TRAMP):SetTextScale(1)
    end

    if trampText ~= "3" and lastTrampText == "3" then
        getWidgetByName(TRAMP):SetTextScale(0.75)
    end

    if trampText ~= lastTrampText then
        lastTrampText = trampText
        getWidgetByName(TRAMP):SetVal("value", trampText)

    end

    if isOnCd(BLOODY_HARVEST) and getMsOnCd(BLOODY_HARVEST) < 3 * SECOND then
        bloodyHarvestText = "-" .. math.round(getMsOnCd(BLOODY_HARVEST) / SECOND) .. "-"
    else
        bloodyHarvestText = "s7"
    end

    if bloodyHarvestText == "s7" and lastBloodyHarvestText ~= "s7" then
        getWidgetByName(BLOODY_HARVEST):SetTextScale(1)
    end

    if bloodyHarvestText ~= "s7" and lastBloodyHarvestText == "s7" then
        getWidgetByName(BLOODY_HARVEST):SetTextScale(0.75)
    end

    if bloodyHarvestText ~= lastBloodyHarvestText then
        lastBloodyHarvestText = bloodyHarvestText
        getWidgetByName(BLOODY_HARVEST):SetVal("value", bloodyHarvestText)

    end

    displaySkills(priority)

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
    [2] = TRAMP,
    [4] = VICIOUS_SPIN,
    [6] = DEADLY_LUNGE,
    [29] = BERSERKER,
    [30] = BLOODY_HARVEST
}

local currentCds = {}

function onWarriorTankActionPanelElementEffect(params)
    if params.effect < 1 or params.effect > 2 then
        return
    end

    if params.effect == 1 then
        if params.duration < 1500 or currentCds[params.index] == true then
            return
        end
        currentCds[params.index] = true
    end

    if params.effect == 2 then
        if not currentCds[params.index] or currentCds[params.index] == false then
            return
        end
        currentCds[params.index] = false
    end
    checkAllCDs(CD_SETTER_MAP, params)
    checkAllCDs(getWarriorUtilityCDMap(), params)
    evaluateWarriorTankPriority()
end

function getWarriorTankBuffs()
    return { BLOODY_HARVEST, FLAMING_BLADE, TITANS_RAGE }
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

local lastHp = 100

function onWarriorTankEventUnitHealthChanged()
    local hp = object.GetHealthInfo(avatar.GetId()).valuePercents
    local widget = getWidgetByName("Health")
    local color

    if hp >= 80 then
        color = COLOR_NORMAL
    elseif hp >= 40 then
        color = COLOR_SECOND
    elseif hp >= 20 then
        color = COLOR_BAD
    else
        color = COLOR_IMPOSSIBLE
    end

    if hp ~= lastHp then
        widget:SetVal("value", "["..tostring(hp).."]")
        setTextColor(widget, color)
    end
end

local lastStagger = 0

function onWarriorTankEventAvatarWarriorDamagePoolChanged(params)
    local stagger = math.round(params.value / SECOND)
    local widget = getWidgetByName("Damage Pool")
    local color

    if stagger < 100 then
        color = COLOR_NORMAL
    elseif stagger < 250 then
        color = COLOR_SECOND
    elseif stagger < 500 then
        color = COLOR_BAD
    else
        color = COLOR_IMPOSSIBLE
    end

    if stagger ~= lastStagger then
        widget:SetVal("value", tostring(stagger))
        setTextColor(widget, color)
    end
end

function onWarriorTankEventSecondTimer()
    evaluateWarriorTankPriority()
    onWarriorTankEventUnitHealthChanged()
end

function initWarriorTank()
    addWidgetToList(createTextView("Combat Advantage", 40, 500, getCombatAdvantage()))
    addWidgetToList(createTextView(DESTRUCTIVE_ATTACK, 40, 425, "1"))
    addWidgetToList(createTextView(FRACTURE, 90, 450, "2"))
    addWidgetToList(createTextView(TRAMP, 110, 500, "3"))
    addWidgetToList(createTextView(VICIOUS_SPIN, -30, 500, "#"))
    addWidgetToList(createTextView(RAPID_BLOW, -10, 550, "6"))
    addWidgetToList(createTextView(DEADLY_LUNGE, 90, 550, "7"))
    addWidgetToList(createTextView(BERSERKER, -10, 650, "s6"))
    addWidgetToList(createTextView(BLOODY_HARVEST, 90, 650, "s7"))
    addWidgetToList(createTextView("Trinket", 40, 625, "*"))
    addWidgetToList(createTextView("Health", -200, 425, "[100]"))
    addWidgetToList(createTextView("Damage Pool", 275, 525, "0"))
    getWidgetByName("Damage Pool"):SetTextScale(0.75)

    initWarriorUtility(true)

    setTextColor(getWidgetByName("Trinket"), COLOR_TRINKET)

    evaluateWarriorTankPriority()
end