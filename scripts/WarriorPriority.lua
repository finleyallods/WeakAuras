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

function getDeadlyLungeTextColor()
    if isOnCd("Deadly Lunge") then
        return nil
    end

    if hasBuff("Bloody Harvest") then
        if avatar.GetWarriorCombatAdvantage() < 25 then
            return COLOR_IMPOSSIBLE
        else
            return COLOR_NORMAL
        end
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
        return getEnergy() >= 39 and COLOR_BAD or COLOR_IMPOSSIBLE
    end

    if not hasBuff("Bloody Harvest")
    then
        return getEnergy() >= 39 and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or COLOR_BAD
end

function getFractureTextColor()
    if not hasBuff("Flaming Blade") then
        return nil
    end

    if avatar.GetWarriorCombatAdvantage() > 75 then
        return getEnergy() >= 29 and COLOR_BAD or COLOR_IMPOSSIBLE
    end

    if not hasBuff("Bloody Harvest")
    then
        return getEnergy() >= 29 and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    return avatar.GetWarriorCombatAdvantage() < 45 and COLOR_NORMAL or COLOR_BAD
end

function getRapidBlowTextColor()
    if not isOnCd("Deadly Lunge") then
        return nil
    end

    if hasBuff("Bloody Harvest") then
        return avatar.GetWarriorCombatAdvantage() >= 45 and COLOR_NORMAL or COLOR_IMPOSSIBLE
    end

    if avatar.GetWarriorCombatAdvantage() > 85 then
        return COLOR_NORMAL
    end

    if avatar.GetWarriorCombatAdvantage() > 75 and hasBuff("Flaming Blade") then
        return COLOR_NORMAL
    end

    return nil
end

function getBerserkerTextColor()
    if isOnCd("Berserker") then
        return nil
    end

    return COLOR_NORMAL
end

function evaluateWarriorPriority()
    evaluate(getWtDeadlyLunge, getDeadlyLungeTextColor)
    evaluate(getWtJaggedSlice, getJaggedSliceTextColor)
    evaluate(getWtDestructiveAttack, getDestructiveAttackTextColor)
    evaluate(getWtFracture, getFractureTextColor)
    evaluate(getWtRapidBlow, getRapidBlowTextColor)
    evaluate(getWtBloodyHarvest, getBloodyHarvestTextColor)
    evaluate(getWtAnimalPounce, getAnimalPounceTextColor)
    evaluate(getWtBerserker, getBerserkerTextColor)
    evaluateUtility()
end
