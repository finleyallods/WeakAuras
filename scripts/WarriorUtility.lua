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

function getChargeTextColor()
    return getEnergy() < 23 or isOnCd("Charge") and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function getMadLeapTextColor()
    return isOnCd("Mad Leap") and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function getMightyLeapTextColor()
    return getEnergy() < 23 or isOnCd("Mighty Leap") and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function getAimedShotTextColor()
    return getEnergy() < 25 or isOnCd("Aimed Shot") and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function evaluateUtility()
    evaluate("Turtle", getTurtleTextColor)
    evaluate("AdrenalineSurge", getAdrenalineSurgeTextColor)
    evaluate("Charge", getChargeTextColor)
    evaluate("Mad Leap", getMadLeapTextColor)
    evaluate("Mighty Leap", getMightyLeapTextColor)
    evaluate("Aimed Shot", getAimedShotTextColor)
end

function initWarriorUtility()
    addWidgetToList(createTextView("Turtle", -175, 485, "^"))
    addWidgetToList(createTextView("AdrenalineSurge", -175, 515, "v"))
    addWidgetToList(createTextView("Charge", -300, 550, "Q"))
    addWidgetToList(createTextView("Mad Leap", -285, 575, "sQ"))
    addWidgetToList(createTextView("Mighty Leap", -250, 550, "R"))
    addWidgetToList(createTextView("Aimed Shot", -285, 525, "s4"))

    getWidgetByName("Charge"):SetTextScale(0.75)
    getWidgetByName("Mad Leap"):SetTextScale(0.65)
    getWidgetByName("Mighty Leap"):SetTextScale(0.75)
    getWidgetByName("Aimed Shot"):SetTextScale(0.65)
end

function getWarriorUtilityBuffs()
    return { "Turtle", "Adrenaline Surge" }
end

function getWarriorUtilityCDMap()
    return {
        [37] = "Turtle",
        [38] = "Adrenaline Surge",
        [7] = "Charge",
        [9] = "Mighty Leap",
        [27] = "Aimed Shot",
        [31] = "Mad Leap",
    }
end
