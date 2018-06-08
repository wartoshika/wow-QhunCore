# QhunCore documentation of `QhunCore.AbstractUiElement` in `classes/ui/abstractUiElement.lua`

This is an abstract class that should not be instantiated outside a class constructor context. All UI elements should have this class as its parent to allow an interface like design pattern for this QhunCore UI feature. All public abstract functions should be implemented in the concrete class.

## Example

This example provides a usage possability of this abstract class. There is a class called `MyAddon.MySimpleTextUiElement` that has `QhunCore.AbstractUiElement` as its parent class.

Every public abstract function in the parent class should be implemented!

```lua
-- create the class
MyAddon.MySimpleTextUiElement = {}
-- set the class metatable
MyAddon.MySimpleTextUiElement.__index = MyAddon.MySimpleTextUiElement

-- create the constructor
function MyAddon.MySimpleTextUiElement.new(text)

    -- call super class (no storage for this object)
    local instance = QhunCore.AbstractUiElement.new(nil)

    -- add the text to the instance properties
    instance._text = text

    -- bind current values
    setmetatable(instance, MyAddon.MySimpleTextUiElement)

    -- return the instantiated class
    return instance
end

-- set inheritance to QhunCore.AbstractUiElement
setmetatable(MyAddon.MySimpleTextUiElement, {__index = QhunCore.AbstractUiElement})

--[[
    now implement all public abstract functions!
]]
function MyAddon.MySimpleTextUiElement:render(storage, parentFrame)

    -- create an empty frame
    return CreateFrame("FRAME", nil, parentFrame)
end

function MyAddon.MySimpleTextUiElement:onStorageReset(storage)

    -- reset the element view state to the current storage value
end
```

# Static API

## Constructor

## QhunCore.AbstractUiElement `QhunCore.AbstractUiElement.new([storageIdentifyer = nil])`

Constructs the class with a storageIdentifyer to get the element's value from the storage.

**Parameters:**
- storageIdentifyer (optional, string, default nil) - *The storage identifyer to access the storage later*

**Returns:** An instantiated class.

---

## PUBLIC ABSTRACT FUNCTIONS

These methods must be implemented in the concrete class!

## WoW Frame `render(storage, parentFrame)`

Will be called if the frame rendering is requested. This function will only be called once when needing this rendered frame. You dont have to implement a frame skip logic.

**Parameters:**
- storage (required, `QhunCore.Storage | QhunCore.ProfileStorage`) - *The storage to access values*
- parentFrame (required, WoW Frame table) - *The parent frame to draw the new element on*

**Returns:** A rendered WoW Frame.

## nil `onStorageReset(storage)`

Will be called if an element reset should be done. An example is, if the user clicks the cancel button in the addon settings to undo all changes. You should then implement a reset login by returning the visible state to the last saved state.

**Parameters:**
- storage (required, `QhunCore.Storage | QhunCore.ProfileStorage`) - *The storage to access values*

---

## PUBLIC FUNCTIONS

## any `getStorageValue(storage)`

Get the current commited or uncommited value from the storage

**Parameters:**
- storage (required, `QhunCore.Storage | QhunCore.ProfileStorage`) - *The storage to access values*

**Returns:** The value that is currently in the given storage

## nil `setStorageValue(storage, value)`

Set a new value in the given storage.

**Parameters:**
- storage (required, `QhunCore.Storage | QhunCore.ProfileStorage`) - *The storage to access values*
- value (required, any) - *The value that should be stored*