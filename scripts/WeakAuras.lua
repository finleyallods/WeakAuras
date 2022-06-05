local myId

local initMap = {
    WARRIOR = initWarrior,
    PRIEST = initHealer
}

local onBuffAddedMap = {
    WARRIOR = onWarriorBuffAdded,
    PRIEST = nil
}

local onBuffRemovedMap = {
    WARRIOR = onWarriorBuffRemoved,
    PRIEST = nil
}

local onActionPanelElementEffectMap = {
    WARRIOR = onWarriorActionPanelElementEffect,
    PRIEST = onPriestActionPanelElementEffect
}

local onActionPanelElementChangedMap = {
    WARRIOR = nil,
    PRIEST = nil
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
    if isAspectOfAssault(params.buffName) then
        initClass()
    end

    delegateEvent(params, onBuffAddedMap[avatar.GetClass()])
end

function onBuffRemoved(params)
    if isAspectOfAssault(params.buffName) then
        initClass()
    end

    delegateEvent(params, onBuffRemovedMap[avatar.GetClass()])
end

function onActionPanelElementEffect(params)
    delegateEvent(params, onActionPanelElementEffectMap[avatar.GetClass()])
end

function onActionPanelElementChanged(params)
    delegateEvent(params, onActionPanelElementChangedMap[avatar.GetClass()])
end

function hasAspect()
    for i, buffId in pairs(object.GetBuffs(myId)) do
        if isAspectOfAssault(object.GetBuffInfo(buffId).name) then
            return true
        end
    end

    return false
end

function isAspectOfAssault(buffName)
    return userMods.FromWString(buffName) == "Aspect of Assault"
end

function initClass()
    myId = avatar.GetId()
    if hasAspect() then
        local delegate = initMap[avatar.GetClass()]

        if delegate ~= nil then
            delegate()
        end
    else
        sendMessage("Aspect is missing!")
    end
end

function init()
    common.RegisterEventHandler(onBuffAdded, "EVENT_OBJECT_BUFF_ADDED")
    common.RegisterEventHandler(onBuffRemoved, "EVENT_OBJECT_BUFF_REMOVED")
    common.RegisterEventHandler(onActionPanelElementEffect, "EVENT_ACTION_PANEL_ELEMENT_EFFECT")
    common.RegisterEventHandler(onActionPanelElementChanged, "EVENT_ACTION_PANEL_ELEMENT_CHANGED")
    initClass()
end

if (avatar.IsExist()) then
    init()
else
    common.RegisterEventHandler(init, "EVENT_AVATAR_CREATED")
end
