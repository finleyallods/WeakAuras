local ENERGY_DESTRUCTIVE_ATTACK = 40
local ENERGY_FRACTURE = 24

local FLAMING_BLADE = "Flaming Blade"
local DESTRUCTIVE_ATTACK = "Destructive Attack"
local FRACTURE = "Fracture"
local JAGGED_SLICE = "Jagged Slice"
local TREACHEROUS_STRIKE = "Treacherous Strike"
local DEADLY_LUNGE = "Deadly Lunge"
local BERSERKER = "Berserker"
local BLOODY_HARVEST = "Bloody Harvest"
local SLUGGISHNESS = "Sluggishness"

function getJaggedSliceTextColor()
    if isOnCd(JAGGED_SLICE) then
        return COLOR_NONE
    end

    return getEnergy() < 24 and COLOR_IMPOSSIBLE or COLOR_DOT
end

function getTreacherousStrikeTextColor()
    if isOnCd(TREACHEROUS_STRIKE) then
        return COLOR_NONE
    end

    if avatar.GetWarriorCombatAdvantage() < 20 then
        return COLOR_IMPOSSIBLE
    end

    return getMsOnUnitBuffed(avatar.GetTarget(), SLUGGISHNESS) > 100 and COLOR_GOOD or COLOR_BAD
end

function getDeadlyLungeTextColor()
    if isOnCd(DEADLY_LUNGE) then
        return COLOR_NONE
    end

    if shouldBurst() then
        return COLOR_SECOND
    end

    if hasBuff(BLOODY_HARVEST) then
        return avatar.GetWarriorCombatAdvantage() >= 25 and COLOR_GOOD or COLOR_IMPOSSIBLE
    end

    return avatar.GetWarriorCombatAdvantage() >= 25 and COLOR_NORMAL or COLOR_NONE
end

function getBerserkerTextColor()
    if isOnCd(BERSERKER) then
        return COLOR_NONE
    end

    if hasBuff(BLOODY_HARVEST) or shouldBurst() then
        return COLOR_GOOD
    end

    return COLOR_NORMAL
end

function getBloodyHarvestTextColor()
    if isOnCd(BLOODY_HARVEST) then
        return COLOR_NONE
    end

    if avatar.GetWarriorCombatAdvantage() < 30 then
        return COLOR_IMPOSSIBLE
    end

    if shouldBurst() then
        return COLOR_GOOD
    end

    return COLOR_NORMAL
end

function shouldBurst()
    return can(BLOODY_HARVEST) and can(DEADLY_LUNGE) and avatar.GetWarriorCombatAdvantage() >= 55
end

function getCombatAdvantageBuilder()
    if hasBuff(FLAMING_BLADE) and getEnergy() >= ENERGY_FRACTURE then
        return FRACTURE
    end

    if not hasBuff(FLAMING_BLADE) and getEnergy() >= ENERGY_DESTRUCTIVE_ATTACK then
        return DESTRUCTIVE_ATTACK
    end

    return nil
end

function shouldBuildCombatAdvantage()
    if not getCombatAdvantageBuilder() or shouldBurst() then
        return false
    end

    if hasBuff(BLOODY_HARVEST) and can(DEADLY_LUNGE) and avatar.GetWarriorCombatAdvantage() >= 25 then
        return false
    end

    return isOnCd(TREACHEROUS_STRIKE) or avatar.GetWarriorCombatAdvantage() < 25
end

function getWarriorPriority()
    local priority = {
        [DESTRUCTIVE_ATTACK] = COLOR_NONE,
        [FRACTURE] = COLOR_NONE,
    }

    if shouldBuildCombatAdvantage() then
        priority[getCombatAdvantageBuilder()] = COLOR_NORMAL
    end

    priority[JAGGED_SLICE] = getJaggedSliceTextColor()
    priority[TREACHEROUS_STRIKE] = getTreacherousStrikeTextColor()
    priority[DEADLY_LUNGE] = getDeadlyLungeTextColor()
    priority[BLOODY_HARVEST] = getBloodyHarvestTextColor()
    priority[BERSERKER] = getBerserkerTextColor()

    return priority
end

function evaluateWarriorPriority()
    displaySkills(getWarriorPriority())
    evaluateUtility()
end
