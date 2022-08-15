local SECOND = 1000
local isTank

local TURTLE = "Turtle"
local ADRENALINE_SURGE = "Adrenaline Surge"
local CHARGE = "Charge"
local MAD_LEAP = "Mad Leap"
local MIGHTY_LEAP = "Mighty Leap"
local AIMED_SHOT = "Aimed Shot"
local BREAK = "Break"
local DELIVERANCE = "Deliverance"
local HARPOON = "Harpoon"
local DEEP_DEFENSE = "Deep Defense"
local DAMAGE_REDUCTION = "Damage Reduction"
local CHALLENGE = "Challenge"
local GLINT = "Glint"
local KICK = "Kick"
local HACK = "Hack"
local SLUGGISHNESS = "Sluggishness"

function getAdrenalineSurgeTextColor()
    if hasBuff(ADRENALINE_SURGE) or hasBuff(TURTLE) or hasBuff(DEEP_DEFENSE) then
        return COLOR_NONE
    end

    if getEnergy() < 25 or isOnCd(ADRENALINE_SURGE) then
        return COLOR_IMPOSSIBLE
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

    return COLOR_NORMAL
end

function getDeepDefenceTextColor()
    if hasBuff(ADRENALINE_SURGE) or hasBuff(TURTLE) or hasBuff(DEEP_DEFENSE) then
        return COLOR_NONE
    end

    return isOnCd(DEEP_DEFENSE) and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function getChargeTextColor()
    if getEnergy() == 100  and can(CHARGE) then
        return COLOR_GOOD
    end

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

function getAimedShotTextColor()
    if getEnergy() < 25 or isOnCd(AIMED_SHOT) then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getBreakTextColor()
    return isOnCd(BREAK) and COLOR_NONE or COLOR_NORMAL
end

function getDeliveranceTextColor()
    if getEnergy() < 21 then
        return COLOR_IMPOSSIBLE
    end

    return isOnCd(DELIVERANCE) and COLOR_NONE or COLOR_NORMAL
end

function getHarpoonTextColor()
    return isOnCd(HARPOON) and COLOR_NONE or COLOR_NORMAL
end

function getGlintTextColor()
    return isOnCd(GLINT) and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function getChallengeTextColor()
    return isOnCd(CHALLENGE) and COLOR_IMPOSSIBLE or COLOR_NORMAL
end

function getKickTextColor()
    if isOnCd(KICK) then
        return COLOR_NONE
    end

    if avatar.GetWarriorCombatAdvantage() < 15 then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_NORMAL
end

function getHackTextColor()
    if getMsOnUnitBuffed(avatar.GetTarget(), SLUGGISHNESS) > 1000 then
        return COLOR_NONE
    end

    if getMsOnUnitBuffed(avatar.GetTarget(), SLUGGISHNESS) > 100 then
        return COLOR_NORMAL
    end

    if isOnCd(HACK) or getEnergy() < 26 then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_GOOD
end

local damageReductionText = ""
local lastDamageReductionText = ""
function updateDamageReduction()
    if hasBuff(ADRENALINE_SURGE) then
        damageReductionText = "(" .. math.round(getMsOnBuff(ADRENALINE_SURGE) / SECOND) .. ")"
    elseif hasBuff(TURTLE) then
        damageReductionText = "(" .. math.round(getMsOnBuff(TURTLE) / SECOND) .. ")"
    elseif hasBuff(DEEP_DEFENSE) then
        damageReductionText = "(" .. math.round(getMsOnBuff(DEEP_DEFENSE) / SECOND) .. ")"
    else
        damageReductionText = ""
    end

    if damageReductionText ~= lastDamageReductionText then
        lastDamageReductionText = damageReductionText
        getWidgetByName(DAMAGE_REDUCTION):SetVal("value", damageReductionText)
    end
end

