function getAdrenalineSurgeTextColor()
    if hasAdrenalineSurgeBuff() or hasTurtleBuff() then
        return nil
    end

    if getEnergy() < 25 or isAdrenalineSurgeOnCooldown() then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getTurtleTextColor()
    if hasAdrenalineSurgeBuff() or hasTurtleBuff() then
        return nil
    end

    if getEnergy() < 25 or isTurtleOnCooldown() then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function evaluateUtility()
    evaluate(getWtTurtle, getTurtleTextColor)
    evaluate(getWtAdrenalineSurge, getAdrenalineSurgeTextColor)
end

function initWarriorUtility()
    setWtTurtle(createTextView("Turtle", -175, 485, "^"))
    setWtAdrenalineSurge(createTextView("AdrenalineSurge", -175, 515, "v"))

    evaluateUtility()
end

function onWarriorUtilityBuffAdded(params)
    if userMods.FromWString(params.buffName) == "Turtle" then
        setTurtleBuffId(params.buffId)
        evaluateUtility()
    elseif userMods.FromWString(params.buffName) == "Adrenaline Surge" then
        setAdrenalineSurgeBuffId(params.buffId)
        evaluateUtility()
    end
end

function onWarriorUtilityBuffRemoved(params)
    if userMods.FromWString(params.buffName) == "Turtle" then
        setTurtleBuffId(nil)
        evaluateUtility()
    elseif userMods.FromWString(params.buffName) == "Adrenaline Surge" then
        setAdrenalineSurgeBuffId(nil)
        evaluateUtility()
    end
end

local CD_SETTER_MAP = {
    [37] = setTurtleCooldown,
    [38] = setAdrenalineSurgeCooldown,
}

function onWarriorUtilityActionPanelElementEffect(params)
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

    evaluateUtility()
end