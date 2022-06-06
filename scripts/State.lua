local myId

local state

function newState()
    state = {
        buffs = {},
        cds = {},
    }
end

function isMe(id)
    return id == myId
end

function setBuffId(buffName, buffId)
    state.buffs[buffName.."BuffId"] = buffId
end

function hasBuff(buffName)
    return state.buffs[buffName.."BuffId"] ~= nil
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

function isOnCd(cdName)
    return state.cds[cdName] ~= nil
end