function evaluateUtility()
    local utility = {}

    utility[TURTLE] = getTurtleTextColor()
    utility[ADRENALINE_SURGE] = getAdrenalineSurgeTextColor()
    utility[CHARGE] = getChargeTextColor()
    utility[MAD_LEAP] = getMadLeapTextColor()
    utility[MIGHTY_LEAP] = getMightyLeapTextColor()
    utility[AIMED_SHOT] = getAimedShotTextColor()
    utility[GLINT] = getGlintTextColor()
    utility[KICK] = getKickTextColor()
    utility[HARPOON] = getHarpoonTextColor()
    utility[DEEP_DEFENSE] = getDeepDefenceTextColor()
    utility[CHALLENGE] = getChallengeTextColor()

    if isTank then
        utility[BREAK] = getBreakTextColor()
        utility[DELIVERANCE] = getDeliveranceTextColor()
        updateDamageReduction()
    else
        utility[HACK] = getHackTextColor()
    end

    displaySkills(utility)
end

function initWarriorUtility(initTank)
    isTank = initTank
    addWidgetToList(createTextView(TURTLE, 260, 440, "^"))
    addWidgetToList(createTextView(ADRENALINE_SURGE, 260, 470, "v"))
    addWidgetToList(createTextView(CHARGE, -225, 525, "Q"))
    addWidgetToList(createTextView(MAD_LEAP, -210, 550, "sQ"))
    addWidgetToList(createTextView(MIGHTY_LEAP, -175, 525, "R"))
    addWidgetToList(createTextView(AIMED_SHOT, -210, 500, "s4"))
    addWidgetToList(createTextView(GLINT, -160, 550, "sR"))
    addWidgetToList(createTextView(HARPOON, 210, 450, "G"))
    addWidgetToList(createTextView(CHALLENGE, -210, 625, "sF"))
    addWidgetToList(createTextView(DEEP_DEFENSE, 250, 450, "+"))

    getWidgetByName(CHARGE):SetTextScale(0.75)
    getWidgetByName(MAD_LEAP):SetTextScale(0.65)
    getWidgetByName(MIGHTY_LEAP):SetTextScale(0.75)
    getWidgetByName(AIMED_SHOT):SetTextScale(0.65)
    getWidgetByName(GLINT):SetTextScale(0.65)
    getWidgetByName(DEEP_DEFENSE):SetTextScale(0.75)
    getWidgetByName(CHALLENGE):SetTextScale(0.65)

    if isTank then
        addWidgetToList(createTextView(BREAK, 240, 550, "E"))
        addWidgetToList(createTextView(KICK, -225, 600, "F"))
        addWidgetToList(createTextView(DELIVERANCE, 255, 575, "sE"))
        addWidgetToList(createTextView(DAMAGE_REDUCTION, 250, 450, ""))

        getWidgetByName(BREAK):SetTextScale(0.75)
        getWidgetByName(DELIVERANCE):SetTextScale(0.65)
        getWidgetByName(KICK):SetTextScale(0.75)

        setTextColor(getWidgetByName(DAMAGE_REDUCTION), COLOR_BUFF)
    else
        addWidgetToList(createTextView(HACK, 160, 425, "E"))
        addWidgetToList(createTextView(KICK, 185, 450, "F"))
    end
end

function getWarriorUtilityBuffs()
    return { TURTLE, ADRENALINE_SURGE, DEEP_DEFENSE }
end

function getWarriorUtilityCDMap()
    local cdMap = {
        [7] = CHARGE,
        [9] = MIGHTY_LEAP,
        [10] = KICK,
        [11] = HARPOON,
        [15] = AIMED_SHOT,
        [19] = MAD_LEAP,
        [21] = GLINT,
        [22] = CHALLENGE,
        [37] = TURTLE,
        [38] = ADRENALINE_SURGE,
        [43] = DEEP_DEFENSE
    }

    if isTank then
        cdMap[8] = BREAK
        cdMap[20] = DELIVERANCE
    else
        cdMap[8] = HACK
    end

    return cdMap
end
