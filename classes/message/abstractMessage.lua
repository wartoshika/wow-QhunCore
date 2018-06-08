QhunCore.AbstractMessage = {}
QhunCore.AbstractMessage.__index = QhunCore.AbstractMessage

-- constructor
--[[
    {
        -- the message to send
        text: string
    }
]]
function QhunCore.AbstractMessage.new(text)
    -- private properties
    local instance = {
        _channel = nil,
        _text = text
    }

    setmetatable(instance, QhunCore.AbstractMessage)

    return instance
end

--[[
    PUBLIC ABSTRACT FUNCTIONS
]]
-- send the message
function QhunCore.AbstractMessage:send()
    QhunCore.ErrorMessage.new("The send() method should be implemented in the child class!")
    return
end

--[[
    PUBLIC FUNCTIONS
]]
-- get the current channel
function QhunCore.AbstractMessage:getChannel()
    return self._channel
end
