QhunCore.ConsoleMessage = {}
QhunCore.ConsoleMessage.__index = QhunCore.ConsoleMessage

-- constructor
--[[
    {
        text: string,
        colorRGB?: {
            r: number,
            g: number,
            b: number
        } default {r:1, g:1, b:1}
    }
]]
function QhunCore.ConsoleMessage.new(text, colorRGB)
    -- call super class
    local instance = QhunCore.AbstractMessage.new(text)

    -- set private vars
    instance._channel = "CONSOLE"
    instance._colorRGB =
        qhunTableValueOrDefault(
        colorRGB,
        {
            r = 1,
            g = 1,
            b = 1
        }
    )

    -- bind current values
    setmetatable(instance, QhunCore.ConsoleMessage)

    return instance
end

-- set inheritance
setmetatable(QhunCore.ConsoleMessage, {__index = QhunCore.AbstractMessage})

--[[
    PUBLIC FUNCTIONS
]]
function QhunCore.ConsoleMessage:send()
    DEFAULT_CHAT_FRAME:AddMessage(self._text, self._colorRGB.r, self._colorRGB.b, self._colorRGB.g)
    return true
end
