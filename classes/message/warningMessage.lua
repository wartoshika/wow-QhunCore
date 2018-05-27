QhunCore.WarningMessage = {}
QhunCore.WarningMessage.__index = QhunCore.WarningMessage

-- constructor
function QhunCore.WarningMessage.new(text)
    -- call super class
    local instance = QhunCore.AbstractMessage.new()

    -- set private vars
    instance._channel = "CONSOLE"
    instance._text = text
    instance._sender = function(text)
        DEFAULT_CHAT_FRAME:AddMessage("Warning: " .. text, 1, 1, 0)
    end

    -- bind current values
    setmetatable(instance, QhunCore.WarningMessage)

    return instance
end

-- set inheritance
setmetatable(QhunCore.WarningMessage, {__index = QhunCore.AbstractMessage})
