function getAdrenalineSurgeTextColor()
    if hasBuff("Adrenaline Surge") or hasBuff("Turtle") then
        return nil
    end

    if getEnergy() < 25 or isOnCd("Adrenaline Surge") then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getTurtleTextColor()
    if hasBuff("Adrenaline Surge") or hasBuff("Turtle") then
        return nil
    end

    if getEnergy() < 25 or isOnCd("Turtle") then
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
end

function getWarriorUtilityBuffs()
    return {"Turtle", "Adrenaline Surge"}
end

function getWarriorUtilityCDMap()
    return {
        [37] = "Turtle",
        [38] = "Adrenaline Surge",
    }
end

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
end