if not IsAddOnLoaded("QhunUnitTest") then
    return
end

QhunCore.Test.Function = {}
QhunCore.Test.Function.__index = QhunCore.Test.Function

-- constructor
function QhunCore.Test.Function.new()
    -- call super class
    local instance = QhunUnitTest.Base.new()

    -- bind current values
    setmetatable(instance, QhunCore.Test.Function)

    return instance
end

-- set inheritance
setmetatable(QhunCore.Test.Function, {__index = QhunUnitTest.Base})

--[[
    TESTS
]]
function QhunCore.Test.Function:qhunTableHasValue()
    local testTable = {"teststring", 15}
    local otherTestTable = {KEY = testTable, OTHER_KEY = 15, "value"}

    -- make successfull test asserts
    self:assertTrue(qhunTableHasValue(testTable, 15))
    self:assertTrue(qhunTableHasValue(testTable, "teststring"))
    self:assertTrue(qhunTableHasValue(otherTestTable, testTable))
    self:assertTrue(qhunTableHasValue(otherTestTable, 15))
    self:assertTrue(qhunTableHasValue(otherTestTable, "value"))

    -- falsey tests
    self:assertFalse(qhunTableHasValue(testTable, "non existing"))
    self:assertFalse(qhunTableHasValue(otherTestTable, 19))
    self:assertFalse(qhunTableHasValue(otherTestTable, "KEY"))
end

function QhunCore.Test.Function:qhunRound()
    self:assertEqual(qhunRound(15), 15)
    self:assertEqual(qhunRound(15.125), 15)
    self:assertEqual(qhunRound(15.9), 16)
    self:assertEqual(qhunRound(15.125, 2), 15.13)
    self:assertEqual(qhunRound(15.124, 2), 15.12)
    self:assertEqual(qhunRound(15.123456, 9), 15.123456)
end

function QhunCore.Test.Function:qhunUuid()
    self:assertTypeof(qhunUuid(), "string")

    -- some randomisation tests
    self:assertNotEqual(qhunUuid(), qhunUuid())
    self:assertNotEqual(qhunUuid(), qhunUuid())
    self:assertNotEqual(qhunUuid(), qhunUuid())
    self:assertNotEqual(qhunUuid(), qhunUuid())
    self:assertNotEqual(qhunUuid(), qhunUuid())
    self:assertNotEqual(qhunUuid(), qhunUuid())

    -- length check
    self:assertStringLength(qhunUuid(), 36, "the uuid should have exactly 36 characters")
end

function QhunCore.Test.Function:qhunTableGetIndexByValue()
    local tbl = {
        INDEX_1 = 1,
        INDEX_2 = true,
        INDEX_3 = "string",
        "noindex",
        true
    }

    -- successfull tests
    self:assertNumberGreaterThanEqual(qhunTableGetIndexByValue(tbl, 1), 1)
    self:assertNumberGreaterThanEqual(qhunTableGetIndexByValue(tbl, "string"), 1)
    self:assertNumberGreaterThanEqual(qhunTableGetIndexByValue(tbl, "noindex"), 1)
    self:assertNumberGreaterThanEqual(qhunTableGetIndexByValue(tbl, true), 1)

    -- error tests
    self:assertEqual(
        qhunTableGetIndexByValue(tbl, "non_existing_value"),
        nil,
        "A non existing value should have no index"
    )
end

function QhunCore.Test.Function:qhunDerivedFrom()
    self:assertTrue(qhunDerivedFrom(self, QhunUnitTest.Base))
    self:assertFalse(qhunDerivedFrom(self, QhunCore.Test.Function))
end

function QhunCore.Test.Function:qhunInstanceOf()
    self:assertTrue(qhunInstanceOf(self, QhunCore.Test.Function))
    self:assertFalse(qhunInstanceOf(self, QhunUnitTest.Base))
end

function QhunCore.Test.Function:qhunTableValueOrDefault()
    local currentTable = {
        test = {
            otherTest = true
        },
        value = "teststring"
    }

    self:assertTableSimilar(qhunTableValueOrDefault({}, currentTable), currentTable)
    self:assertTableSimilar(
        qhunTableValueOrDefault(
            {
                test = "overwritten!"
            },
            currentTable
        ),
        {
            test = "overwritten!",
            value = "teststring"
        }
    )
