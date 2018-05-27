QhunCore.InterfaceRenderer = {}
QhunCore.InterfaceRenderer.__index = QhunCore.InterfaceRenderer

-- constructor
--[[
    {
        elements: {QhunCore.AbstractUiElement}[],
        parentFrame: {WowFrame},
        storage: {QhunCore.Storage},
        padding?: number = 0,
        startOffset?: {
            x?: number = 0,
            y?: number = 0
        }
    }
]]
function QhunCore.InterfaceRenderer.new(elements, parentFrame, storage, padding, startOffset)
    -- default vars
    if type(padding) ~= "number" then
        padding = 0
    end

    -- private properties
    local instance = {
        _elements = elements,
        _parentFrame = parentFrame,
        _startOffset = qhunTableValueOrDefault(
            startOffset,
            {
                x = 0,
                y = 0
            }
        ),
        _storage = storage,
        _padding = padding,
        _renderCache = {}
    }

    setmetatable(instance, QhunCore.InterfaceRenderer)

    return instance
end

--[[
    PUBLIC FUNCTIONS
]]
-- renders all elements
--[[
    returns {WowFrame}[]
]]
function QhunCore.InterfaceRenderer:render()
    -- check if the renderCache is filled
    if #self._renderCache > 0 then
        return self._renderCache
    end

    -- iterate over all options and render them individually
    for _, element in pairs(self._elements) do
        table.insert(self._renderCache, element:render(self._storage, self._parentFrame))
    end

    -- vars to adjust the positions
    local yOffset = self._startOffset.y
    local xOffset = self._startOffset.x

    -- iterate over every element and update it's position
    for _, element in pairs(self._renderCache) do
        -- set the new position
        element:SetPoint("TOPLEFT", xOffset, -yOffset)

        -- extract extra padding
        local extraPadding = element._qhunCoreExtraPadding
        if extraPadding == nil then
            extraPadding = 0
        end

        -- get the height of the object and increase the yOffset
        yOffset = yOffset + element:GetHeight() + self._padding + extraPadding
    end

    -- return the rendered elements
    return self._renderCache
end
