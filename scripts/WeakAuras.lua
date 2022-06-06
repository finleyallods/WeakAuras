local myId
local currentSpec

local aspectMAP = {
    DPS = "Aspect of Assault",
    TANK = "Aspect of Defense"
}

local initMap = {
    WARRIOR_DPS = initWarrior,
    WARRIOR_TANK = initWarriorTank,
    PRIEST_DPS = initHealer
}

local onBuffAddedMap = {
    WARRIOR_DPS = onWarriorBuffAdded,
    WARRIOR_TANK = onWarriorTankBuffAdded,
    PRIEST_DPS = nil
}

local onBuffRemovedMap = {
    WARRIOR_DPS = onWarriorBuffRemoved,
    WARRIOR_TANK = onWarriorTankBuffRemoved,
    PRIEST_DPS = nil
}

local onActionPanelElementEffectMap = {
    WARRIOR_DPS = onWarriorActionPanelElementEffect,
    WARRIOR_TANK = onWarriorTankActionPanelElementEffect,
    PRIEST_DPS = onPriestActionPanelElementEffect
}

local onActionPanelElementChangedMap = {
    WARRIOR_DPS = nil,
    WARRIOR_TANK = nil,
    PRIEST_DPS = nil
}

local onWarriorCombatAdvantageChangedMap = {
    WARRIOR_DPS = onWarriorCombatAdvantageChanged,
    WARRIOR_TANK = onWarriorTankCombatAdvantageChanged,
    PRIEST_DPS = nil
}

local onUnitManaChangedMap = {
    WARRIOR_DPS = onWarriorUnitManaChanged,
    WARRIOR_TANK = onWarriorTankUnitManaChanged,
    PRIEST_DPS = nil
}

local onEventEquipmentItemEffectMap = {
    WARRIOR_DPS = onWarriorEventEquipmentItemEffect,
    WARRIOR_TANK = onWarriorTankEventEquipmentItemEffect,
    PRIEST_DPS = nil
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
            initClass()
        end
    end

    delegateEvent(params, onBuffAddedMap[currentSpec])
end

function onBuffRemoved(params)
    for aspectKey, aspectValue in pairs(aspectMAP) do
        if userMods.FromWString(params.buffName) == aspectValue then
            debugMessage(aspectValue.." was removed.")
            initClass()
        end
    end

    delegateEvent(params, onBuffRemovedMap[currentSpec])
end

function onActionPanelElementEffect(params)
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

function onEventEquipmentItemEffect(params)
    delegateEvent(params, onEventEquipmentItemEffectMap[currentSpec])
end

function onTalentsChanged()
    debugMessage("Talents have changed.")
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
        destroyAllWidgets()
    end
end

function init()
    myId = avatar.GetId()
    common.RegisterEventHandler(onBuffAdded, "EVENT_OBJECT_BUFF_ADDED")
    common.RegisterEventHandler(onBuffRemoved, "EVENT_OBJECT_BUFF_REMOVED")
    common.RegisterEventHandler(onActionPanelElementEffect, "EVENT_ACTION_PANEL_ELEMENT_EFFECT")
    common.RegisterEventHandler(onActionPanelElementChanged, "EVENT_ACTION_PANEL_ELEMENT_CHANGED")
    common.RegisterEventHandler(onWarriorCombatAdvantageChanged, "EVENT_AVATAR_WARRIOR_COMBAT_ADVANTAGE_CHANGED")
    common.RegisterEventHandler(onUnitManaChanged, " EVENT_UNIT_MANA_CHANGED")
    common.RegisterEventHandler(onEventEquipmentItemEffect, "EVENT_EQUIPMENT_ITEM_EFFECT")
    common.RegisterEventHandler(onTalentsChanged, "EVENT_TALENTS_CHANGED")
    common.RegisterEventHandler(onTalentsChanged, "EVENT_AVATAR_CLASS_FORM_CHANGED")

    initClass()
end

if (avatar.IsExist()) then
    init()
else
    common.RegisterEventHandler(init, "EVENT_AVATAR_CREATED")
end
