local ENERGY_DESTRUCTIVE_ATTACK = 37
local ENERGY_FRACTURE = 25

function getAnimalPounceTextColor()
    if isOnCd("Animal Pounce") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() > 70 then
        return nil
    end

    if hasBuff("Bloody Harvest") then
        return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or nil
    end

    return COLOR_NORMAL
end

function getJaggedSliceTextColor()
    if isOnCd("Jagged Slice") then
        return nil
    end

    if getEnergy() < 24 then
        return COLOR_IMPOSSIBLE
    end

    return COLOR_DOT
end

function getDestructiveAttackTextColor()
    if hasBuff("Flaming Blade") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() > 75 then
        return getEnergy() >= ENERGY_DESTRUCTIVE_ATTACK and COLOR_BAD or COLOR_IMPOSSIBLE
    end

    if not hasBuff("Bloody Harvest") then
        return getEnergy() >= ENERGY_DESTRUCTIVE_ATTACK and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or COLOR_BAD
end

function getFractureTextColor()
    if not hasBuff("Flaming Blade") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() > 85 then
        return getEnergy() >= ENERGY_FRACTURE and COLOR_BAD or COLOR_IMPOSSIBLE
    end

    if not hasBuff("Bloody Harvest") then
        return getEnergy() >= ENERGY_FRACTURE and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or COLOR_BAD
end

function getRapidBlowTextColorForBurst()
    if not isOnCd("Deadly Lunge") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() < 25 then
        return COLOR_IMPOSSIBLE
    end

    if hasBuff("Flaming Blade") and getEnergy() < ENERGY_FRACTURE then
        return COLOR_NORMAL
    end

    if getEnergy() < ENERGY_DESTRUCTIVE_ATTACK then
        return COLOR_NORMAL
    end

    return avatar.GetWarriorCombatAdvantage() >= 45 and COLOR_NORMAL or COLOR_BAD
end

function getRapidBlowTextColor()
    if not isOnCd("Deadly Lunge") and not isOnCd("Bloody Harvest") then
        return nil
    end

    if hasBuff("Bloody Harvest") then
       return getRapidBlowTextColorForBurst()
    end

    if avatar.GetWarriorCombatAdvantage() < 25 then
        return nil
    end

    if hasBuff("Flaming Blade") then
        return getEnergy() < ENERGY_FRACTURE and COLOR_NORMAL or nil
    end

    return getEnergy() < ENERGY_DESTRUCTIVE_ATTACK and COLOR_NORMAL or nil
end

function getDeadlyLungeTextColor()
    if isOnCd("Deadly Lunge") then
        return nil
    end

    if hasBuff("Bloody Harvest") then
        return avatar.GetWarriorCombatAdvantage() >= 25 and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    if avatar.GetWarriorCombatAdvantage() >= 25 then
        return COLOR_BAD
    end

    return nil
end

function getBloodyHarvestTextColor()
    if isOnCd("Bloody Harvest") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() < 30 then
        return COLOR_IMPOSSIBLE
    end

    if avatar.GetWarriorCombatAdvantage() < 45 or isOnCd("Deadly Lunge") then
        return COLOR_BAD
    end

    return COLOR_NORMAL
end

function getBerserkerTextColor()
    if isOnCd("Berserker") then
        return nil
    end

    return COLOR_NORMAL
end

function evaluateWarriorPriority()
    evaluate("Deadly Lunge", getDeadlyLungeTextColor)
    evaluate("Jagged Slice", getJaggedSliceTextColor)
    evaluate("Destructive Attack", getDestructiveAttackTextColor)
    evaluate("Fracture", getFractureTextColor)
    evaluate("Rapid Blow", getRapidBlowTextColor)
    evaluate("Bloody Harvest", getBloodyHarvestTextColor)
    evaluate("Animal Pounce", getAnimalPounceTextColor)
    evaluate("Berserker", getBerserkerTextColor)
    evaluateUtility()
end
