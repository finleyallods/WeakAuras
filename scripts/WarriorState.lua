local myId

local warriorState

function newWarriorState()
    warriorState = {
        buffs = {},
        cds = {},
    }
end

function isMe(id)
    return id == myId
end

function setBuffId(buffName, buffId)
    warriorState.buffs[buffName.."BuffId"] = buffId
end

function hasBuff(buffName)
    return warriorState.buffs[buffName.."BuffId"] ~= nil
end

function setWarriorCD(cdName, timeStamp, duration)
    if timeStamp ~= nil or duration ~= nil then
        warriorState.cds[cdName] = {}
        warriorState.cds[cdName].timeStamp = timeStamp
        warriorState.cds[cdName].duration = duration
    else
        warriorState.cds[cdName] = nil
    end
end

function isOnCd(cdName)
    return warriorState.cds[cdName] ~= nil
end
