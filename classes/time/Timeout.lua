QhunCore.Timeout = {}
QhunCore.Timeout.__index = QhunCore.Timeout

-- a timer function that allows to execute a callback function after a given amount of time
--[[
    {
        -- the amount of milliseconds that passes before the callback function
        -- will be called
        timeInMilliseconds: number
    }
]]
function QhunCore.Timeout.new(timeInMilliseconds)
    local instance = {
        _time = timeInMilliseconds,
        _timerUuid = nil
    }

    setmetatable(instance, QhunCore.Timeout)

    return instance
end

--[[
    PUBLIC FUNCTIONS
]]
-- executes the given callback after the amount of time passed
--[[
    {
        callback: function
    }
]]
function QhunCore.Timeout:start(callback)
    self._timerUuid = QhunCore.Timer.getInstance("QhunCore.Timer"):requestTimerFrame(callback, self._time)
end
