QhunCore.EventEmitter = {}
QhunCore.EventEmitter.__index = QhunCore.EventEmitter

-- private static properties
local qhunCoreEmitterInstance = nil
--[[
    CURRENT EVENTS:

    STORAGE_UNCOMMITTED_CHANGED     (identifyer, value)
    STORAGE_COMMITTED               (allCommitedChanges)
    STORAGE_RESET                   ()
]]
-- constructor
function QhunCore.EventEmitter.new(isCore)
    -- private properties
    local instance = {
        _eventCallbackStack = {}
    }

    setmetatable(instance, QhunCore.EventEmitter)

    -- save instance if the event emitter is the core event emitter
    if isCore == true then
        qhunCoreEmitterInstance = instance
    end
    return instance
end

-- get the qhun core event emitter instance
function QhunCore.EventEmitter.getCoreInstance()
    return qhunCoreEmitterInstance
end

-- allow the override of the core event emitter instance
function QhunCore.EventEmitter.overrideCoreInstance(instance)
    qhunCoreEmitterInstance = instance
end

--[[
    PUBLIC FUNCTIONS
]]
-- registers an event
--[[
    {
        eventName: string,
        callback: function
    }
    return uniqueReference or false
]]
function QhunCore.EventEmitter:on(eventName, callback)
    -- type check
    if type(callback) ~= "function" then
        return false
    end

    -- init
    if type(self._eventCallbackStack[eventName]) ~= "table" then
        self._eventCallbackStack[eventName] = {}
    end

    -- generate a reference
    local uniqueId = qhunUuid()

    -- add to the stack
    self._eventCallbackStack[eventName][uniqueId] = callback

    return uniqueId
end

-- removes a callback from the event stack
--[[
    {
        eventName: string,
        uniqueReference: string
    }
    returns true or false
]]
function QhunCore.EventEmitter:remove(eventName, uniqueReference)
    if type(self._eventCallbackStack[eventName][uniqueReference]) == "function" then
        -- nullify the value
        self._eventCallbackStack[eventName][uniqueReference] = nil
    end

    return false
end

-- emits a given event name and passes arguments to the callback function
function QhunCore.EventEmitter:emit(eventName, ...)
    -- debug print
    qhunDebug('[QhunCore.EventEmitter] Event "' .. eventName .. '" emitted.')
    
    -- test if there are registered callbacks
    if type(self._eventCallbackStack[eventName]) ~= "table" then
        -- no callbacks available
        return
    end

    -- iterate over every callback
    for _, callback in pairs(self._eventCallbackStack[eventName]) do
        callback(...)
    end
end
