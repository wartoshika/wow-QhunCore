QhunCore.SelectboxUiElement = {}
QhunCore.SelectboxUiElement.__index = QhunCore.SelectboxUiElement

-- constructor
--[[
    {
        lable: string,
        storageIdentifyer: string,
        values: {
            [uniqueKeyIdentifyer: string]: string
        },
        settings?: {
            padding?: number = 0,
            width?: number = 150
        },
        -- a function that will be called on value change
        onCHangeCallback?: function(newSelectedKey: string)
    }
]]
function QhunCore.SelectboxUiElement.new(lable, storageIdentifyer, values, settings, onChangeCallback)
    if type(values) ~= "table" then
        QhunCore.WarningMessage.new(
            "The given value element is no table. I set an empty table as values but this meight be an error!"
        )
    end

    -- call super class
    local instance = QhunCore.AbstractUiElement.new(storageIdentifyer)

    -- bind properties
    instance._lable = lable
    instance._values = values
    instance._selectboxFrame = nil
    instance._onChangeCallback = onChangeCallback
    instance._settings =
        qhunTableValueOrDefault(
        settings,
        {
            padding = 0,
            width = 150
        }
    )

    -- bind current values
    setmetatable(instance, QhunCore.SelectboxUiElement)

    return instance
end

-- set inheritance
setmetatable(QhunCore.SelectboxUiElement, {__index = QhunCore.AbstractUiElement})

--[[
    PUBLIC FUNCTIONS
]]
function QhunCore.SelectboxUiElement:render(storage, parentFrame)
    -- create the selectbox element
    local selectbox = CreateFrame("FRAME", "QHUNCORE_SELECTBOX_" .. qhunUuid(), parentFrame, "UIDropDownMenuTemplate")

    -- adjust selectbox frame settings
    UIDropDownMenu_SetWidth(selectbox, self._settings.width)
    UIDropDownMenu_SetText(selectbox, self:getCurrentTranslatedValue(storage))

    -- set values
    UIDropDownMenu_Initialize(
        selectbox,
        function(_self, level, menuList)
            -- get the currently checked value
            local checkedElement = self:getStorageValue(storage)

            -- add all values as button
            for k, v in pairs(self._values) do
                -- create info element to store selectable data
                local info = UIDropDownMenu_CreateInfo()

                -- add data
                info.text = v
                info.func = function()
                    self:onSelectboxElementClick(storage, k, v)
                end
                info.checked = checkedElement == k

                -- add button to list
                UIDropDownMenu_AddButton(info)
            end
        end
    )

    -- store the instance
    self._selectboxFrame = selectbox

    return selectbox
end

-- will be triggered if the user changes the value of the selectbox
function QhunCore.SelectboxUiElement:onSelectboxElementClick(storage, keyIdentifyer, value)
    -- store the selected element in the storage
    self:setStorageValue(storage, keyIdentifyer)

    -- change the visible value for the user
    UIDropDownMenu_SetText(self._selectboxFrame, value)

    -- call the callback if given
    if type(self._onChangeCallback) == "function" then

        self._onChangeCallback(keyIdentifyer)
    end
end

-- will be triggered if the storage was reset
function QhunCore.SelectboxUiElement:onStorageReset(storage)

    -- get the current stored key identifyer
    local key = self:getStorageValue(storage)

    -- get the value from the value stack acording to the key
    local value = self._values[key]

    -- set the text of the selectbox
    UIDropDownMenu_SetText(self._selectboxFrame, value)
end

--[[
    PRIVATE FUNCTIONS
]]
--[[
    {
        storage: QhunCore.Storage
    }
]]
function QhunCore.SelectboxUiElement:getCurrentTranslatedValue(storage)
    -- get the current stored value
    local currentKeyValue = self:getStorageValue(storage)

    -- get the value depending of the key from the value stack
    return self._values[currentKeyValue]
end
