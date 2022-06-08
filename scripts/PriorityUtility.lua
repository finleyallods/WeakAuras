function checkAllBuffs(buffs, params, activate)
    for key, buff in pairs(buffs) do
        if userMods.FromWString(params.buffName) == buff then
            setBuffId(buff, activate and params.buffId or nil)
        end
    end
end

function checkAllCDs(cds, params)
    if params.effect < 1 or params.effect > 2 then
        return
    end

    if params.effect == 1 and params.duration < 1500 then
        return
    end

    local timeStamp = params.effect == 1 and common.GetLocalDateTime() or nil

    for key, cdName in pairs(cds) do
        if params.index == key then
            setCD(cdName, timeStamp, params.duration)
        end
    end
end

function evaluate(widgetName, textColorGetter)
    local widget = getWidgetByName(widgetName)

    if widget == nil then
        return
    end

    local textColor = textColorGetter()
    if textColor ~= nil then
        show(widget)
        setTextColor(widget, textColor)
    else
        hide(widget)
    end
end

function displayPriority(priority)
    for widgetName, textColor in pairs(priority) do
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