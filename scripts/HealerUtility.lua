local SECOND = 1000

local PLEADING = "Pleading"
local PROTECTIVE_SIGN = "Protective Sign"
local ARMOR_OF_LIGHT = "Armor of Light"
local TALISMAN = "Talisman"
local TONIC = "Tonic"
local HEALING_PRAYER = "Healing Prayer"
local GUARDING_WORD = "Guarding Word"
local DIVINE_FORESIGHT = "Divine Foresight"
local DEFENSE = "Defense"
local DAZZLING = "Dazzling"
local AVENGING_STRIKE = "Avenging Strike"


function getStandardTextColor(skillName)
    return isOnCd(skillName) and COLOR_NONE or COLOR_NORMAL
end

function evaluateHealerUtility()
    local utility = {}

    for _, skillName in pairs(getHealerUtilityCDMap()) do
        utility[skillName] = getStandardTextColor(skillName)
    end

    displaySkills(utility)
end

function initHealerUtility()
    addWidgetToList(createTextView(PLEADING, 240, 550, "E"))
    addWidgetToList(createTextView(HEALING_PRAYER, 255, 575, "sE"))
    addWidgetToList(createTextView(PROTECTIVE_SIGN, 260, 440, "^"))
    addWidgetToList(createTextView(ARMOR_OF_LIGHT, 260, 470, "v"))
    addWidgetToList(createTextView(TONIC, 243, 452, "O"))
    addWidgetToList(createTextView(TALISMAN, 260, 450, "+"))
    addWidgetToList(createTextView(GUARDING_WORD, 35, 620, "o"))
    addWidgetToList(createTextView(DIVINE_FORESIGHT, 240, 650, "C"))
    addWidgetToList(createTextView(DEFENSE, 260, 650, "V"))
    addWidgetToList(createTextView(DAZZLING, -225, 600, "F"))
    addWidgetToList(createTextView(AVENGING_STRIKE, -175, 600, "G"))

    getWidgetByName(TONIC):SetTextScale(0.6)
    getWidgetByName(PLEADING):SetTextScale(0.75)
    getWidgetByName(HEALING_PRAYER):SetTextScale(0.65)
    getWidgetByName(GUARDING_WORD):SetTextScale(0.65)
    getWidgetByName(DIVINE_FORESIGHT):SetTextScale(0.75)
    getWidgetByName(DEFENSE):SetTextScale(0.75)
    getWidgetByName(DAZZLING):SetTextScale(0.75)
    getWidgetByName(AVENGING_STRIKE):SetTextScale(0.75)
end

function getHealerUtilityCDMap()
    local cdMap = {
        [8] = PLEADING,
        [10] = DAZZLING,
        [11] = AVENGING_STRIKE,
        [20] = HEALING_PRAYER,
        [37] = PROTECTIVE_SIGN,
        [38] = ARMOR_OF_LIGHT,
        [43] = TALISMAN,
        [44] = TONIC,
        [48] = DIVINE_FORESIGHT,
        [49] = DEFENSE,
    }

    return cdMap
end