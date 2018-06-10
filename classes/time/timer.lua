QhunCore.Timer = {}
QhunCore.Timer.__index = QhunCore.Timer

-- constructor
function QhunCore.Timer.new(resolution)
    -- call super constructor
    local instance = QhunCore.Singleton.new()

    -- set properties
    instance._resolution = resolution
    instance._eventFrame = nil
    instance._timerCounter = 0
    instance._timerCallbackStack = {}

    -- bind instance to singleton
    instance:bindInstance("QhunCore.Timer")

    -- set class metatable
    setmetatable(instance, QhunCore.Timer)

    return instance
end

-- set inheritance
setmetatable(QhunCore.Timer, {__index = QhunCore.Singleton})

--[[
    PUBLIC FUNCTIONS
]]
function QhunCore.Timer:startTimer()
    -- create the timer frame
    self._eventFrame = CreateFrame("FRAME")

    -- enable the timer event
    self._eventFrame:SetScript(
        "OnUpdate",
        function(_, e)
            self:onTimerUpdate(e)
        end
    )
end

-- requests to be a part of the timer
--[[
    {
        callback: function,
        timeInMilliseconds: number,
        interval?: boolean
    }
]]
function QhunCore.Timer:requestTimerFrame(callback, timeInMilliseconds, interval)
    -- create a uuid
    local uuid = qhunUuid()

    -- add to timer callback stack
    self._timerCallbackStack[uuid] = {
        callback = callback,
        time = timeInMilliseconds,
        counter = 0,
        interval = interval
    }

    return uuid
end

-- cancel a requested timer frame by its uuid
function QhunCore.Timer:cancelTimerFrame(uuid)
    self._timerCallbackStack[uuid] = nil
end

--[[
    PRIVATE FUNCTIONS
]]
function QhunCore.Timer:onTimerUpdate(timePassed)
    -- add to timer value
    self._timerCounter = self._timerCounter + timePassed * 1000
    -- check for update test
    if self._timerCounter >= self._resolution then
        self:checkForUpdate(self._timerCounter)
        self._timerCounter = 0
    end
end

-- checks if a requested timer need a call
function QhunCore.Timer:checkForUpdate(millisecondsDone)
    for uuid, data in pairs(self._timerCallbackStack) do
        -- increment counter
        self._timerCallbackStack[uuid].counter = self._timerCallbackStack[uuid].counter + millisecondsDone
        -- check if the timer reached
        if self._timerCallbackStack[uuid].counter >= data.time then
            -- reset rounter
            self._timerCallbackStack[uuid].counter = 0

            -- execute the callback
            data.callback()

            -- check if the timer data should be removed
            if not data.interval then
                self._timerCallbackStack[uuid] = nil
            end
        end
    end
end
