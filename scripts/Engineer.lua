local FRAG_BOMB = "Frag Bomb"
local ACID_BOMB = "Acid Bomb"
local LIGHT_TURRET = "Light Turret"
local CRITICAL_MASS = "Critical Mass"
local ENGINEER_OVERHEATING = "EngineerOverheating"


local CD_SETTER_MAP = {
    [1] = FRAG_BOMB,
    [2] = ACID_BOMB,
    [7] = LIGHT_TURRET,
    [30] = CRITICAL_MASS
}

function showIfCan(skillId)
    return can(skillId) and COLOR_NORMAL or COLOR_NONE
end

function getEngineerPriority()
    local priority = {}

    priority[FRAG_BOMB] = showIfCan(FRAG_BOMB)
    priority[ACID_BOMB] = showIfCan(ACID_BOMB)
    priority[LIGHT_TURRET] = showIfCan(LIGHT_TURRET)
    priority[CRITICAL_MASS] = showIfCan(CRITICAL_MASS)

    return priority
end

function evaluateEngineerPriority()
    displaySkills(getEngineerPriority())
end

local currentCds = {}

function onEngineerActionPanelElementEffect(params)
    if shouldIgnoreActionPanelElementEffect(currentCds, params) then
        return
    end

    updateCurrentCds(currentCds, params)
    checkAllCDs(CD_SETTER_MAP, params)
    evaluateEngineerPriority()
end

function getTemperature()
    return tostring(avatar.GetVariableInfo(ENGINEER_OVERHEATING).value)
end

function onVariableChangeEngineer(params)
    if params.sysName == ENGINEER_OVERHEATING then
        getWidgetByName(ENGINEER_OVERHEATING):SetVal("value", getTemperature())
    end
end

function initEngineer()
    common.RegisterEventHandler(onVariableChangeEngineer, "EVENT_VARIABLE_VALUE_CHANGED")

    addWidgetToList(createTextView(ENGINEER_OVERHEATING, 30, 500, getTemperature()))
    addWidgetToList(createTextView(FRAG_BOMB, 90, 450, "2"))
    addWidgetToList(createTextView(ACID_BOMB, 110, 500, "3"))
    addWidgetToList(createTextView(LIGHT_TURRET, -60, 400, "Q"))
    addWidgetToList(createTextView(CRITICAL_MASS, 90, 650, "s7"))

    getWidgetByName(ENGINEER_OVERHEATING):SetTextScale(0.75)

    evaluateEngineerPriority()
end