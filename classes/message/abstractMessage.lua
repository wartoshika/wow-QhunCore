QhunCore.AbstractMessage = {}
QhunCore.AbstractMessage.__index = QhunCore.AbstractMessage

-- constructor
function QhunCore.AbstractMessage.new()
    -- private properties
    local instance = {
        _channel = nil,
        _text = "",
        _sender = nil
    }

    setmetatable(instance, QhunCore.AbstractMessage)

    return instance
end

--[[
    PUBLIC ABSTRACT FUNCTIONS
]]
-- get the current channel
function QhunCore.AbstractMessage:getChannel()
    return self._channel
end

-- send the message
function QhunCore.AbstractMessage:send()
    -- using the given sender function from the client class
    if type(self._sender) ~= "function" then
        return
    end

    return self._sender(self._text)
end
