local state

function newState()
    state = {
        buffs = {},
        cds = {},
    }
end

function setBuffId(buffName, buffId)
    state.buffs[buffName] = buffId
end

function hasBuff(buffName)
    return state.buffs[buffName] ~= nil
end

function getMsOnBuff(buffName)
    local buffId = state.buffs[buffName]
    local buff =  object.GetBuffInfo( buffId )

    return buff.remainingMs
end

function setCD(cdName, timeStamp, duration)
    if timeStamp ~= nil or duration ~= nil then
        state.cds[cdName] = {}
        state.cds[cdName].timeStamp = timeStamp
        state.cds[cdName].duration = duration
    else
        state.cds[cdName] = nil
    end
end

function getMsOnCd(cdName)
    if can(cdName) then
        return 0
    end

    local msPassed = common.GetLocalDateTime().overallMs - state.cds[cdName].timeStamp

    return state.cds[cdName].duration - msPassed
end

function isOnCd(cdName)
    return state.cds[cdName] ~= nil
end

function can(cdName)
    return not isOnCd(cdName)
end
