QhunCore.CheckboxUiElement = {}
QhunCore.CheckboxUiElement.__index = QhunCore.CheckboxUiElement

-- constructor
--[[
    {
        -- the visible label for the checkbox
        label: string,
        storage: {QhunCore.Storage}
        -- the property name in the storage to get and set this value
        storageIdentifyer: string,
        settings?: {
            padding?: number = 0
        }
    }
]]
function QhunCore.CheckboxUiElement.new(label, storageIdentifyer, settings)
    -- call super class
    local instance = QhunCore.AbstractUiElement.new(storageIdentifyer)

    -- private properties
    instance._label = label
    instance._settings =
        qhunTableValueOrDefault(
        settings,
        {
            padding = 0,
            tooltip = nil
        }
    )
    instance._checkboxFrame = nil

    -- bind current values
    setmetatable(instance, QhunCore.CheckboxUiElement)

    return instance
end

-- set inheritance
setmetatable(QhunCore.CheckboxUiElement, {__index = QhunCore.AbstractUiElement})

--[[
    PUBLIC FUNCTIONS
]]
function QhunCore.CheckboxUiElement:render(storage, parentFrame)
    -- set initial value
    self._checked = self:getStorageValue(storage) or false

    -- create the wow frame object
    local checkboxFrame = CreateFrame("FRAME", nil, parentFrame)
    checkboxFrame:SetHeight(25)
    checkboxFrame:SetBackdropColor(0, 0, 0, .5)
    checkboxFrame:SetBackdropBorderColor(.5, .5, .5, 1)

    -- add label
    checkboxFrame.label = checkboxFrame:CreateFontString("$parentTitle", "ARTWORK")
    checkboxFrame.label:SetPoint("LEFT", checkboxFrame, "LEFT", 30, 0)
    checkboxFrame.label:SetFont("Fonts\\FRIZQT__.TTF", 11)
    checkboxFrame.label:SetText(self._label)

    -- container background texture
    checkboxFrame.background = checkboxFrame:CreateTexture(nil, "BACKGROUND")
    checkboxFrame.background:SetPoint("LEFT", checkboxFrame, "LEFT", 0, 0)
    checkboxFrame.background:SetTexture("Interface\\BUTTONS\\UI-CheckBox-Up")
    --checkboxFrame.background:SetAlpha(.8)

    -- enable mouse events
    checkboxFrame:EnableMouse(true)
    checkboxFrame:SetScript(
        "OnMouseDown",
        function()
            self:onClick(storage, checkboxFrame)
        end
    )
    checkboxFrame:SetScript(
        "OnEnter",
        function()
            self:onMouseOver(checkboxFrame)
        end
    )
    checkboxFrame:SetScript(
        "OnLeave",
        function()
            self:onMouseOut(checkboxFrame)
        end
    )

    -- draw checked frame
    checkboxFrame.checkedFrame = checkboxFrame:CreateTexture(nil, "BACKGROUND")
    checkboxFrame.checkedFrame:SetTexture("Interface\\BUTTONS\\UI-CheckBox-Check")
    checkboxFrame.checkedFrame:SetPoint("LEFT", checkboxFrame, "LEFT", 0, 0)

    -- set initial value
    if not self._checked then
        checkboxFrame.checkedFrame:Hide()
    end

    -- set width after the complete object
    checkboxFrame:SetWidth(35 + checkboxFrame.label:GetWidth())

    -- add extra padding and tooltip
    checkboxFrame._qhunCoreExtraPadding = self._settings.padding
    checkboxFrame.tooltipText = self._settings.tooltip

    -- add reference to class
    self._checkboxFrame = checkboxFrame

    -- return the created checkbox
    return checkboxFrame
end

-- will be triggered if the storage was reset
function QhunCore.CheckboxUiElement:onStorageReset(storage)
    -- get the value from the storage
    local value = self:getStorageValue(storage)

    -- reset the ui
    self._checked = value

    -- display checked frame
    if self._checkboxFrame and value then
        self._checkboxFrame.checkedFrame:Show()
    elseif self._checkboxFrame then
        self._checkboxFrame.checkedFrame:Hide()
    end
end

--[[
    PRIVATE FUNCTIONS
]]
function QhunCore.CheckboxUiElement:onMouseOver(checkboxFrame)
    -- show hover texture
    checkboxFrame.background:SetTexture("Interface\\BUTTONS\\UI-CheckBox-Highlight")
end

function QhunCore.CheckboxUiElement:onMouseOut(checkboxFrame)
    -- set to normal texture
    checkboxFrame.background:SetTexture("Interface\\BUTTONS\\UI-CheckBox-Up")
end

function QhunCore.CheckboxUiElement:onClick(storage, checkboxFrame)
    -- invert checkbox status
    self._checked = not self._checked

    -- display checked frame
    if self._checked then
        checkboxFrame.checkedFrame:Show()
    else
        checkboxFrame.checkedFrame:Hide()
    end

    -- store new value
    self:setStorageValue(storage, self._checked)
end
