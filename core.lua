--[[
    INIT FUNCTIONS
]]
-- bind all addon init events
QhunCore.Addon.coreInit()

-- init the singleton of the core event emitter
QhunCore.EventEmitter.new(true)

-- init the global timer
QhunCore.Timer.new(100):startTimer()
