local FLAMING_BLADE = "Flaming Blade"
local DESTRUCTIVE_ATTACK = "Destructive Attack"
local FRACTURE = "Fracture"
local JAGGED_SLICE = "Jagged Slice"
local TREACHEROUS_STRIKE = "Treacherous Strike"
local DEADLY_LUNGE = "Deadly Lunge"
local BERSERKER = "Berserker"
local BLOODY_HARVEST = "Bloody Harvest"

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
    [2] = JAGGED_SLICE,
    [5] = TREACHEROUS_STRIKE,
    [6] = DEADLY_LUNGE,
    [17] = BERSERKER,
    [18] = BLOODY_HARVEST
}

local currentCds = {}

function onWarriorActionPanelElementEffect(params)
    if shouldIgnoreActionPanelElementEffect(currentCds, params) then
        return
    end

    updateCurrentCds(currentCds, params)
    checkAllCDs(CD_SETTER_MAP, params)
    checkAllCDs(getWarriorUtilityCDMap(), params)
    evaluateWarriorPriority()
end

function getWarriorBuffs()
    return { BLOODY_HARVEST, FLAMING_BLADE }
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

function initWarrior()
    addWidgetToList(createTextView("Combat Advantage", 40, 500, getCombatAdvantage()))
    addWidgetToList(createTextView(DESTRUCTIVE_ATTACK, 40, 425, "1"))
    addWidgetToList(createTextView(FRACTURE, 90, 450, "2"))
    addWidgetToList(createTextView(JAGGED_SLICE, 110, 500, "3"))
    addWidgetToList(createTextView(TREACHEROUS_STRIKE, -10, 550, "6"))
    addWidgetToList(createTextView(DEADLY_LUNGE, 90, 550, "7"))
    addWidgetToList(createTextView(BERSERKER, -10, 650, "s6"))
    addWidgetToList(createTextView(BLOODY_HARVEST, 90, 650, "s7"))

    initWarriorUtility(false)

    evaluateWarriorPriority()
end