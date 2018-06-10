QhunCore.Interval = {}
QhunCore.Interval.__index = QhunCore.Interval

-- a timer function that allows to execute a callback function in repeating time intervals
--[[
    {
        -- the amount of milliseconds that passes before the callback function
        -- will be called
        timeInMilliseconds: number
    }
]]
function QhunCore.Interval.new(timeInMilliseconds)
    local instance = {
        _time = timeInMilliseconds,
        _timerUuid = nil
    }

    setmetatable(instance, QhunCore.Interval)

    return instance
end

--[[
    PUBLIC FUNCTIONS
]]
-- executes the given callback in the defined interval
--[[
    {
        callback: function
    }
]]
function QhunCore.Interval:start(callback)
    self._timerUuid = QhunCore.Timer.getInstance("QhunCore.Timer"):requestTimerFrame(callback, self._time, true)
end

-- stops the interval execution for this callback function
function QhunCore.Interval:complete()
    QhunCore.Timer.getInstance("QhunCore.Timer"):cancelTimerFrame(self._timerUuid)
end
