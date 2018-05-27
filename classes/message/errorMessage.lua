QhunCore.ErrorMessage = {}
QhunCore.ErrorMessage.__index = QhunCore.ErrorMessage

-- constructor
function QhunCore.ErrorMessage.new(text)
    -- call super class
    local instance = QhunCore.AbstractMessage.new()

    -- set private vars
    instance._channel = "CONSOLE"
    instance._text = text
    instance._sender = function(text)
        DEFAULT_CHAT_FRAME:AddMessage("ERROR: " .. text, 1, 0, 0)
        error("ERROR: " .. text)
    end

    -- bind current values
    setmetatable(instance, QhunCore.ErrorMessage)

    return instance
end

-- set inheritance
setmetatable(QhunCore.ErrorMessage, {__index = QhunCore.AbstractMessage})
