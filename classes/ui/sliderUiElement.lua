QhunCore.SliderUiElement = {}
QhunCore.SliderUiElement.__index = QhunCore.SliderUiElement

-- constructor
--[[
    {
        label: string,
        storageIdentifyer: string,
        settings?: {
            min?: number = 0
            max?: number = 100,
            width?: number = 250,
            steps?: number = 1,
            decimals?: number = 0,
            padding?: number = 0,
            tooltip?: string = nil
        }
    }
]]
function QhunCore.SliderUiElement.new(label, storageIdentifyer, settings)
    -- call super class
    local instance = QhunCore.AbstractUiElement.new(storageIdentifyer)

    -- bind properties
    instance._label = label
    instance._settings =
        qhunTableValueOrDefault(
        settings,
        {
            min = 0,
            max = 100,
            width = 250,
            steps = 1,
            decimals = 0,
            padding = 0,
            tooltip = nil
        }
    )
    instance._tempValue = nil
    instance._slider = nil
    instance._lockValueChangeEvent = false

    -- bind current values
    setmetatable(instance, QhunCore.SliderUiElement)

    return instance
end

-- set inheritance
setmetatable(QhunCore.SliderUiElement, {__index = QhunCore.AbstractUiElement})

--[[
    PUBLIC FUNCTIONS
]]
function QhunCore.SliderUiElement:render(storage, parentFrame)
    -- get initial value
    local initialValue = self:getStorageValue(storage) or 0

    local wrapper = CreateFrame("FRAME", nil, parentFrame)
    local label = wrapper:CreateFontString("$parentTitle", "ARTWORK")

    -- add label
    label:SetPoint("LEFT", wrapper, "LEFT", 0, 0)
    label:SetFont("Fonts\\FRIZQT__.TTF", 11)
    label:SetText(self._label)

    local slider = CreateFrame("Slider", "qhunCoreUiSlider_" .. qhunUuid(), wrapper, "OptionsSliderTemplate")
    slider:SetWidth(self._settings.width)
    slider:SetHeight(15)
    slider:SetOrientation("HORIZONTAL")
    slider:SetMinMaxValues(self._settings.min, self._settings.max)
    slider:SetValueStep(self._settings.steps)
    slider:SetPoint("LEFT", wrapper, "LEFT", label:GetWidth() + 25, 0)

    -- set the initial value
    slider:SetValue(initialValue)

    -- set default texts
    local low = getglobal(slider:GetName() .. "Low")
    low:SetText(self._settings.min)
    local high = getglobal(slider:GetName() .. "High")
    high:SetText(self._settings.max)
    local current = getglobal(slider:GetName() .. "Text")
    current:SetText(initialValue)

    -- and save the text objects on the slider
    slider.low = low
    slider.high = high
    slider.current = current

    -- add events
    slider:SetScript(
        "OnValueChanged",
        function(_, value)
            self:onValueChange(storage, slider, value)
        end
    )

    -- bind slider, label and wrapper
    wrapper.slider = slider
    wrapper.label = label

    -- apply final width
    wrapper:SetSize(label:GetWidth() + slider:GetWidth(), 25)

    -- add extra padding and tooltip
    wrapper._qhunCoreExtraPadding = self._settings.padding
    slider.tooltipText = self._settings.tooltip

    -- set the slider reference on the class
    self._slider = wrapper

    return wrapper
end

-- will be triggered if the storage was reset
function QhunCore.SliderUiElement:onStorageReset(storage)
    -- get the value from the storage
    local value = self:getStorageValue(storage)

    -- check if there is anything to do
    if not self._slider then
        return
    end

    -- reset the ui
    self._slider.slider.current:SetText(value)
    self._tempValue = nil

    -- lock event to prevent the event from beeing evaluated
    self._lockValueChangeEvent = true
    self._slider.slider:SetValue(value)
    self._lockValueChangeEvent = false
end

-- will be triggered if the user changes the value of the slider
function QhunCore.SliderUiElement:onValueChange(storage, slider, value)
    -- check for a lock
    if self._lockValueChangeEvent then
        return
    end

    -- check if the value changes (with decimals)
    local roundedValue = qhunRound(value, self._settings.decimals)

    -- check against the stored temp value
    if type(self._tempValue) ~= "number" or self._tempValue ~= roundedValue then
        -- yes the value has been changed!
        -- update the visible current value
        slider.current:SetText(roundedValue)

        -- update the storage
        self:setStorageValue(storage, roundedValue)

        -- save the new temp value
        self._tempValue = roundedValue
    end
end
