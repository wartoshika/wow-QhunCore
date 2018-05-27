if not IsAddOnLoaded("QhunUnitTest") then
    return
end

QhunCore.Test.Translation = {}
QhunCore.Test.Translation.__index = QhunCore.Test.Translation

-- constructor
function QhunCore.Test.Translation.new()
    -- call super class
    local instance = QhunUnitTest.Base.new()

    instance._deLanguage = {
        TEST_KEY = "Test Deutsch",
        ANOTHER_TEST_KEY = "_name_ _value_"
    }
    instance._enLanguage = {
        TEST_KEY = "Test English",
        ANOTHER_TEST_KEY = "_name_ _value_"
    }
    instance._mock = {
        GetLocale = nil
    }

    -- bind current values
    setmetatable(instance, QhunCore.Test.Translation)

    return instance
end

-- set inheritance
setmetatable(QhunCore.Test.Translation, {__index = QhunUnitTest.Base})

--[[
    SETUP
]]
function QhunCore.Test.Translation:setupClass()
    -- override the global GetLocale function to mock the result of the game client language
    self._mock.GetLocale = GetLocale
end

function QhunCore.Test.Translation:teardownClass()
    -- restore the GetLocale function
    GetLocale = self._mock.GetLocale
end

--[[
    TESTS
]]
function QhunCore.Test.Translation:canBeInstantiated()
    local instance = QhunCore.Translation.new()
    self:assertClassOf(instance, QhunCore.Translation)
end

function QhunCore.Test.Translation:registerLanguage()
    local instance = QhunCore.Translation.new()

    -- first check that an empty instance should not have any
    -- default languages
    self:assertEqual(instance._fallback, "", "An empty translation instance should have no fallback language!")

    -- test register a dump language
    instance:registerLanguage("de", self._deLanguage)

    -- language should be available
    self:assertEqual(instance._de, self._deLanguage)

    -- there should be no fallback
    self:assertEqual(
        instance._fallback,
        "",
        "Fallback language should be not set buring a register without the fallback flag"
    )

    -- now register a fallback language
    instance:registerLanguage("en", self._enLanguage, true)

    -- check equal
    self:assertEqual(instance._en, self._enLanguage)

    -- fallback must be en
    self:assertEqual(instance._fallback, "en", "en was not set as fallback!")
end

function QhunCore.Test.Translation:translateNormal()
    local instance = QhunCore.Translation.new()

    -- register two languages
    instance:registerLanguage("de", self._deLanguage)
    instance:registerLanguage("en", self._enLanguage, true)

    -- assume the game client language is de
    GetLocale = function()
        return "deDE"
    end

    -- assert the translation result
    self:assertEqual(instance:translate("TEST_KEY"), "Test Deutsch", "the choosen language was wrong")

    -- and now asume en
    GetLocale = function()
        return "enUS"
    end

    -- assert the translation result
    self:assertEqual(instance:translate("TEST_KEY"), "Test English", "the choosen language was wrong")

    -- now a fallback test
    GetLocale = function()
        return "noEX"
    end

    -- fallback should be english!
    self:assertEqual(
        instance:translate("TEST_KEY"),
        "Test English",
        "the choosen language at the fallback test was wrong"
    )
end

function QhunCore.Test.Translation:translateVariables()
    local instance = QhunCore.Translation.new()

    -- register a language
    instance:registerLanguage("de", self._deLanguage)

    -- assume the game client language is de
    GetLocale = function()
        return "deDE"
    end

    -- define the var object
    local vars = {
        name = "testname",
        value = 15
    }

    -- test translate with vars
    self:assertEqual(
        instance:translate("ANOTHER_TEST_KEY", vars),
        "testname 15",
        "translation with variables was wrong!"
    )

    -- now translate with partitial vars
    self:assertEqual(
        instance:translate(
            "ANOTHER_TEST_KEY",
            {
                name = "testname"
            }
        ),
        "testname _value_",
        "translation with partitial vars was wrong!"
    )

    -- and finally without vars
    self:assertEqual(instance:translate("ANOTHER_TEST_KEY"), "_name_ _value_", "translation without vars was wrong!")
end

function QhunCore.Test.Translation:warningsAndErrors()
    local instance = QhunCore.Translation.new()

    -- try to translate without any existing languages in the storage
    self:assertError(
        function(instance)
            -- this should throw an error
            instance:translate("TEST_KEY")
        end,
        {
            instance
        },
        "Translation should have errored when no language was set during the first translation"
    )
end

function QhunCore.Test.Translation:fallback()
    local instance = QhunCore.Translation.new()

    -- register languages
    instance:registerLanguage("de", self._deLanguage)
    instance:registerLanguage(
        "en",
        {
            FALLBACK_TEST_KEY = "value"
        },
        true
    )

    -- asume game client de
    GetLocale = function()
        return "deDE"
    end

    -- now test a non existing de value with en fallback
    self:assertEqual(instance:translate("FALLBACK_TEST_KEY"), "value", "fallback value was not used during translation")
end

function QhunCore.Test.Translation:translationLinks()
    local instance = QhunCore.Translation.new()
    instance:registerLanguage(
        "de",
        {
            TEST_ENTRY = "test",
            LINKED_ENTRY = "@@TEST_ENTRY"
        }
    )

    -- asume game client lang = de
    GetLocale = function()
        return "deDE"
    end

    -- check for correct link replacement
    self:assertEqual(instance:translate("LINKED_ENTRY"), "test", "linked translation does not result correctly")
end
