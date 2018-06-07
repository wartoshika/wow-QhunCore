QhunCore.ProfileStorage = {}
QhunCore.ProfileStorage.__index = QhunCore.ProfileStorage

-- constructor
-- the profile storage wrapps a character based and a global storage and chooses depending on the selected
-- profile where to store the information
--[[
    {
        addonName: string,
        storageName: string,
        -- the default values that will be applied to the created storages
        defaultValues?: {
            [keyIdentifyer: string]: any
        }
    }
]]
function QhunCore.ProfileStorage.new(addonName, storageName, defaultValues)
    instance = {
        _addonName = addonName,
        _storageName = storageName,
        _charStorage = QhunCore.Storage.new(addonName, "profile-" .. storageName, true),
        _globalStorage = QhunCore.Storage.new(addonName, "profile-" .. storageName, false)
    }

    -- apply default values if given
    if type(defaultValues) == "table" then
        instance._charStorage:setDefaultValues(defaultValues)
        instance._globalStorage:setDefaultValues(defaultValues)
    end

    -- bind current values
    setmetatable(instance, QhunCore.ProfileStorage)

    return instance
end

--[[
    PUBLIC API
]]
-- a function that will return all values from the storage as table
-- and tries to fill every nil value with the defaultValue parameter
--[[
    returns {
        [identifyer: string]: any
    }
]]
function QhunCore.ProfileStorage:getAll()
    return self:getStorage():getAll()
end

-- set the default values for the storage
--[[
    returns self
]]
function QhunCore.ProfileStorage:setDefaultValues(defaultValues)
    QhunCore.WarningMessage.new(
        "setDefaultValues() will not work on a profile based storage. Please use the constructor to apply default values"
    )
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
function QhunCore.ProfileStorage:get(identifyer, includeUncommited)
    return self:getStorage():get(identifyer, includeUncommited)
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
function QhunCore.ProfileStorage:set(identifyer, value)
    self:getStorage():set(identifyer, value)
    return self
end

-- commits every changes and persists the data between game sessions
function QhunCore.ProfileStorage:commit()
    return self:getStorage():commit()
end

-- resets all uncommited changes
--[[
    returns self
]]
function QhunCore.ProfileStorage:reset()
    return self:getStorage():reset()
end

-- returns all uncommited changes
--[[
    returns {
        [identifyer: string]: any
    }
]]
function QhunCore.ProfileStorage:getChanges()
    return self:getStorage():getChanges()
end

-- set the current profile
--[[
    {
        -- the guid of the player for a char based storage or the text GLOBAL_PROFILE for the global storage
        profile: string
    }
    return self
]]
function QhunCore.ProfileStorage:setProfile(profile)

    print("NEW PROFILE", profile)

    -- set the profile choice in the char based storage
    self._charStorage:set("QHUNCORE.PROFILE_PREFERENCE", profile)

    return self
end

--[[
    PRIVATE API
]]
-- get the currently active storage
function QhunCore.ProfileStorage:getStorage()
    -- the information where to store and get the data from is stored in the char
    -- based storage. every char made the choice to use the global or char based storage
    local currentStorageIndicator = self._charStorage:get("QHUNCORE.PROFILE_PREFERENCE")

    -- choose depending on the profile setting
    if currentStorageIndicator == "GLOBAL_PROFILE" then
        return self._globalStorage
    else
        return self._charStorage
    end
end
