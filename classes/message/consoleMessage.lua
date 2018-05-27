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
    -- default color value
    if type(colorRGB) ~= "table" then
        colorRGB = {r = 1, g = 1, b = 1}
    end

    -- call super class
    local instance = QhunCore.AbstractMessage.new()

    -- set private vars
    instance._channel = "CONSOLE"
    instance._text = text
    instance._sender = function(text)
        DEFAULT_CHAT_FRAME:AddMessage(text, colorRGB.r, colorRGB.b, colorRGB.g)
    end

    -- bind current values
    setmetatable(instance, QhunCore.ConsoleMessage)

    return instance
end

-- set inheritance
setmetatable(QhunCore.ConsoleMessage, {__index = QhunCore.AbstractMessage})
