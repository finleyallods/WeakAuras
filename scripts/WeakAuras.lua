local myId
local currentSpec

local aspectMAP = {
    DPS = "Aspect of Assault",
    TANK = "Aspect of Defense"
}

local initMap = {
    WARRIOR_DPS = initWarrior,
    WARRIOR_TANK = initWarriorTank,
    PRIEST_DPS = initHealer,
    ENGINEER_DPS = initEngineer,
}

local onBuffAddedMap = {
    WARRIOR_DPS = onWarriorBuffAdded,
    WARRIOR_TANK = onWarriorTankBuffAdded,
    PRIEST_DPS = nil,
    ENGINEER_DPS = nil
}

local onBuffRemovedMap = {
    WARRIOR_DPS = onWarriorBuffRemoved,
    WARRIOR_TANK = onWarriorTankBuffRemoved,
    PRIEST_DPS = nil,
    ENGINEER_DPS = nil
}

local onActionPanelElementEffectMap = {
    WARRIOR_DPS = onWarriorActionPanelElementEffect,
    WARRIOR_TANK = onWarriorTankActionPanelElementEffect,
    PRIEST_DPS = onPriestActionPanelElementEffect,
    ENGINEER_DPS = onEngineerActionPanelElementEffect
}

local onActionPanelElementChangedMap = {
    WARRIOR_DPS = nil,
    WARRIOR_TANK = nil,
    PRIEST_DPS = nil,
    ENGINEER_DPS = nil
}

local onWarriorCombatAdvantageChangedMap = {
    WARRIOR_DPS = onWarriorCombatAdvantageChanged,
    WARRIOR_TANK = onWarriorTankCombatAdvantageChanged,
    PRIEST_DPS = nil,
    ENGINEER_DPS = nil
}

local onUnitManaChangedMap = {
    WARRIOR_DPS = onWarriorUnitManaChanged,
    WARRIOR_TANK = onWarriorTankUnitManaChanged,
    PRIEST_DPS = nil,
    ENGINEER_DPS = nil
}

local onEventAvatarWarriorDamagePoolChangedMap = {
    WARRIOR_DPS = nil,
    WARRIOR_TANK = onWarriorTankEventAvatarWarriorDamagePoolChanged,
    PRIEST_DPS = nil,
    ENGINEER_DPS = nil
}

local onEventUnitHealthChangedMap = {
    WARRIOR_DPS = nil,
    WARRIOR_TANK = onWarriorTankEventUnitHealthChanged,
    PRIEST_DPS = nil,
    ENGINEER_DPS = nil
}

local onEventSecondTimerMap = {
    WARRIOR_DPS = nil,
    WARRIOR_TANK = onWarriorTankEventSecondTimer,
    PRIEST_DPS = nil,
    ENGINEER_DPS = nil
}

function delegateEvent(params, delegate)
    if params.objectId ~= nil and params.objectId ~= myId then
        return
    end

    if delegate ~= nil then
        delegate(params)
    end
end

function onBuffAdded(params)
    for aspectKey, aspectValue in pairs(aspectMAP) do
        if userMods.FromWString(params.buffName) == aspectValue then
            debugMessage(aspectValue.." was added.")
            --initClass()
        end
    end

    delegateEvent(params, onBuffAddedMap[currentSpec])
end

function onBuffRemoved(params)
    for aspectKey, aspectValue in pairs(aspectMAP) do
        if userMods.FromWString(params.buffName) == aspectValue then
            debugMessage(aspectValue.." was removed.")
            --initClass()
        end
    end

    delegateEvent(params, onBuffRemovedMap[currentSpec])
end

function onActionPanelElementEffect(params)
    if params.effect == 1 and params.duration < 1500  then
        return
    end

    delegateEvent(params, onActionPanelElementEffectMap[currentSpec])
end

function onActionPanelElementChanged(params)
    delegateEvent(params, onActionPanelElementChangedMap[currentSpec])
end

function onWarriorCombatAdvantageChanged(params)
    delegateEvent(params, onWarriorCombatAdvantageChangedMap[currentSpec])
end

function onUnitManaChanged(params)
    delegateEvent(params, onUnitManaChangedMap[currentSpec])
end

function onEventAvatarWarriorDamagePoolChanged(params)
    delegateEvent(params, onEventAvatarWarriorDamagePoolChangedMap[currentSpec])
end

function onEventUnitHealthChanged(params)
    if not isMe(params.target) then
        return
    end

    delegateEvent(params, onEventUnitHealthChangedMap[currentSpec])
end

function onEventSecondTimer(params)
    delegateEvent(params, onEventSecondTimerMap[currentSpec])
end

function onTalentsChanged()
    debugMessage("Talents have changed.")
    destroyAllWidgets()
    initClass()
end

function getAspect()
    for i, buffId in pairs(object.GetBuffs(myId)) do
        for aspectKey, aspectValue in pairs(aspectMAP) do
            if userMods.FromWString(object.GetBuffInfo(buffId).name) == aspectValue then
                return avatar.GetClass() .. "_" .. aspectKey
            end
        end
    end

    return nil
end

function initClass()
    currentSpec = getAspect()
    if currentSpec ~= nil then
        local delegate = initMap[currentSpec]
        if delegate ~= nil then
            newState()
            delegate()
        end
    else
        sendMessage("Aspect is missing.")
    end
end

function init()
    myId = avatar.GetId()
    common.RegisterEventHandler(onBuffAdded, "EVENT_OBJECT_BUFF_ADDED")
    common.RegisterEventHandler(onBuffRemoved, "EVENT_OBJECT_BUFF_REMOVED")
    common.RegisterEventHandler(onActionPanelElementEffect, "EVENT_ACTION_PANEL_ELEMENT_EFFECT")
    common.RegisterEventHandler(onActionPanelElementChanged, "EVENT_ACTION_PANEL_ELEMENT_CHANGED")
    common.RegisterEventHandler(onWarriorCombatAdvantageChanged, "EVENT_AVATAR_WARRIOR_COMBAT_ADVANTAGE_CHANGED")
    common.RegisterEventHandler(onUnitManaChanged, "EVENT_UNIT_MANA_PERCENTAGE_CHANGED")
    common.RegisterEventHandler(onTalentsChanged, "EVENT_TALENTS_CHANGED")
    common.RegisterEventHandler(onTalentsChanged, "EVENT_AVATAR_CLASS_FORM_CHANGED")
    common.RegisterEventHandler(onEventAvatarWarriorDamagePoolChanged, "EVENT_AVATAR_WARRIOR_DAMAGE_POOL_CHANGED")
    common.RegisterEventHandler(onEventUnitHealthChanged, "EVENT_UNIT_DAMAGE_RECEIVED")
    common.RegisterEventHandler(onEventUnitHealthChanged, "EVENT_HEALING_RECEIVED")
    common.RegisterEventHandler(onEventSecondTimer, "EVENT_SECOND_TIMER")

    initClass()
end

if (avatar.IsExist()) then
    init()
else
    common.RegisterEventHandler(init, "EVENT_AVATAR_CREATED")
end
