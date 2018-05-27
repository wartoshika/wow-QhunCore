if not IsAddOnLoaded("QhunUnitTest") then
    return
end

QhunCore.Test.EventEmitter = {}
QhunCore.Test.EventEmitter.__index = QhunCore.Test.EventEmitter

-- constructor
function QhunCore.Test.EventEmitter.new()
    -- call super class
    local instance = QhunUnitTest.Base.new()

    -- bind current values
    setmetatable(instance, QhunCore.Test.EventEmitter)

    return instance
end

-- set inheritance
setmetatable(QhunCore.Test.EventEmitter, {__index = QhunUnitTest.Base})

--[[
    TESTS
]]
function QhunCore.Test.EventEmitter:canBeInstantiated()
    local instance = QhunCore.EventEmitter.new()
    self:assertClassOf(instance, QhunCore.EventEmitter)
end

function QhunCore.Test.EventEmitter:addAndEmitEvent()
    -- create an instance
    local eventEmitter = QhunCore.EventEmitter.new()
    local eventWasFired = false

    -- add a test event
    local uuid =
        eventEmitter:on(
        "TEST_EVENT",
        function()
            eventWasFired = true
        end
    )

    -- event should be registered
    self:assertTableSize(eventEmitter._eventCallbackStack.TEST_EVENT, 1, "Event was not correctly registered")

    -- test fire the event
    eventEmitter:emit("TEST_EVENT")

    -- expect eventWasFired to be true
    self:assertTrue(eventWasFired, "Event was not fired during emit() method")
end

function QhunCore.Test.EventEmitter:removeEvent()
    local eventEmitter = QhunCore.EventEmitter.new()
    local eventWasFired = false

    -- add one
    local id =
        eventEmitter:on(
        "TEST_EVENT",
        function()
            eventWasFired = true
        end
    )

    -- id should be a uuid string
    self:assertTypeof(id, "string")
    self:assertTableSize(eventEmitter._eventCallbackStack.TEST_EVENT, 1, "Event was not correctly registered")

    -- now remove it
    eventEmitter:remove("TEST_EVENT", id)

    -- size should be 0 again
    self:assertTableSize(eventEmitter._eventCallbackStack.TEST_EVENT, 0, "Event was not correctly removed!")

    -- last check: fire the event.
    eventEmitter:emit("TEST_EVENT")

    -- the eventWasFired variable MUST be false
    self:assertFalse(eventWasFired, "Event was fired, expected to be not fired after beeing removed!")
end

function QhunCore.Test.EventEmitter:emitMultipleCallbacks()
    local eventEmitter = QhunCore.EventEmitter.new()
    local emitted1, emitted2, emitted3 = false, false, false

    -- add one
    eventEmitter:on(
        "TEST_EVENT",
        function()
            emitted1 = true
        end
    )

    -- add another to the same event
    eventEmitter:on(
        "TEST_EVENT",
        function()
            emitted2 = true
        end
    )

    -- add another but a different event
    eventEmitter:on(
        "TEST_EVENT_NOT_CALLED",
        function()
            emitted3 = true
        end
    )

    -- test the table size
    self:assertTableSize(eventEmitter._eventCallbackStack.TEST_EVENT, 2, "Events were not correctly registered")

    -- emit
    eventEmitter:emit("TEST_EVENT")

    -- check boolean values
    self:assertTrue(emitted1, "Event 1 was not called")
    self:assertTrue(emitted2, "Event 2 was not called")
    self:assertFalse(emitted3, "Event TEST_EVENT_NOT_CALLED was fired but this was not expected!")
end
