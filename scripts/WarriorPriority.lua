local ENERGY_DESTRUCTIVE_ATTACK = 37
local ENERGY_FRACTURE = 25

local FLAMING_BLADE = "Flaming Blade"
local DESTRUCTIVE_ATTACK = "Destructive Attack"
local FRACTURE = "Fracture"
local JAGGED_SLICE = "Jagged Slice"
local ANIMAL_POUNCE = "Animal Pounce"
local RAPID_BLOW = "Rapid Blow"
local DEADLY_LUNGE = "Deadly Lunge"
local BERSERKER = "Berserker"
local BLOODY_HARVEST = "Bloody Harvest"

function getJaggedSliceTextColor()
    if isOnCd(JAGGED_SLICE) then
        return COLOR_NONE
    end

    return getEnergy() < 24 and COLOR_IMPOSSIBLE or COLOR_DOT
end

function getAnimalPounceTextColor()
    if isOnCd(ANIMAL_POUNCE) then
        return COLOR_NONE
    end

    if hasBuff(BLOODY_HARVEST) then
        return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or COLOR_BAD
    end

    if shouldBurst or avatar.GetWarriorCombatAdvantage() > 70 and getEnergy() > 70 then
        return COLOR_BAD
    end

    return COLOR_GOOD
end

function getRapidBlowTextColor()
    if shouldBurst() or shouldBuildCombatAdvantage() then
        return COLOR_NONE
    end

    if hasBuff(BLOODY_HARVEST) and can(DEADLY_LUNGE) then
        return COLOR_NONE
    end

    if can(BLOODY_HARVEST) then
        return COLOR_SECOND
    end

    return avatar.GetWarriorCombatAdvantage() >= 20 and COLOR_NORMAL or COLOR_IMPOSSIBLE
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

    return avatar.GetWarriorCombatAdvantage() >= 25 and COLOR_BAD or COLOR_NONE
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

    if can(BLOODY_HARVEST) and not shouldBuildCombatAdvantage() then
        return COLOR_NORMAL
    end

    return COLOR_BAD
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

    if avatar.GetWarriorCombatAdvantage() < 45 then
        return true
    end

    if hasBuff(BLOODY_HARVEST) then
        return false
    end

    if not hasBuff(FLAMING_BLADE) then
        return avatar.GetWarriorCombatAdvantage() <= 75
    end

    return avatar.GetWarriorCombatAdvantage() <= 85
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
    priority[ANIMAL_POUNCE] = getAnimalPounceTextColor()
    priority[RAPID_BLOW] = getRapidBlowTextColor()
    priority[DEADLY_LUNGE] = getDeadlyLungeTextColor()
    priority[BLOODY_HARVEST] = getBloodyHarvestTextColor()
    priority[BERSERKER] = getBerserkerTextColor()

    return priority
end

function evaluateWarriorPriority()
    displaySkills(getWarriorPriority())
    evaluateUtility()
end
