QhunCore.ErrorMessage = {}
QhunCore.ErrorMessage.__index = QhunCore.ErrorMessage

-- constructor
function QhunCore.ErrorMessage.new(text)
    -- call super class
    local instance = QhunCore.AbstractMessage.new(text)

    -- set private vars
    instance._channel = "CONSOLE"

    -- bind current values
    setmetatable(instance, QhunCore.ErrorMessage)

    return instance
end

-- set inheritance
setmetatable(QhunCore.ErrorMessage, {__index = QhunCore.AbstractMessage})

--[[
    PUBLIC FUNCTIONS
]]
function QhunCore.ErrorMessage:send()
    DEFAULT_CHAT_FRAME:AddMessage("ERROR: " .. self._text, 1, 0, 0)
    error("ERROR: " .. self._text)

    -- error should stop interpreting, this is just sugar
    return true
end
