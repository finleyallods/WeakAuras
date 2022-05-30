Global("wtCombatAdvantage", nil)

function getCombatAdvantage()
    return tostring(avatar.GetWarriorCombatAdvantage())
end

function onWarriorCombatAdvantageChanged()
    wtCombatAdvantage:SetVal("value", getCombatAdvantage())
end

function init()
    wtCombatAdvantage = createTextView("CombatAdvantage", 40, 500, getCombatAdvantage())

    common.RegisterEventHandler(onWarriorCombatAdvantageChanged, "EVENT_AVATAR_WARRIOR_COMBAT_ADVANTAGE_CHANGED")
end

if (avatar.IsExist()) then
    init()
else
    common.RegisterEventHandler(init, "EVENT_AVATAR_CREATED")
end
