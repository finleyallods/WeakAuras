local wtCombatAdvantage
local wtDestructiveAttack
local wtFracture
local wtJaggedSlice
local wtAnimalPounce
local wtTramp
local wtViciousSpin
local wtRapidBlow
local wtDeadlyLunge
local wtBerserker
local wtBloodyHarvest
local wtTrinket
local wtTurtle
local wtAdrenalineSurge

function getWtCombatAdvantage()
    return wtCombatAdvantage
end

function getWtDestructiveAttack()
    return wtDestructiveAttack
end

function getWtFracture()
    return wtFracture
end

function getWtJaggedSlice()
    return wtJaggedSlice
end

function getWtAnimalPounce()
    return wtAnimalPounce
end

function getWtTramp()
    return wtTramp
end

function getWtViciousSpin()
    return wtViciousSpin
end

function getWtRapidBlow()
    return wtRapidBlow
end

function getWtDeadlyLunge()
    return wtDeadlyLunge
end

function getWtBerserker()
    return wtBerserker
end

function getWtBloodyHarvest()
    return wtBloodyHarvest
end

function getWtTrinket()
    return wtTrinket
end

function getWtTurtle()
    return wtTurtle
end

function getWtAdrenalineSurge()
    return wtAdrenalineSurge
end

function setWtCombatAdvantage(widget)
    wtCombatAdvantage = widget
end

function setWtDestructiveAttack(widget)
    wtDestructiveAttack = widget
end

function setWtFracture(widget)
    wtFracture = widget
end

function setWtJaggedSlice(widget)
    wtJaggedSlice = widget
end

function setWtAnimalPounce(widget)
    wtAnimalPounce = widget
end

function setWtTramp(widget)
    wtTramp = widget
end

function setWtViciousSpin(widget)
    wtViciousSpin = widget
end

function setWtRapidBlow(widget)
    wtRapidBlow = widget
end

function setWtDeadlyLunge(widget)
    wtDeadlyLunge = widget
end

function setWtBerserker(widget)
    wtBerserker = widget
end

function setWtBloodyHarvest(widget)
    wtBloodyHarvest = widget
end

function setWtTrinket(widget)
    wtTrinket = widget
end

function setWtTurtle(widget)
    wtTurtle = widget
end

function setWtAdrenalineSurge(widget)
    wtAdrenalineSurge = widget
end

function clearWarrior()
    destroyWidget(wtJaggedSlice)
    destroyWidget(wtAnimalPounce)
    destroyWidget(wtCombatAdvantage)
    destroyWidget(wtDestructiveAttack)
    destroyWidget(wtFracture)
    destroyWidget(wtTramp)
    destroyWidget(wtViciousSpin)
    destroyWidget(wtRapidBlow)
    destroyWidget(wtDeadlyLunge)
    destroyWidget(wtBerserker)
    destroyWidget(wtBloodyHarvest)
    destroyWidget(wtTrinket)
    destroyWidget(wtTurtle)
    destroyWidget(wtAdrenalineSurge)
end