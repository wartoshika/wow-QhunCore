QhunCore.AbstractUiElement = {}
QhunCore.AbstractUiElement.__index = QhunCore.AbstractUiElement

-- constructor
function QhunCore.AbstractUiElement.new(storageIdentifyer)
    -- private properties
    local instance = {
        _storageIdentifyer = storageIdentifyer
    }

    setmetatable(instance, QhunCore.AbstractUiElement)

    return instance
end

--[[
    PUBLIC ABSTRACT FUNCTIONS
]]
function QhunCore.AbstractUiElement:render(storage, parentFrame)
    QhunCore.ErrorMessage.new("QhunCore.AbstractUiElement:render() should be implemented in the child class!"):send()
    return
end

-- will be triggered if the storage was reset
function QhunCore.AbstractUiElement:onStorageReset(storage)
    QhunCore.ErrorMessage.new("QhunCore.AbstractUiElement:onStorageReset() should be implemented in the child class!"):send(

    )
    return
end

-- will be triggered if the element should update itself
function QhunCore.AbstractUiElement:update()
    QhunCore.ErrorMessage.new("QhunCore.AbstractUiElement:update() should be implemented in the child class!"):send()
    return
end

--[[
    PUBLIC FUNCTIONS
]]
-- get the current value from the storage
function QhunCore.AbstractUiElement:getStorageValue(storage)
    return storage:get(self._storageIdentifyer)
end

-- set a new value into the storage
function QhunCore.AbstractUiElement:setStorageValue(storage, value)
    if not storage:set(self._storageIdentifyer, value) then
        QhunCore.WarningMessage.new(
            "QhunCore.AbstractUiElement:setStorageValue() Set value in storage was NOT successfull. Identifyer was: ",
            self._storageIdentifyer
        ):send()
    end
end

-- overrides the text if there is a text on this ui element
-- put the parameters of the element's constructor function in here for an update
function QhunCore.AbstractUiElement:forceUpdate(...)
    self:update(...)
end
