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

local function isBuffed (buffId)
    for key, value in pairs(object.GetBuffs( avatar.GetId())) do
        if value == buffId then
            return true
        end
    end

    return false
end


function getMsOnBuff(buffName)
    local buffId = state.buffs[buffName]

    if not buffId or not isBuffed (buffId) then
        return 0
    end
    local buffInfo =  object.GetBuffInfo( buffId )

    return buffInfo and buffInfo.remainingMs or 9
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
