local currentWidgets = {}

function addWidgetToList(widget)
    currentWidgets[widget:GetName()] = widget
end

function getWidgetByName(widgetName)
    return currentWidgets[widgetName]
end

function destroyAllWidgets()
    for widgetName, widget in pairs(currentWidgets) do
        destroyWidget(widget)
    end
end