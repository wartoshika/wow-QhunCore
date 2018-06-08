QhunCore.WarningMessage = {}
QhunCore.WarningMessage.__index = QhunCore.WarningMessage

-- constructor
function QhunCore.WarningMessage.new(text)
    -- call super class
    local instance = QhunCore.AbstractMessage.new(text)

    -- set private vars
    instance._channel = "CONSOLE"

    -- bind current values
    setmetatable(instance, QhunCore.WarningMessage)

    return instance
end

-- set inheritance
setmetatable(QhunCore.WarningMessage, {__index = QhunCore.AbstractMessage})

--[[
    PUBLIC FUNCTIONS
]]
function QhunCore.WarningMessage:send()
    DEFAULT_CHAT_FRAME:AddMessage("Warning: " .. self._text, 1, 1, 0)
    return true
end
