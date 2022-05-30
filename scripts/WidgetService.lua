local textViewTemplate = mainForm:GetChildChecked("TextView", false)

function createTextView(widgetName, posX, posY, initialValue)
    local widget = createWidget(mainForm, widgetName, textViewTemplate, posX, posY)
    widget:SetVal("value", initialValue)

    return widget
end

function createWidget(parent, widgetName, template, posX, posY, alignX, alignY, width, height)
    local desc = getDesc(template)
    if not desc then
        sendMessage("Description for widget " .. tostring(widgetName) .. " not found.")
        return nil
    end
    local widget = parent:CreateWidgetByDesc(desc)
    if parent and widget
    then
        parent:AddChild(widget)
    end
    setName(widget, widgetName)
    align(widget, alignX, alignY)
    move(widget, posX, posY)
    resize(widget, width, height)
    show(widget)

    return widget
end

function getDesc(widget)
    return widget and widget.GetWidgetDesc and widget:GetWidgetDesc() or nil
end

function setName(widget, name)
    if not widget or not name then
        return nil
    end
    if widget.SetName then
        widget:SetName(name)
    end
end

function align(widget, alignX, alingY)
    if not widget then
        return
    end
    local BarPlace = widget.GetPlacementPlain and widget:GetPlacementPlain()
    if not BarPlace then
        return nil
    end
    if alignX then
        BarPlace.alignX = alignX
    end
    if alingY then
        BarPlace.alignY = alingY
    end
    if widget.SetPlacementPlain then
        widget:SetPlacementPlain(BarPlace)
    end
end

function move(widget, posX, posY)
    if not widget then
        return
    end
    local BarPlace = widget.GetPlacementPlain and widget:GetPlacementPlain()
    if not BarPlace then
        return nil
    end
    if posX then
        BarPlace.posX = posX
        BarPlace.highPosX = posX
    end
    if posY then
        BarPlace.posY = posY
        BarPlace.highPosY = posY
    end
    if widget.SetPlacementPlain then
        widget:SetPlacementPlain(BarPlace)
    end
end

function resize(widget, width, height)
    if not widget then
        return
    end
    local BarPlace = widget.GetPlacementPlain and widget:GetPlacementPlain()
    if not BarPlace then
        return nil
    end
    if width then
        BarPlace.sizeX = width
    end
    if height then
        BarPlace.sizeY = height
    end
    if widget.SetPlacementPlain then
        widget:SetPlacementPlain(BarPlace)
    end
end

function show(widget)
    if not widget then
        return nil
    end
    if not widget.IsVisible or widget:IsVisible() then
        return nil
    end
    if widget.Show then
        widget:Show(true)
    end
end

function hide(widget)
    if not widget then
        return nil
    end
    if not widget.IsVisible or not widget:IsVisible() then
        return nil
    end
    if widget.Show then
        widget:Show(false)
    end
end