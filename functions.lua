--[[
    CORE FUNCTION DECLARATION
]]
-- prints every var onto the console
function qhunDump(dumpable)
    local tablePrint

    -- @see https://gist.github.com/stuby/5445834#file-rprint-lua
    tablePrint = function(s, l, i) -- recursive Print (structure, limit, indent)
        l = (l) or 1000
        i = i or "" -- default item limit, indent string
        if (l < 1) then
            print "ERROR: Item limit reached."
            return l - 1
        end
        local ts = type(s)
        if (ts ~= "table") then
            print(i, ts, s)
            return l - 1
        end
        print(i, ts) -- print "table"
        for k, v in pairs(s) do -- print "[KEY] VALUE"
            l = tablePrint(v, l, i .. "-[" .. tostring(k) .. "]")
            if (l < 0) then
                break
            end
        end
        return l
    end

    -- setup the switch for special types
    local typeSwitch = {
        table = tablePrint
    }

    -- default case
    if type(typeSwitch[type(dumpable)]) ~= "function" then
        -- the var should have a printable interface
        print(type(dumpable) .. ": " .. tostring(dumpable))
        return
    end

    -- execute the switch
    return typeSwitch[type(dumpable)](dumpable)
end

-- get all keys from a table
function qhunGetTableKeys(tbl)
    local keys = {}
    for key, _ in pairs(tbl) do
        -- insert at beginning to preserve order
        table.insert(keys, 1, key)
    end
    return keys
end

-- a function that prints debug information onto the console if the debug mode is enabled
function qhunDebug(text)
    if QHUN_DEBUG then
        QhunCore.ConsoleMessage.new("[DEBUG] " .. text, {r = .6, b = .6, g = .6}):send()
    end
end