end

function QhunCore.Test.Function:qhunGetTableWithDot()
    local flatTable = {
        a = "b",
        c = {
            d = "e"
        }
    }
    local deepTable = {
        a = {
            val = true,
            b = {
                c = {},
                f = {
                    a = "test",
                    b = true
                },
                test = "teststring"
            }
        }
    }

    -- flat table
    self:assertEqual(qhunGetTableWithDot(flatTable, "a"), "b")
    self:assertEqual(qhunGetTableWithDot(flatTable, "c.d"), "e")
    self:assertNil(qhunGetTableWithDot(flatTable, "f"))
    self:assertNil(qhunGetTableWithDot(flatTable, "c.q"))

    -- deep table
    self:assertEqual(qhunGetTableWithDot(deepTable, "a.val"), true)
    self:assertEqual(qhunGetTableWithDot(deepTable, "a.b.f.b"), true)
    self:assertEqual(qhunGetTableWithDot(deepTable, "a.b.test"), "teststring")
    self:assertNil(qhunGetTableWithDot(deepTable, "a.b.f.q"))

    -- no table
    self:assertNil(qhunGetTableWithDot(nil, "a.b.c"))
end

function QhunCore.Test.Function:qhunSetTableWithDot()
    local flatTable = {
        a = "b",
        c = {
            d = "e"
        }
    }
    local deepTable = {
        a = {
            val = true,
            b = {
                c = {},
                f = {
                    a = "test",
                    b = true
                },
                test = "teststring"
            }
        }
    }

    -- flat table
    qhunSetTableWithDot(flatTable, "a", false)
    self:assertTableSimilar(
        flatTable,
        {
            a = false,
            c = {d = "e"}
        }
    )
    qhunSetTableWithDot(flatTable, "c.d", "false")
    self:assertTableSimilar(
        flatTable,
        {
            a = false,
            c = {d = "false"}
        }
    )
    qhunSetTableWithDot(flatTable, "c.q", true)
    self:assertTableSimilar(
        flatTable,
        {
            a = false,
            c = {d = "false", q = true}
        }
    )
    qhunSetTableWithDot(flatTable, "new", "test")
    self:assertTableSimilar(
        flatTable,
        {
            new = "test",
            a = false,
            c = {d = "false", q = true}
        }
    )

    -- deep table
    qhunSetTableWithDot(deepTable, "a.b.f.b", false)
    self:assertTableSimilar(
        deepTable,
        {
            a = {
                val = true,
                b = {
                    c = {},
                    f = {
                        a = "test",
                        b = false
                    },
                    test = "teststring"
                }
            }
        }
    )
    qhunSetTableWithDot(deepTable, "a.b.c.q", {})
    self:assertTableSimilar(
        deepTable,
        {
            a = {
                val = true,
                b = {
                    c = {
                        q = {}
                    },
                    f = {
                        a = "test",
                        b = false
                    },
                    test = "teststring"
                }
            }
        }
    )
end

function QhunCore.Test.Function:qhunCloneTable()
    local table1 = {a = true, test = "test"}
    local table2 = {link = table1}
    local table3 = {a = {b = {c = {d = "test"}}}}

    self:assertNotEqual(qhunCloneTable(table1), table1, "cloning a table should not share the same link (metatable)")
    self:assertTableSimilar(
        qhunCloneTable(table1),
        {
            a = true,
            test = "test"
        }
    )

    -- now a link test
    self:assertNotEqual(qhunCloneTable(table2), table2, "cloning a table should not share the same link (metatable)")
    self:assertTableSimilar(
        qhunCloneTable(table2),
        {
            -- link should not be saved
            link = {
                a = true,
                test = "test"
            }
        }
    )

    -- deep clone test
    self:assertNotEqual(qhunCloneTable(table3), table3, "cloning a table should not share the same link (metatable)")
    self:assertTableSimilar(qhunCloneTable(table3), {a = {b = {c = {d = "test"}}}})
end

function QhunCore.Test.Function:qhunGetTableKeys()
    local table1 = {TEST = true, OTHER_TEST = "test"}

    self:assertTableSimilar(qhunGetTableKeys(table1), {"TEST", "OTHER_TEST"})
end
