QhunCore.TextUiElement = {}
QhunCore.TextUiElement.__index = QhunCore.TextUiElement

-- constructor
--[[
    {
        text: string,
        settings?: {
            fontSize?: number = 11,
            color?: {
                r: number = 1,
                g: number = 1,
                b: number = 1
            },
            -- adds some extra padding to this element
            padding?: number = 0
        }
    }
]]
function QhunCore.TextUiElement.new(text, settings)
    -- call super class (no storage for this object)
    local instance = QhunCore.AbstractUiElement.new(nil)

    -- set private vars
    instance._text = text
    instance._settings =
        qhunTableValueOrDefault(
        settings,
        {
            fontSize = 11,
            color = {r = 1, g = 1, b = 1},
            padding = 0
        }
    )
    instance._textFrame = nil

    -- bind current values
    setmetatable(instance, QhunCore.TextUiElement)

    return instance
end

-- set inheritance
setmetatable(QhunCore.TextUiElement, {__index = QhunCore.AbstractUiElement})

--[[
    PUBLIC FUNCTIONS
]]
-- renders a text element
function QhunCore.TextUiElement:render(_, parentFrame)
    -- create a font string at the parentFrame
    self._textFrame = parentFrame:CreateFontString()

    -- update the view
    self:update(self._text, self._settings)

    return self._textFrame
end

-- will be triggered if the storage was reset
function QhunCore.TextUiElement:onStorageReset()
    -- nothing to do here
    return
end

-- will be called if the element should be updated
function QhunCore.TextUiElement:update(text, settings)

    -- apply settings
    self._text = text
    self._settings =
        qhunTableValueOrDefault(
        settings,
        {
            fontSize = 11,
            color = {r = 1, g = 1, b = 1},
            padding = 0
        }
    )

    -- set font, size and other options
    self._textFrame:SetFont("Fonts\\FRIZQT__.TTF", self._settings.fontSize)
    self._textFrame:SetText(self._text)
    self._textFrame:SetJustifyH("LEFT")
    self._textFrame:SetTextColor(self._settings.color.r, self._settings.color.g, self._settings.color.b)

    -- add extra padding
    self._textFrame._qhunCoreExtraPadding = self._settings.padding
end
