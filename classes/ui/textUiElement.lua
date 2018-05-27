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
    local text = parentFrame:CreateFontString()

    -- set font, size and other options
    text:SetFont("Fonts\\FRIZQT__.TTF", self._settings.fontSize)
    text:SetText(self._text)
    text:SetJustifyH("LEFT")
    text:SetTextColor(self._settings.color.r, self._settings.color.g, self._settings.color.b)

    -- add extra padding
    text._qhunCoreExtraPadding = self._settings.padding

    return text
end

-- will be triggered if the storage was reset
function QhunCore.TextUiElement:onStorageReset()
    -- nothing to do here
    return
end