-- check if the given table has a given value
-- this is a one dimensional check
function qhunTableHasValue(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end

    return false
end

-- rounds the given number
function qhunRound(number, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(number * mult + 0.5) / mult
end

-- generates a random uuid style string
-- @see https://gist.github.com/jrus/3197011
function qhunUuid()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(
        template,
        "[xy]",
        function(c)
            local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format("%x", v)
        end
    )
end

-- get the table index by a value
function qhunTableGetIndexByValue(table, value)
    local counter = 1
    for k, v in pairs(table) do
        if v == value then
            return counter
        end
        counter = counter + 1
    end

    return nil
end

-- checks if the given object is derived from class
function qhunDerivedFrom(object, class)
    local metaDirectClass = getmetatable(object)

    if not metaDirectClass then
        return false
    end

    local metaDirevedClass = getmetatable(metaDirectClass.__index)

    if not metaDirevedClass then
        return false
    end

    return metaDirevedClass.__index == class
end

-- checks if the given object is an instanceof class
function qhunInstanceOf(object, class)
    local meta = getmetatable(object)

    if not meta then
        return false
    end

    return meta.__index == class
end

-- returns a table that contains all original table data and
-- defaultValues will replace nil values
function qhunTableValueOrDefault(originalTable, defaultValues)
    -- type check
    if type(defaultValues) ~= "table" then
        return originalTable
    end
    if type(originalTable) ~= "table" then
        return defaultValues
    end

    local values = {}

    for k, v in pairs(defaultValues) do
        if type(v) == "table" and type(originalTable[k]) == "table" then
            values[k] = qhunTableValueOrDefault(originalTable[k], v)
        elseif originalTable[k] ~= nil then
            values[k] = originalTable[k]
        else
            values[k] = v
        end
    end

    -- add originalTable entries that do not exists in the defaultValues
    for k, v in pairs(originalTable) do
        if type(values[k]) == "nil" then
            values[k] = v
        end
    end
    return values
end

-- get a value from a table by specifying a dotted access syntax
--[[
    {
        originalTable: object,
        -- exampne can be:
            -- lorem.ipsun
            -- lorem
            -- lorem.ipsum.dolor
        dottedIdentifyer: string
    }
]]
function qhunGetTableWithDot(originalTable, dottedIdentifyer)
    -- type check
    if type(originalTable) ~= "table" then
        -- show a warning message
        QhunCore.WarningMessage.new(
            "qhunGetTableWithDot() given original table is not of type table. Given originalTable: " ..
                (originalTable or "nil")
        ):send()

        return nil
    end

    -- type check
    if type(dottedIdentifyer) ~= "string" or dottedIdentifyer:len() < 1 then
        -- show a warning message
        QhunCore.WarningMessage.new(
            "qhunGetTableWithDot() given identifyer is not a string or has a length of 0. Given identifyer: " ..
                (dottedIdentifyer or "nil")
        ):send()

        return nil
    end

    -- split the identifyer by the dot character and access the first index
    local keyOffset = dottedIdentifyer:find("%.")
    if keyOffset == nil then
        keyOffset = dottedIdentifyer:len()
    else
        keyOffset = keyOffset - 1
    end
    local currentKey = dottedIdentifyer:sub(1, keyOffset)

    -- access the object
    local value = originalTable[currentKey]

    -- if the value is a table and has a key of the next key, then access this object
    if type(value) == "table" and dottedIdentifyer:find("%.", keyOffset + 1) then
        -- refactor the dottedIdentifyer to allow recursive calls of qhunGetTableWithDot()
        return qhunGetTableWithDot(value, dottedIdentifyer:sub(keyOffset + 2))
    end

    -- return the current value
    return value
end

-- set a value to a table by allowing the dot syntax as key
--[[
    {
        originalTable: object,
        -- exampne can be:
            -- lorem.ipsun
            -- lorem
            -- lorem.ipsum.dolor
        dottedIdentifyer: string,
        value: any
    }
    returns true or false
]]
function qhunSetTableWithDot(originalTable, dottedIdentifyer, value)
    -- type check
    if type(originalTable) ~= "table" then
        -- show a warning message
        QhunCore.WarningMessage.new(
            "qhunSetTableWithDot() given original table is not of type table. given: " .. (originalTable or "nil")
        ):send()

        return false
    end

    -- type check
    if type(dottedIdentifyer) ~= "string" or dottedIdentifyer:len() < 1 then
        -- show a warning message
        QhunCore.WarningMessage.new(
            "qhunSetTableWithDot() given identifyer is not a string or has a length of 0. Given identifyer: " ..
                (dottedIdentifyer or "nil")
        ):send()

        return false
    end

    -- split the identifyer by the dot character and access the first index
    local keyOffset = dottedIdentifyer:find("%.")
    local hasDot = false
    if keyOffset == nil then
        keyOffset = dottedIdentifyer:len()
    else
        keyOffset = keyOffset - 1
        hasDot = true
    end
    local currentKey = dottedIdentifyer:sub(1, keyOffset)

    -- access the object
    local currentObject = originalTable[currentKey]

    -- if the value is a table, then search for a next key. if there is no next
    -- key, override the value
    if type(currentObject) == "table" and dottedIdentifyer:find("%.", keyOffset + 1) then
        -- there is a next key, do a recursive call
        return qhunSetTableWithDot(currentObject, dottedIdentifyer:sub(keyOffset + 2), value)
    elseif hasDot then
        -- the value should be overwritten directly under the table[currentKey] with
        -- the last dotted key
        local dotOffset = dottedIdentifyer:find("%.")
        local lastKey = dottedIdentifyer:sub(dotOffset + 1)

        -- check if the last key element if of type table. if not,
        -- create a table
        if type(currentObject) ~= "table" then
            originalTable[currentKey] = {}
        end

        -- override the value
        originalTable[currentKey][lastKey] = value

        -- done
        return true
    end

    -- override the value
    originalTable[currentKey] = value

    -- everything works fine
    return true
end

-- clones a given table
function qhunCloneTable(original)
    local original_type = type(original)
    local copy
    if original_type == "table" then
        copy = {}
        for original_key, original_value in next, original, nil do
            copy[qhunCloneTable(original_key)] = qhunCloneTable(original_value)
        end
        setmetatable(copy, qhunCloneTable(getmetatable(original)))
    else -- number, string, boolean, etc
        copy = original
    end
    return copy
end

-- returns the amount of gold, silver and copper from a total copper value
--[[
    {
        copper: number
    }
    returns {
        gold: number = 0,
        silver: number = 0,
        copper: number = 0,
        isNegative: boolean = false
    }
]]
function qhunGetMoneyValue(copper)
    -- extract gold silver and copper
    local copperChk = copper
    local isNegative = false

    if copperChk < 0 then
        copperChk = copper * -1
        isNegative = true
    end
    copperChk = string.reverse(tostring(copperChk))

    local gold = copperChk:sub(5)
    silver = copperChk:sub(3, 4)
    copper = copperChk:sub(1, 2)

    -- if there is an empty value, set it to 0
    if gold == "" then
        gold = "0"
    end
    if silver == "" then
        silver = "0"
    end
    if copper == "" then
        copper = "0"
    end

    return {
        gold = tonumber(gold:reverse()),
        silver = tonumber(silver:reverse()),
        copper = tonumber(copper:reverse()),
        isNegative = isNegative
    }
end
