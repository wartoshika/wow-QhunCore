QhunCore.Storage = {}
QhunCore.Storage.__index = QhunCore.Storage

-- constructor
--[[
    {
        addonName: string,
        storageName: string,
        perCharacter?: boolean // default = true
    }
]]
function QhunCore.Storage.new(addonName, storageName, perCharacter)
    -- default variables
    if perCharacter == nil then
        perCharacter = true
    end

    -- private properties
    local instance = {
        _addonName = addonName,
        _storageName = storageName,
        _perCharacter = perCharacter,
        _uncommitedChanges = {},
        _defaultValues = {}
    }

    -- global init values
    if type(QhunCoreCharacterStorage) ~= "table" then
        QhunCoreCharacterStorage = {}
    end
    if type(QhunCoreGlobalStorage) ~= "table" then
        QhunCoreGlobalStorage = {}
    end
    if type(QhunCoreCharacterStorage[addonName]) ~= "table" then
        QhunCoreCharacterStorage[addonName] = {}
    end
    if type(QhunCoreGlobalStorage[addonName]) ~= "table" then
        QhunCoreGlobalStorage[addonName] = {}
    end

    -- prepare init values
    if perCharacter and type(QhunCoreCharacterStorage[addonName][storageName]) ~= "table" then
        QhunCoreCharacterStorage[addonName][storageName] = {}
    elseif type(QhunCoreGlobalStorage[addonName][storageName]) ~= "table" then
        QhunCoreGlobalStorage[addonName][storageName] = {}
    end

    -- print debug message
    qhunDebug('Storage with name "' .. storageName .. '" was successfully created.')

    setmetatable(instance, QhunCore.Storage)
    return instance
end

--[[
    PUBLIC FUNCTIONS
]]

-- a function that will return all values from the storage as table
-- and tries to fill every nil value with the defaultValue parameter
--[[
    returns {
        [identifyer: string]: any
    }
]]
function QhunCore.Storage:getAll()
    local storageValues = {}
    local storageData = QhunCoreGlobalStorage[self._addonName][self._storageName]

    -- override data if stored per character
    if self._perCharacter then
        storageData = QhunCoreCharacterStorage[self._addonName][self._storageName]
    end

    return qhunTableValueOrDefault(storageData, self._defaultValues)
end

-- set the default values for the storage
--[[
    returns self
]]
function QhunCore.Storage:setDefaultValues(defaultValues)
    self._defaultValues = defaultValues
    return self
end

-- get the current stored value from the storage using an identifyer.
-- uncommited values will be returned!
--[[
    {
        identifyer: string,
        includeUncommited?: boolean = true
    }
]]
function QhunCore.Storage:get(identifyer, includeUncommited)
    -- type check
    if type(identifyer) ~= "string" or identifyer:len() < 1 then
        QhunCore.ErrorMessage.new(
            "QhunCore.Storage:get() the given identifyer is not valid! Given: " .. (identifyer or "nil")
        ):send()
        return
    end

    -- initial values
    if includeUncommited == nil then
        includeUncommited = true
    end

    -- clone the table to avoid overwriting the data when including uncommited values
    local storageData = qhunCloneTable(QhunCoreGlobalStorage[self._addonName][self._storageName])

    -- override data if stored per character
    if self._perCharacter then
        storageData = qhunCloneTable(QhunCoreCharacterStorage[self._addonName][self._storageName])
    end

    -- try to get the value from the storage
    local potentialValue

    -- include uncommited
    if includeUncommited then
        potentialValue = qhunGetTableWithDot(self._uncommitedChanges, identifyer)
    end

    -- if there is no value in the uncommited changes for they are not included
    if potentialValue == nil then
        potentialValue = qhunGetTableWithDot(storageData, identifyer)
    end

    if potentialValue ~= nil then
        -- if there is any value missing in the potential value
        -- add them from the defaultValue stack
        if type(potentialValue) == "table" then
            return qhunTableValueOrDefault(potentialValue, self._defaultValues[identifyer])
        else
            return potentialValue
        end
    end

    -- value was not found, return the default value
    return qhunGetTableWithDot(self._defaultValues, identifyer)
end

-- set the given identifyer to the given value in the storage
-- you need to commit the values before unloading the addon!
--[[
    {
        identifyer: string,
        value: any
    }

    returns self
]]
function QhunCore.Storage:set(identifyer, value)
    qhunSetTableWithDot(self._uncommitedChanges, identifyer, value)

    -- emit the storage changes event
    QhunCore.EventEmitter.getCoreInstance():emit("STORAGE_UNCOMMITTED_CHANGED", identifyer, value)

    return self
end

-- commits every changes and persists the data between game sessions
function QhunCore.Storage:commit()
    for k, v in pairs(self._uncommitedChanges) do
        if self._perCharacter then
            qhunSetTableWithDot(QhunCoreCharacterStorage[self._addonName][self._storageName], k, qhunCloneTable(v))
        else
            qhunSetTableWithDot(QhunCoreGlobalStorage[self._addonName][self._storageName], k, qhunCloneTable(v))
        end
    end

    -- emit commit event
    QhunCore.EventEmitter.getCoreInstance():emit("STORAGE_COMMITTED", self._uncommitedChanges)

    -- reset the changes
    self._uncommitedChanges = {}
end

-- resets all uncommited changes
--[[
    returns self
]]
function QhunCore.Storage:reset()
    self._uncommitedChanges = {}

    -- emit an event
    QhunCore.EventEmitter.getCoreInstance():emit("STORAGE_UNCOMMITTED_CHANGED")
    QhunCore.EventEmitter.getCoreInstance():emit("STORAGE_RESET")

    return self
end

-- returns all uncommited changes
--[[
    returns {
        [identifyer: string]: any
    }
]]
function QhunCore.Storage:getChanges()
    return self._uncommitedChanges
end
