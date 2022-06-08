local isTank

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
    if getEnergy() < 23 or isOnCd("Charge") then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getMadLeapTextColor()
    return isOnCd("Mad Leap") and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function getMightyLeapTextColor()
    if getEnergy() < 23 or isOnCd("Mighty Leap") then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getMartyrsGuidanceTextColor()
    if isOnCd("Martyr's Guidance") then
        return nil
    end

    if  avatar.GetWarriorCombatAdvantage() <= 70 and getEnergy() <= 70 then
        return COLOR_GOOD
    end

    return COLOR_BAD
end

function getAimedShotTextColor()
    if getEnergy() < 25 or isOnCd("Aimed Shot") then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getBreakTextColor()
    return isOnCd("Break") and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function getDeliveranceTextColor()
    if getEnergy() < 21 or isOnCd("Deliverance") then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getHarpoonTextColor()
    return isOnCd("Harpoon") and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function evaluateUtility()
    evaluate("Turtle", getTurtleTextColor)
    evaluate("AdrenalineSurge", getAdrenalineSurgeTextColor)
    evaluate("Charge", getChargeTextColor)
    evaluate("Mad Leap", getMadLeapTextColor)
    evaluate("Mighty Leap", getMightyLeapTextColor)
    evaluate("Aimed Shot", getAimedShotTextColor)
    evaluate("Martyr's Guidance", getMartyrsGuidanceTextColor)

    if isTank then
        evaluate("Break", getBreakTextColor)
        evaluate("Deliverance", getDeliveranceTextColor)
        evaluate("Harpoon", getHarpoonTextColor)
    end
end

function initWarriorUtility(initTank)
    isTank = initTank
    addWidgetToList(createTextView("Turtle", -175, 485, "^"))
    addWidgetToList(createTextView("AdrenalineSurge", -175, 515, "v"))
    addWidgetToList(createTextView("Charge", -300, 550, "Q"))
    addWidgetToList(createTextView("Mad Leap", -285, 575, "sQ"))
    addWidgetToList(createTextView("Mighty Leap", -250, 550, "R"))
    addWidgetToList(createTextView("Aimed Shot", -285, 525, "s4"))
    addWidgetToList(createTextView("Martyr's Guidance", 50, 625, "s2"))

    getWidgetByName("Charge"):SetTextScale(0.75)
    getWidgetByName("Mad Leap"):SetTextScale(0.65)
    getWidgetByName("Mighty Leap"):SetTextScale(0.75)
    getWidgetByName("Aimed Shot"):SetTextScale(0.65)
    getWidgetByName("Martyr's Guidance"):SetTextScale(0.65)

    if isTank then
        addWidgetToList(createTextView("Break", -140, 575, "E"))
        addWidgetToList(createTextView("Deliverance", -125, 600, "sE"))
        addWidgetToList(createTextView("Harpoon", -225, 575, "G"))

        getWidgetByName("Break"):SetTextScale(0.75)
        getWidgetByName("Deliverance"):SetTextScale(0.65)
        getWidgetByName("Harpoon"):SetTextScale(0.75)
    end
end

function getWarriorUtilityBuffs()
    return { "Turtle", "Adrenaline Surge" }
end

function getWarriorUtilityCDMap()
    local cdMap = {
        [37] = "Turtle",
        [38] = "Adrenaline Surge",
        [7] = "Charge",
        [9] = "Mighty Leap",
        [27] = "Aimed Shot",
        [25] = "Martyr's Guidance",
        [31] = "Mad Leap",
    }
    if isTank then
        cdMap[8] = "Break"
        cdMap[32]= "Deliverance"
        cdMap[10] = "Harpoon"
    end

    return cdMap
end
