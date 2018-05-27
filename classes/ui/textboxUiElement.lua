QhunCore.TextboxUiElement = {}
QhunCore.TextboxUiElement.__index = QhunCore.TextboxUiElement

-- constructor
--[[
    {
        label: string,
        storageIdentifyer: string,
        settings?: {
            boxWidth?: number = 20
            padding?: number = 0
        }
    }
]]
function QhunCore.TextboxUiElement.new(label, storageIdentifyer, settings)
    -- call super class
    local instance = QhunCore.AbstractUiElement.new(storageIdentifyer)

    -- bind properties
    instance._label = label
    instance._settings =
        qhunTableValueOrDefault(
        settings,
        {
            boxWidth = 20,
            padding = 0
        }
    )
    instance._textbox = nil

    -- bind current values
    setmetatable(instance, QhunCore.TextboxUiElement)

    return instance
end

-- set inheritance
setmetatable(QhunCore.TextboxUiElement, {__index = QhunCore.AbstractUiElement})

--[[
    PUBLIC FUNCTIONS
]]
function QhunCore.TextboxUiElement:render(storage, parentFrame)
    -- get initial value
    local initialValue = self:getStorageValue(storage)

    -- create a wrapper, lable and textbox
    local wrapper = CreateFrame("FRAME", nil, parentFrame)
    local textbox = CreateFrame("EditBox", nil, wrapper, "InputBoxTemplate")
    local label = wrapper:CreateFontString("$parentTitle", "ARTWORK")

    -- configure each object
    wrapper:SetHeight(25)

    label:SetPoint("LEFT", wrapper, "LEFT", 0, 0)
    label:SetFont("Fonts\\FRIZQT__.TTF", 11)
    label:SetText(self._label)

    wrapper:SetWidth(label:GetWidth() + self._settings.boxWidth + 10)

    textbox:SetAutoFocus(false)
    textbox:SetCursorPosition(0)
    textbox:SetFontObject("ChatFontNormal")
    textbox:SetText(initialValue or "")
    textbox:SetWidth(self._settings.boxWidth)
    textbox:SetPoint("LEFT", wrapper, "LEFT", label:GetWidth() + 10, 0)
    textbox:SetSize(wrapper:GetSize())

    -- apply final width
    wrapper:SetSize(label:GetWidth() + textbox:GetWidth(), 25)

    -- add extra padding
    wrapper._qhunCoreExtraPadding = self._settings.padding

    -- set handlers
    textbox:SetScript(
        "OnTextChanged",
        function()
            self:onTextChanged(storage, textbox)
        end
    )

    -- set the textbox reference on the class
    self._textbox = textbox

    return wrapper
end

-- will be triggered if the storage was reset
function QhunCore.TextboxUiElement:onStorageReset(storage)
    -- get the value from the storage
    local value = self:getStorageValue(storage)

    -- check if the textbox exists
    if not self._textbox then
        return
    end

    -- override the textbox value
    self._textbox:SetText(value)
end

-- handler for text changed events
function QhunCore.TextboxUiElement:onTextChanged(storage, textbox)
    -- update the storage
    self:setStorageValue(storage, textbox:GetText())
end
