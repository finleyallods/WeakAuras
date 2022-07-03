function checkAllBuffs(buffs, params, activate)
    for key, buff in pairs(buffs) do
        if userMods.FromWString(params.buffName) == buff then
            setBuffId(buff, activate and params.buffId or nil)
        end
    end
end

function shouldIgnoreActionPanelElementEffect(currentCds, params)
    if params.effect < 1 or params.effect > 2 then
        return true
    end

    if params.effect == 1 then
        if params.duration < 1500 or currentCds[params.index] == true then
            return true
        end
    end

    if params.effect == 2 then
        if not currentCds[params.index] or currentCds[params.index] == false then
            return true
        end
    end

    return false
end

function updateCurrentCds(currentCds, params)
    if params.effect == 1 then
        currentCds[params.index] = true
    end

    if params.effect == 2 then
        currentCds[params.index] = false
    end
end

function checkAllCDs(cds, params)
    local timeStamp = params.effect == 1 and common.GetLocalDateTime().overallMs or nil

    for key, cdName in pairs(cds) do
        if params.index == key then
            setCD(cdName, timeStamp, params.duration)
        end
    end
end

function displaySkills(skills)
    for widgetName, textColor in pairs(skills) do
        local widget = getWidgetByName(widgetName)

        if widget == nil then
            return
        end

        if textColor ~= nil and textColor ~= COLOR_NONE then
            show(widget)
            setTextColor(widget, textColor)
        else
            hide(widget)
        end
    end
end

function getEnergy()
    return unit.GetMana(avatar.GetId()).mana
end

function getCombatAdvantage()
    return tostring(avatar.GetWarriorCombatAdvantage())
end

function isMe(id)
    return id == avatar.GetId()
end