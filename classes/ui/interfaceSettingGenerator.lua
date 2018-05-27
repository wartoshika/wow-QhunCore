QhunCore.InterfaceSettingGenerator = {}
QhunCore.InterfaceSettingGenerator.__index = QhunCore.InterfaceSettingGenerator

-- constructor
--[[
    {
        storage: {QhunCore.Storage},
        id: string,
        displayName: string,
        disabled: boolean,
        elements: {? extends QhunCore.AbstractUiElement}[],

        -- the parent display name string
        parentDisplayName?: string,

        -- the padding used to wrapp the elements
        padding?: number = 7
    }
]]
function QhunCore.InterfaceSettingGenerator.new(storage, id, displayName, disabled, elements, parentDisplayName, padding)
    -- default values
    if type(padding) ~= "number" then
        padding = 7
    end

    -- private properties
    local instance = {
        _id = id,
        _displayName = displayName,
        _disabled = disabled,
        _elements = elements,
        _parentDisplayName = parentDisplayName,
        _storage = storage,
        _frame = nil,
        _padding = padding,
        _elementRenderedStack = {}
    }

    setmetatable(instance, QhunCore.InterfaceSettingGenerator)

    -- create the interface option
    instance:createInterfaceOption()

    return instance
end

--[[
    PRIVATE FUNCTIONS
]]
-- creates the addon interface option
function QhunCore.InterfaceSettingGenerator:createInterfaceOption()
    -- debug print
    qhunDebug('Generating interface option with id "' .. self._id .. '" and name "' .. self._displayName .. '"')

    -- create the interface frame
    self._frame = CreateFrame("FRAME", nil, InterfaceOptionsFramePanelContainer)

    -- apply the displayName
    self._frame.name = self._displayName

    -- add parent if there is any
    if self._parentDisplayName then
        self._frame.parent = self._parentDisplayName
    end

    -- add the frame to the wow interface options
    InterfaceOptions_AddCategory(self._frame)

    -- add an event to render the setting if the user opened the interface options
    self._frame:SetScript(
        "OnShow",
        function()
            -- just check that the renderer should not do it's task twice
            if self._frame._isRendered then
                -- debug print
                qhunDebug('Skipped option rendering of "' .. self._displayName .. '" with id "' .. self._id .. '"')

                return
            end

            -- render the options
            self:render()
        end
    )

    -- add ok and cancel callbacks, but only to the parent frame
    if not self._parentDisplayName then
        self._frame.okay = function()
            self:commitChanges()
        end
        self._frame.cancel = function()
            self:resetChanges()
        end
    end

    -- register a storage reset event to handle the redraw of original values after
    -- changing their aperated values in the ui
    QhunCore.EventEmitter.getCoreInstance():on(
        "STORAGE_RESET",
        function()
            self:resetInterfaceElements()
        end
    )
end

-- renders the interface setting
function QhunCore.InterfaceSettingGenerator:render()
    -- vars to adjust the positions
    local yOffset = 15
    local xOffset = 15

    -- generate title
    local title = self._displayName

    -- add parent to title if available
    if self._parentDisplayName then
        title = self._parentDisplayName .. " > " .. title
    end

    -- add the page title
    table.insert(
        self._elements,
        -- insert at the beginning
        1,
        QhunCore.TextUiElement.new(
            title,
            {
                fontSize = 16,
                color = {r = 1, g = 215 / 255, b = 0}
            }
        )
    )

    -- build the renderer and start rendering
    local renderer =
        QhunCore.InterfaceRenderer.new(
        self._elements,
        self._frame,
        self._storage,
        self._padding,
        {
            x = xOffset,
            y = yOffset
        }
    )

    self._elementRenderedStack = renderer:render()

    -- set rendered
    self._frame._isRendered = true
end

-- commit all changes
function QhunCore.InterfaceSettingGenerator:commitChanges()
    -- debug print
    qhunDebug("QhunCore.InterfaceSettingGenerator:commitChanges()")

    -- commit!
    self._storage:commit()
end

-- reset all changes
function QhunCore.InterfaceSettingGenerator:resetChanges()
    -- debug print
    qhunDebug("QhunCore.InterfaceSettingGenerator:resetChanges()")

    -- reset!
    self._storage:reset()
end

-- reset all registered interface elements to it's stored value
function QhunCore.InterfaceSettingGenerator:resetInterfaceElements()
    -- debug print
    qhunDebug('Resetting interface elements with id "' .. self._id .. '"')

    -- reset all interface element values
    for _, element in pairs(self._elements) do
        element:onStorageReset(self._storage)
    end
end
