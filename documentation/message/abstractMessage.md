# QhunCore documentation of `QhunCore.AbstractMessage` in `classes/message/abstractMessage.lua`

This is an abstract class that should not be instantiated outside a class constructor context. All message related classes should have this class as its parent to allow an interface like design pattern.

The thought of an instantiated message was that parameters can be configured without directly send the message. It is also possible to watch for message response within this class context if this is nessesary.

## Example

This example provides a usage possability of this abstract class. A simple class called `MyAddon.MyLogger` uses this abstract class to log data to different channels.

```lua
-- create the class
MyAddon.MyLogger = {}
-- set the class metatable
MyAddon.MyLogger.__index = MyAddon.MyLogger

-- create the constructor
function MyAddon.MyLogger.new(text, logLevel)

    -- call super class (no storage for this object)
    local instance = QhunCore.AbstractMessage.new(text)

    -- add the text and logLevel to the instance properties
    instance._logLevel = logLevel

    -- bind current values
    setmetatable(instance, MyAddon.MyLogger)

    -- return the instantiated class
    return instance
end

-- set inheritance to QhunCore.AbstractMessage
setmetatable(MyAddon.MyLogger, {__index = QhunCore.AbstractMessage})

--[[
    now implement all public abstract functions!
]]
function MyAddon.MyLogger:send()

    -- create a switch
    local switch = {
        LOG_LEVEL_DEBUG = function()
            print(self._text)
        end,
        LOG_LEVEL_WARNING = function()
            QhunCore.WarningMessage.new(self._text):send()
        end,
        LOG_LEVEL_ERROR = function()
            QhunCore.ErrorMessage.new(self._text):send()
        end
    }

    -- execute the switch
    local fktn = switch[self._logLevel]

    -- execute the defined callback if available
    if type(fktn) == "function" then
        fktn()
    else
        print("Given parameter logLevel has an unknown value")
        return false
    end

    return true
end
```

---

# Static API

## Constructor

## QhunCore.AbstractMessage `QhunCore.AbstractMessage.new()`

Constructs the class and allow LUA to access the abstract functions.

**Returns:** An instance of `QhunCore.AbstractMessage`

---

## PUBLIC ABSTRACT FUNCTIONS

These methods must be implemented in the concrete class!

## boolean `send()`

Send the configured text to the destination channel

**Returns:** TRUE on success and otherwise FALSE