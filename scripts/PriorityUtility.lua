function checkAllBuffs(buffs, params, activate)
    for key, buff in pairs(buffs) do
        if userMods.FromWString(params.buffName) == buff then
            setBuffId(buff, activate and params.buffId or nil)
            evaluatePriority()
        end
    end
end

function checkAllCDs(cds, params, setter)
    if params.effect < 1 or params.effect > 2 then
        return
    end

    if params.effect == 1 and params.duration < 1500 then
        return
    end

    local timeStamp = params.effect == 1 and common.GetLocalDateTime() or nil

    for key, cdName in pairs(cds) do
        if params.index == key then
            setter(cdName, timeStamp, params.duration)
        end
    end
end

function evaluate(widgetGetter, textColorGetter)
    local widget = widgetGetter and widgetGetter()

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

function getEnergy()
    return unit.GetMana(avatar.GetId()).mana
end

function getCombatAdvantage()
    return tostring(avatar.GetWarriorCombatAdvantage())
end