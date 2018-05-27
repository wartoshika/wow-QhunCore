QhunCore.Addon = {}
QhunCore.Addon.__index = QhunCore.Addon

-- private static properties
local addonLoadCallbackStack = {}
local addonUnloadCallbackStack = {}

-- constructor
function QhunCore.Addon.new(addonName)
    -- private properties
    local instance = {
        _addonName = addonName,
        _addonLoadCallback = nil,
        _addonUnloadCallback = nil,
        _addonInterfaceSettings = {}
    }

    setmetatable(instance, QhunCore.Addon)
    return instance
end

--[[
    STATIC FUNCTIONS
]]
-- a core function to init the addon events
function QhunCore.Addon.coreInit()
    -- debug
    qhunDebug("QhunCore.Addon.coreInit()")

    -- create frame and register events
    eventFrame = CreateFrame("FRAME")
    eventFrame:RegisterEvent("PLAYER_LOGIN")
    eventFrame:RegisterEvent("PLAYER_LOGOUT")

    eventFrame:SetScript(
        "OnEvent",
        function(_, eventName, ...)
            -- if the event is login or logout, do it here
            -- other cases will go to the event engine
            if eventName == "PLAYER_LOGIN" then
                for _, data in pairs(addonLoadCallbackStack) do
                    data.callback(data.addon)
                end
            elseif eventName == "PLAYER_LOGOUT" then
                for _, data in pairs(addonUnloadCallbackStack) do
                    data.callback(data.addon)
                end
            end
        end
    )
end

--[[
    PUBLIC FUNCTIONS
]]
-- registers a function to be executed at addon load
function QhunCore.Addon:registerAddonLoad(callbackFunction)
    -- test if type is function
    if type(callbackFunction) ~= "function" then
        return
    end

    -- print debug message
    qhunDebug('Addon "' .. self._addonName .. '" has registered a load callback')

    self._addonLoadCallback = callbackFunction
    table.insert(addonLoadCallbackStack, {addon = self, callback = callbackFunction})

    return self
end

-- registers a function to be executed at addon unload
function QhunCore.Addon:registerAddonUnload(callbackFunction)
    -- test if type is function
    if type(callbackFunction) ~= "function" then
        return
    end

    -- print debug message
    qhunDebug('Addon "' .. self._addonName .. '" has registered an unload callback')

    self._addonUnloadCallback = callbackFunction
    table.insert(addonUnloadCallbackStack, {addon = self, callback = callbackFunction})

    return self
end

-- registers addon interface settings
--[[
    {
        -- if the order key is given, the interface generator will preserve the given
        -- order.
        _order?: {
            -- the value should be the unique key used for interfaceOptions string
            [noKeyGiven: nil]: string
        },
        -- first option is the main page
        -- every other option will have a sub category
        -- the interfaceOptions key must be unique als will be used
        -- to open the interface option to this category
        [interfaceOptions: string]: {
            -- the visible name for the category
            name: string
            -- if the category is disabled or not
            disabled?: boolean = false
            -- every element that will be rendered
            -- on the settings page
            elements: {? extends QhunCore.AbstractUiElement}[]
        },
        -- will be called if the user clicks the OK button in the interface options
        okCallback?: function,
        -- will be called if the user clicks the cancel button in the interacfe options
        cancelCallback?: function
    }
    returns self or false
]]
function QhunCore.Addon:registerInterfaceSettings(storage, interfaceOptions)
    -- parameter type check
    if type(interfaceOptions) ~= "table" then
        QhunCore.ErrorMessage.new("[Interface Options] The given interfaceOptions ist not a valid table!"):send()
        return false
    end

    -- debug print
    qhunDebug('Addon "' .. self._addonName .. '" has registered interface options')

    -- first do some type checking and set initial values
    for key, option in pairs(interfaceOptions) do
        (function()
            -- skip _order
            if key == "_order" then
                -- return skips the wrapped unnamed function in the for loop
                return
            end

            -- all elements must be an extend of AbstractUiElement
            for _, element in pairs(option.elements) do
                if not qhunDerivedFrom(element, QhunCore.AbstractUiElement) then
                    -- print error message and return false
                    QhunCore.ErrorMessage.new(
                        '[Interface Options] Element "' ..
                            option.name .. '" is no instance of QhunCore.AbstractUiElement!'
                    ):send()
                    return false
                end
            end

            -- add default disable
            if option.disable == nil then
                option.disable = false
            end
        end)()
    end

    -- get the main setting (first index)
    local parent = nil

    -- get the correct order
    local order = interfaceOptions._order or qhunGetTableKeys(interfaceOptions)

    -- iterate over every option and create them
    for _, keyaccessor in ipairs(order) do
        (function()
            -- skip key _order
            if keyaccessor == "_order" then
                -- return skips the wrapped unnamed function in the for loop
                return
            end

            local option = interfaceOptions[keyaccessor]

            -- parent will be nil in the first run
            self._addonInterfaceSettings[keyaccessor] =
                QhunCore.InterfaceSettingGenerator.new(
                storage,
                keyaccessor,
                option.name,
                option.disabled,
                option.elements,
                parent
            )

            -- set the parent (first option in the array)
            if parent == nil then
                parent = option.name
            end
        end)()
    end

    -- everything ok, go on
    return self
end
