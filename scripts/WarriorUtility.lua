local isTank

local TURTLE = "Turtle"
local ADRENALINE_SURGE = "Adrenaline Surge"
local CHARGE = "Charge"
local MAD_LEAP = "Mad Leap"
local MIGHTY_LEAP = "Mighty Leap"
local AIMED_SHOT = "Aimed Shot"
local MARTYRS_GUIDANCE = "Martyr's Guidance"
local BREAK = "Break"
local DELIVERANCE = "Deliverance"
local HARPOON = "Harpoon"
local DEEP_DEFENSE = "Deep Defense"
local BLOODY_HARVEST = "Bloody Harvest"

function getAdrenalineSurgeTextColor()
    if hasBuff(ADRENALINE_SURGE) or hasBuff(TURTLE) or hasBuff(DEEP_DEFENSE) then
        return COLOR_NONE
    end

    if getEnergy() < 25 or isOnCd(ADRENALINE_SURGE) then
        return COLOR_IMPOSSIBLE
    end

    if not hasBuff(BLOODY_HARVEST) then
        return COLOR_GOOD
    end

    return COLOR_NORMAL
end

function getTurtleTextColor()
    if hasBuff(ADRENALINE_SURGE) or hasBuff(TURTLE) or hasBuff(DEEP_DEFENSE) then
        return COLOR_NONE
    end

    if getEnergy() < 25 or isOnCd(TURTLE) then
        return COLOR_IMPOSSIBLE
    end

    if not hasBuff(BLOODY_HARVEST) then
        return COLOR_GOOD
    end

    return COLOR_NORMAL
end

function getDeepDefenceTextColor()
    if hasBuff(ADRENALINE_SURGE) or hasBuff(TURTLE) or hasBuff(DEEP_DEFENSE) then
        return COLOR_NONE
    end

    if isOnCd(DEEP_DEFENSE) then
        return COLOR_IMPOSSIBLE
    end

    if not hasBuff(BLOODY_HARVEST) then
        return COLOR_GOOD
    end

    return isOnCd(DEEP_DEFENSE) and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function getChargeTextColor()
    if getEnergy() < 23 or isOnCd(CHARGE) then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getMadLeapTextColor()
    return isOnCd(MAD_LEAP) and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function getMightyLeapTextColor()
    if getEnergy() < 23 or isOnCd(MIGHTY_LEAP) then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getMartyrsGuidanceTextColor()
    if isOnCd(MARTYRS_GUIDANCE) then
        return COLOR_NONE
    end

    if  avatar.GetWarriorCombatAdvantage() <= 70 and getEnergy() <= 70 then
        return COLOR_GOOD
    end

    return COLOR_BAD
end

function getAimedShotTextColor()
    if getEnergy() < 25 or isOnCd(AIMED_SHOT) then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getBreakTextColor()
    return isOnCd(BREAK) and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function getDeliveranceTextColor()
    if getEnergy() < 21 or isOnCd(DELIVERANCE) then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getHarpoonTextColor()
    return isOnCd(HARPOON) and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function evaluateUtility()
    local utility = {}

    utility[TURTLE] = getTurtleTextColor()
    utility[ADRENALINE_SURGE] = getAdrenalineSurgeTextColor()
    utility[CHARGE] = getChargeTextColor()
    utility[MAD_LEAP] = getMadLeapTextColor()
    utility[MIGHTY_LEAP] = getMightyLeapTextColor()
    utility[AIMED_SHOT] = getAimedShotTextColor()
    utility[MARTYRS_GUIDANCE] = getMartyrsGuidanceTextColor()


    if isTank then
        utility[BREAK] = getBreakTextColor()
        utility[DELIVERANCE] = getDeliveranceTextColor()
        utility[HARPOON] = getHarpoonTextColor()
        utility[DEEP_DEFENSE] = getDeepDefenceTextColor()
    end

    displaySkills(utility)
end

function initWarriorUtility(initTank)
    isTank = initTank
    addWidgetToList(createTextView(TURTLE, -175, 485, "^"))
    addWidgetToList(createTextView(ADRENALINE_SURGE, -175, 515, "v"))
    addWidgetToList(createTextView(CHARGE, -300, 550, "Q"))
    addWidgetToList(createTextView(MAD_LEAP, -285, 575, "sQ"))
    addWidgetToList(createTextView(MIGHTY_LEAP, -250, 550, "R"))
    addWidgetToList(createTextView(AIMED_SHOT, -285, 525, "s4"))
    addWidgetToList(createTextView(MARTYRS_GUIDANCE, 50, 625, "s2"))

    getWidgetByName(CHARGE):SetTextScale(0.75)
    getWidgetByName(MAD_LEAP):SetTextScale(0.65)
    getWidgetByName(MIGHTY_LEAP):SetTextScale(0.75)
    getWidgetByName(AIMED_SHOT):SetTextScale(0.65)
    getWidgetByName(MARTYRS_GUIDANCE):SetTextScale(0.65)

    if isTank then
        addWidgetToList(createTextView(BREAK, -140, 550, "E"))
        addWidgetToList(createTextView(DELIVERANCE, -125, 575, "sE"))
        addWidgetToList(createTextView(HARPOON, -225, 575, "G"))
        addWidgetToList(createTextView(DEEP_DEFENSE, -185, 490, "+"))

        getWidgetByName(BREAK):SetTextScale(0.75)
        getWidgetByName(DELIVERANCE):SetTextScale(0.65)
        getWidgetByName(HARPOON):SetTextScale(0.75)
        getWidgetByName(DEEP_DEFENSE):SetTextScale(0.75)
    end
end

function getWarriorUtilityBuffs()
    return { TURTLE, ADRENALINE_SURGE, DEEP_DEFENSE }
end

function getWarriorUtilityCDMap()
    local cdMap = {
        [37] = TURTLE,
        [38] = ADRENALINE_SURGE,
        [7] = CHARGE,
        [9] = MIGHTY_LEAP,
        [27] = AIMED_SHOT,
        [25] = MARTYRS_GUIDANCE,
        [31] = MAD_LEAP,
    }
    if isTank then
        cdMap[8] = BREAK
        cdMap[32]= DELIVERANCE
        cdMap[10] = HARPOON
        cdMap[49] = DEEP_DEFENSE
    end

    return cdMap
end
