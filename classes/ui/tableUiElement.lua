QhunCore.TableUiElement = {}
QhunCore.TableUiElement.__index = QhunCore.TableUiElement

-- constructor
--[[
    {
        -- defined the amount of columns and its header display name
        header: {
            -- an empty displayName will not consume any ui space.
            -- good for structuring without visible overhead
            displayName?: string = "",
            -- the width of the column in percent of the interfaceOption window's width
            width?: number = WowInterfaceOptionWidth / #header
        }[],
        -- every element that should be rendered in the table cell
        -- example:
            -- if the header contains two entries the first element will be in cell 0,0 the
            -- second in cell 0,1 and the third in cell 1,0 and so on
        body: {QhunCore.AbstractUiElement}[],
        settings?: {
            -- the padding for each cell in the table (only top and bottom padding)
            cellpadding?: number = 10
        }
    }
]]
function QhunCore.TableUiElement.new(header, body, settings)
    -- call super class (no storage for this one!)
    local instance = QhunCore.AbstractUiElement.new(nil)

    -- bind values
    instance._header = header
    instance._body = body
    instance._renderContext = {}
    instance._renderedBody = {}
    instance._settings =
        qhunTableValueOrDefault(
        settings,
        {
            cellpadding = 10
        }
    )

    -- bind current values
    setmetatable(instance, QhunCore.TableUiElement)

    return instance
end

-- set inheritance
setmetatable(QhunCore.TableUiElement, {__index = QhunCore.AbstractUiElement})

--[[
    PUBLIC FUNCTIONS
]]
function QhunCore.TableUiElement:render(storage, parentFrame)
    -- calculate the maximal available width
    local tableFrame = CreateFrame("FRAME", nil, parentFrame)
    local maxWidth = InterfaceOptionsFramePanelContainer:GetWidth()
    local availableColumns = #self._header
    local columnRenderContext = {}

    -- first check the widths of the columns and adjust them for eventually needed default
    -- values and create a render context
    for index, header in pairs(self._header) do
        if type(header.width) ~= "number" then
            header.width = (maxWidth / availableColumns) / maxWidth * 100
        end

        -- get relevant elements for the current column
        local elements = self:getElementsForColumn(index)

        -- check if the displayName was set
        if type(header.displayName) == "string" and header.displayName:len() > 0 then
            -- add the header text to the element stack at the beginning
            table.insert(
                elements,
                1,
                QhunCore.TextUiElement.new(
                    header.displayName,
                    {
                        color = {r = 1, g = 215 / 255, b = 0},
                        padding = self._settings.cellpadding
                    }
                )
            )
        end

        -- calculate the x offset for the current column
        local xOffset = 0
        if self._header[index - 1] ~= nil then
            xOffset = (maxWidth * self._header[index - 1].width / 100) * (index - 1)
        end

        -- create the final context
        self._renderContext[index] = {
            header = header,
            renderer = QhunCore.InterfaceRenderer.new(
                elements,
                tableFrame,
                storage,
                self._settings.cellpadding,
                {
                    x = xOffset,
                    y = 0
                }
            ),
            renderedFrames = nil
        }
    end

    -- the context is done, now render the elements and return the final frame stack
    for _, context in pairs(self._renderContext) do
        -- start rendering the objects
        context.renderedFrames = context.renderer:render()

        -- add them to the rendered body
        for _, v in pairs(context.renderedFrames) do
            table.insert(self._renderedBody, v)
        end
    end

    -- get every row from the table to adjust the height of the smaller cells
    --[[
        -- get all elements for the column and adjust the height of all
        -- elements to the tallest element
        local frameHeights = {}
        for _, frame in pairs(context.renderedFrames) do
            table.insert(frameHeights, frame:GetHeight())
        end

        -- calculate the max height
        local maxHeight = math.max(unpack(frameHeights))
        print("max height", maxHeight)
        -- now alter the height of all elements
        for _, frame in pairs(context.renderedFrames) do
            frame:SetHeight(maxHeight)
        end
    ]]
    for row = 1, #self._renderedBody / #self._header do
        -- get all elements for the column and adjust the height of all
        -- elements to the tallest element
        local rowElements = self:getElementsForRow(row)
        local rowHeights = {}
        for _, element in pairs(rowElements) do
            table.insert(rowHeights, element:GetHeight())
        end

        -- calculate the max height
        local maxHeight = math.max(unpack(rowHeights))

        -- update the height to every row element
        for _, element in pairs(rowElements) do
            -- adjust the point
            if element:GetHeight() ~= maxHeight then
                local originalHeight = element:GetHeight()
                local _, _, _, originalX, originalY = element:GetPoint()

                element:SetPoint("TOPLEFT", originalX, -((maxHeight + self._settings.cellpadding) * (row - 1)))
            end

            -- and the new height
            element:SetHeight(maxHeight)
        end
    end

    -- set width and height
    tableFrame:SetWidth(maxWidth)
    tableFrame:SetHeight(self:getSumHeightMax())

    return tableFrame
end

-- will be triggered if the storage was reset
function QhunCore.AbstractUiElement:onStorageReset(storage)
    -- reset every child element
    for _, element in pairs(self._body) do
        element:onStorageReset(storage)
    end
end

--[[
    PRIVATE FUNCTIONS
]]
--[[
    {
        columnNumber: number
    }
    returns {QhunCore.AbstractUiElement}[]
]]
function QhunCore.TableUiElement:getElementsForColumn(columnNumber)
    local elements = {}

    -- a for loop that takes every nth element from the element stack
    for i = columnNumber, #self._body, #self._header do
        table.insert(elements, self._body[i])
    end

    return elements
end

-- get all elements for the given row number
--[[
    {
        rowNumber: number
    }
    returns {QhunCore.AbstractUiElement}[]
]]
function QhunCore.TableUiElement:getElementsForRow(rowNumber)
    local elements = {}

    -- lookup every nth element
    for i = rowNumber, #self._renderedBody, #self._renderContext[1].renderedFrames do
        table.insert(elements, self._renderedBody[i])
    end

    return elements
end

-- get the maximal height of every rendered column and take the max
function QhunCore.TableUiElement:getSumHeightMax()
    local height = {}
    for column, context in pairs(self._renderContext) do
        height[column] = 0
        for _, element in pairs(context.renderedFrames) do
            height[column] = height[column] + element:GetHeight()
        end
    end

    -- get the max element
    return math.max(unpack(height))
end
