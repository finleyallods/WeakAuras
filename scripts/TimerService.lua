local timers = {}

function timer(params)
    if not params.effectType == ET_FADE then
        return
    end
    local name = nil
    for i, j in pairs(timers) do
        if j and equals(params.wtOwner, j.widget) then
            name = i
        end
    end
    if not name then
        return
    end

    if timers[name] then
        if timers[name].widget and not timers[name].one then
            timers[name].widget:PlayFadeEffect(1.0, 1.0, timers[name].speed * 1000, EA_MONOTONOUS_INCREASE)
        end
        userMods.SendEvent(timers[name].event, { sender = common.GetAddonName() })
    end
end

function startTimer(name, eventname, speed, one)
    if name and timers[name] then
        destroy(timers[name].widget)
    end
    local timerWidget = createWidget(mainForm, name, "TextView")
    if not timerWidget or not name or not eventname then
        return nil
    end
    timers[name] = {}
    timers[name].event = eventname
    timers[name].widget = timerWidget
    timers[name].one = one
    timers[name].speed = tonumber(speed) or 1

    common.RegisterEventHandler(timer, "EVENT_EFFECT_FINISHED")
    timerWidget:PlayFadeEffect(1.0, 1.0, timers[name].speed * 1000, EA_MONOTONOUS_INCREASE)
    return true
end

function stopTimer(name)
    common.UnRegisterEventHandler(timer, "EVENT_EFFECT_FINISHED")
end

function setTimeout(name, speed)
    if name and timers[name] and speed then
        timers[name].speed = tonumber(speed) or 1
    end
end

function destroyTimer(name)
    if timers[name] then
        destroy(timers[name].widget)
    end
    timers[name] = nil
end