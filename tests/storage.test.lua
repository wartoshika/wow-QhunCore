if not IsAddOnLoaded("QhunUnitTest") then
    return
end

QhunCore.Test.Storage = {}
QhunCore.Test.Storage.__index = QhunCore.Test.Storage

-- constructor
function QhunCore.Test.Storage.new()
    -- call super class
    local instance = QhunUnitTest.Base.new()
    instance._wrappedEventEmitter = nil
    instance._originalEventEmitter = nil

    -- bind current values
    setmetatable(instance, QhunCore.Test.Storage)

    return instance
end

-- set inheritance
setmetatable(QhunCore.Test.Storage, {__index = QhunUnitTest.Base})

--[[
    SETUP
]]
function QhunCore.Test.Storage:setup()
    -- wrapp the event emitter to test if a event was emitted
    self._originalEventEmitter = QhunCore.EventEmitter.getCoreInstance()
    self._wrappedEventEmitter = QhunUnitTest.Wrapper.new(self._originalEventEmitter)
    QhunCore.EventEmitter.overrideCoreInstance(self._wrappedEventEmitter)
end

function QhunCore.Test.Storage:teardown()
    -- clear the global storage for every test
    QhunCoreGlobalStorage.unittest = {}
    QhunCoreCharacterStorage.unittest = {}

    -- restore event emitter
    QhunCore.EventEmitter.overrideCoreInstance(self._originalEventEmitter)
end

--[[
    TESTS
]]
function QhunCore.Test.Storage:canBeInstantiated()
    local perChar = QhunCore.Storage.new("unittest", "test", true)
    local global = QhunCore.Storage.new("unittest", "test", false)

    self:assertClassOf(perChar, QhunCore.Storage, "PerCharacter storage is not instantiated")
    self:assertClassOf(global, QhunCore.Storage, "Global storage is not instantiated")

    -- test the initial setups
    -- start with perChar
    self:assertTrue(perChar._perCharacter, "storage perChar flag is false!")

    -- the global wow storage table should have been created
    self:assertTypeof(QhunCoreCharacterStorage.unittest.test, "table")

    -- and the size must be 0
    self:assertTableSize(QhunCoreCharacterStorage.unittest.test, 0, "the initial storage size is not 0 (per character)")

    -- now the global storage
    self:assertFalse(global._perCharacter, "storage perChar flag is true for the global storage!")
    self:assertTypeof(QhunCoreGlobalStorage.unittest.test, "table")
    self:assertTableSize(QhunCoreGlobalStorage.unittest.test, 0, "the initial storage size is not 0 (global)")
end

function QhunCore.Test.Storage:setAndGetPerCharacter()
    self:_getAndSet(QhunCore.Storage.new("unittest", "test", true))
end

function QhunCore.Test.Storage:setAndGetGlobal()
    self:_getAndSet(QhunCore.Storage.new("unittest", "test", false))
end

function QhunCore.Test.Storage:commitTestPerCharacter()
    self:_commitTest(QhunCore.Storage.new("unittest", "commitTest", true), QhunCoreCharacterStorage)
end

function QhunCore.Test.Storage:commitTestGlobal()
    self:_commitTest(QhunCore.Storage.new("unittest", "commitTest", false), QhunCoreGlobalStorage)
end

--[[
    PRIVATE FUNCTIONS
]]
function QhunCore.Test.Storage:_getAndSet(storage)
    -- get to an empty storage shoule result in a nil value
    self:assertNil(storage:get("TEST"), "a non existing value in the storage should be NIL")

    local testValue = {
        test = {
            t = 1
        },
        k = true
    }

    -- insert a value
    storage:set("TEST", testValue)
    self:assertEqual(
        storage:get("TEST"),
        testValue,
        "a simple get results in a different output of the original object"
    )

    -- test a dotted value and identifyer
    storage:set("TEST.k", false)
    self:assertTableSimilar(
        storage:get("TEST"),
        {
            test = {t = 1},
            k = false
        }
    )

    -- get test with dot for a deeper value
    self:assertEqual(storage:get("TEST.test.t"), 1, "deep storage get test failed")
end

function QhunCore.Test.Storage:_commitTest(storage, commitedAccessor)
    -- first add some values to the storage
    storage:set("TEST", true)

    -- the set call should not have commited and value
    self:assertTableSize(
        commitedAccessor["unittest"]["commitTest"],
        0,
        "storage set should not commit the values itself!"
    )

    -- a storage uncommit change event should have been called
    self:assertMethodCalledWith(
        self._wrappedEventEmitter,
        "emit",
        {
            "STORAGE_UNCOMMITTED_CHANGED",
            "TEST",
            true
        },
        "event emitter doesn't emit an event after setting a value"
    )

    -- commit event should not have been called
    self:assertMethodNotCalledWith(
        self._wrappedEventEmitter,
        "emit",
        {
            "STORAGE_COMMITTED",
            storage._uncommitedChanges
        },
        "storage should not call commit event them set but not commit the values"
    )

    -- temp save the uncommited values for later checks
    local uncommited = storage._uncommitedChanges

    -- now commit the values
    storage:commit()

    -- tests if the values are commited
    self:assertTableSize(commitedAccessor["unittest"]["commitTest"], 1, "the values are not commited!")

    -- the commit event should have been called
    self:assertMethodCalledWith(
        self._wrappedEventEmitter,
        "emit",
        {
            "STORAGE_COMMITTED",
            uncommited
        },
        "storage commit doesn't emit the commited event"
    )
end
