local myId
local heavenlySmiteSpellIndex

Global("wtCleansingFlame", nil)
Global("wtFanaticism", nil)
Global("wtFervidPrayer", nil)
Global("wtFrenzy", nil)
Global("wtHeavenlySmite", nil)

function getFanaticism()
    return tostring(avatar.GetVariableInfo("PriestZeal").value) .. "." .. tostring(avatar.GetVariableInfo("PriestFaith").value)
end

function onVariableChange(params)
    if params.sysName == "PriestZeal" or params.sysName == "PriestFaith" then
        wtFanaticism:SetVal("value", getFanaticism())
    end
end

function isHeavenlySmiteCD()
    return spellLib.GetCooldown(avatar.GetSpellBook()[heavenlySmiteSpellIndex]).durationMs > 1000
end

function onPriestActionPanelElementEffect(params)
    if params.effect == 1 and params.index == 7 then
        wtCleansingFlame:Show(false)
    end
    if params.effect == 2 and params.index == 7 then
        wtCleansingFlame:Show(true)
    end

    if params.effect == 1 and params.index == 18 then
        wtFervidPrayer:Show(false)
    end
    if params.effect == 2 and params.index == 18 then
        wtFervidPrayer:Show(true)
    end

    if params.effect == 1 and params.index == 17 then
        wtFrenzy:Show(false)
    end
    if params.effect == 2 and params.index == 17 then
        wtFrenzy:Show(true)
    end

    if params.effect == 1 and params.index == 5 and isHeavenlySmiteCD() then
        wtHeavenlySmite:Show(false)
    end

    if params.effect == 2 and params.index == 5 and not isHeavenlySmiteCD() then
        wtHeavenlySmite:Show(true)
    end

    checkAllCDs(getHealerUtilityCDMap(), params)
    evaluateHealerUtility()
end

function setHeavenlySmiteSpellIndex()
    for i, id in pairs(avatar.GetSpellBook()) do
        local spellInfo = spellLib.GetDescription(id)
        if userMods.FromWString(spellInfo.name) == "Heavenly Smite" then
            heavenlySmiteSpellIndex = i
            return
        end
    end

    sendMessage("Could not find Heavenly Smite in spell book.")
end

function evaluateHealerPriority()
    evaluateHealerUtility()
end

function initHealer()
    myId = avatar.GetId()
    setHeavenlySmiteSpellIndex()

    common.RegisterEventHandler(onVariableChange, "EVENT_VARIABLE_VALUE_CHANGED")

    wtFanaticism = createTextView("Fanaticism", 40, 500, getFanaticism())
    wtCleansingFlame = createTextView("CleansingFlame", -60, 400, "Q")
    wtHeavenlySmite = createTextView("HeavenlySmite", -10, 550, "6")
    wtFrenzy = createTextView("Frenzy", -10, 650, "s6")
    wtFervidPrayer = createTextView("FervidPrayer", 90, 650, "s7")

    initHealerUtility(false)
end