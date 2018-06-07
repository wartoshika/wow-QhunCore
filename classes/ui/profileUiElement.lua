QhunCore.ProfileUiElement = {}
QhunCore.ProfileUiElement.__index = QhunCore.ProfileUiElement

-- constructor
--[[
    {
        translatorInstance: QhunCore.Translation,
        settings?: {
            
        }
    }
]]
function QhunCore.ProfileUiElement.new(translatorInstance, settings)
    -- type check
    if not qhunInstanceOf(translatorInstance, QhunCore.Translation) then
        QhunCore.ErrorMessage.new("The given translatorInstance is not a class of type QhunCore.Translation"):send()
        return
    end

    -- call super class
    local instance = QhunCore.AbstractUiElement.new()

    -- private properties
    instance._settings = qhunTableValueOrDefault(settings, {})
    instance._renderContext = nil
    instance._translatorInstance = translatorInstance
    instance._renderedChildren = {}
    instance._childrenInstances = {}

    -- bind current values
    setmetatable(instance, QhunCore.ProfileUiElement)

    return instance
end

-- set inheritance
setmetatable(QhunCore.ProfileUiElement, {__index = QhunCore.AbstractUiElement})

--[[
    PUBLIC FUNCTIONS
]]
function QhunCore.ProfileUiElement:render(storage, parentFrame)
    -- type check for the storage
    if not qhunInstanceOf(storage, QhunCore.ProfileStorage) then
        QhunCore.ErrorMessage.new(
            "The given storage is not an instance of QhunCore.ProfileStorage. You must use a profile storage if you want to use the QhunCore.ProfileUiElement!"
        ):send()
        return
    end

    -- create the profile wrapper frame
    local profileWrapper = CreateFrame("FRAME", nil, parentFrame)

    -- create the profile selector
    local selectorValues = self:generateCharacterSelection()
    -- append the global selection
    selectorValues["GLOBAL_PROFILE"] = self._translatorInstance:translate("QHUNCORE_PROFILE_UI_SELECT_GLOBAL")

    -- instantiate a new renderer to render sub elements
    self._childrenInstances = {
        QhunCore.TextUiElement.new(
            self._translatorInstance:translate("QHUNCORE_PROFILE_UI_ENTRY"),
            {
                padding = 20
            }
        ),
        QhunCore.TableUiElement.new(
            {
                {
                    width = 20
                },
                {
                    width = 80
                }
            },
            {
                QhunCore.TextUiElement.new(self._translatorInstance:translate("QHUNCORE_PROFILE_UI_PREFERENCE")),
                QhunCore.SelectboxUiElement.new(
                    "",
                    "QHUNCORE.PROFILE_PREFERENCE",
                    selectorValues,
                    {},
                    function(...)
                        self:onProfileChange(storage, ...)
                    end
                )
            }
        )
    }
    self._renderContext =
        QhunCore.InterfaceRenderer.new(
        self._childrenInstances,
        profileWrapper,
        storage,
        0,
        {
            x = 0,
            y = 0
        }
    )

    -- render the elements
    self._renderedChildren = self._renderContext:render()

    -- get every height,width and sum them up to adjust the real height,width
    local height, width = 0, {}
    for _, element in pairs(self._renderedChildren) do
        height = height + element:GetHeight()
        table.insert(width, element:GetWidth())
    end

    -- adjust the height
    profileWrapper:SetHeight(height)

    -- set the width to the max found width
    local maxWidth = math.max(unpack(width))
    profileWrapper:SetWidth(maxWidth)

    -- return the wrapper frame including all child rendered frames
    return profileWrapper
end

-- will be triggered if the storage was reset
function QhunCore.ProfileUiElement:onStorageReset(storage)
    -- reset every child element
    for _, children in pairs(self._childrenInstances) do
        -- trigger the storage reset function
        children:onStorageReset(storage)
    end
end

--[[
    PRIVATE FUNCTIONS
]]
function QhunCore.ProfileUiElement:generateCharacterSelection()
    -- get all characters
    local chars = QhunCore.characterStorage:getAll()
    local selector = {}

    -- iterate over every character
    for guid, char in pairs(chars) do
        selector[guid] = char.name .. " - " .. char.realm
    end

    return selector
end

-- will be called if the user changes the profile
function QhunCore.ProfileUiElement:onProfileChange(storage, newProfileName)
    -- update the profile in the storage
    storage:setProfile(newProfileName)
end
