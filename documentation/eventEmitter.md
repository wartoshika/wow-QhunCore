# QhunCore documentation of `QhunCore.EventEmitter` in `classes/eventEmitter.lua`

This class provides an easy way to bind callback functions to your own defined events. The Events are stored within one instance of the event emitter. You should save this instance in your addon context to access it from different classes/functions.

**Important:** This event emitter does not include WoW specific events!

## List of QhunCore Events

- **STORAGE_UNCOMMITTED_CHANGED** with parameters **(identifyer, value)**
  <br />
  Is emitted if the storage has new uncommited changes in the pipeline.
  <br />
  **Parameters:**
  - identifyer (string) - *The full identifyer for the changed value*
  - value (any) - *The value that was written to the storage*
- **STORAGE_COMMITTED** with parameters **(uncommitedChanges)**
  <br />
  Is emitted if all uncommited values has been commited and written to the persistence layer.
  <br />
  **Parameters:**
  - uncommitedChanges (table) - *All values that has been commited as neasted table*
- **STORAGE_RESET** with no parameters
  <br />
  Is emitted if all uncommited storage value has been reset.

## Example

An example from my `QhunUnitHealth` addon where i use this event emitter. This example show the usage of the global core event emitter instance to update frame settings if the storage received new uncommited values.

```lua
-- and apply all options immediately
QhunCore.EventEmitter.getCoreInstance():on(
    "STORAGE_UNCOMMITTED_CHANGED",
    function()
        -- apply the changes to all frames
        for _, frame in pairs(self._uiFrameStack) do
            frame:updateFrameSettings()
        end
    end
)
```

This is a procedural example where i define an instance, bind an event to it and finally emit this event with parameters.

```lua
-- create an instance
local eventEmitter = QhunCore.EventEmitter.new()

-- bind an event and store the uuid to remove this event later
local uuid = eventEmitter:on("YOUR_EVENT_NAME", function(arg1, arg2)

    -- print arg1 and arg2
    print(arg1, arg2)
end)

-- now emit this event
eventEmitter:emit("YOUR_EVENT_NAME", "arg1Value", "arg2Value")

-- remove the event from the emitter
eventEmitter:remove("YOUR_EVENT_NAME", uuid)
```

# Static API

## Constructor

## QhunCore.EventEmitter `QhunCore.Addon.new([isCore = false])`

The constructor on the event emitter. You should not pass any arguments to this constructor function. The parameter is needed to construct the QhunCore event emitter instance that you can use later to listen to storeage change and other core vents.

**Parameters:**
- isCore (optional, boolean, default FALSE) - *The flag if the event emitter instance is the QhunCore instance*

---

## PUBLIC STATIC FUNCTIONS

## QhunCore.EventEmitter `QhunCore.EventEmitter.getCoreInstance()`

Get the QhunCore event emitter instance for core events.

**Returns:** The `QhunCore.EventEmitter` instance of QhunCore.

---

## PUBLIC FUNCTIONS

## string `on(eventName, callback)`

Registers a callback function to be called when the given event name is emitted.

**Parameters:**
- eventName (required, string) - *The event name that must be called if your given callback is executed*
- callback (required, function) - *The function that should be executed on event happening*

**Returns:** A uuid string to remove the function later.

## nil `emit(eventName[, ...])`

Emits the given event and passes all other arguments as vararg to the registered functions.

**Parameters:**
- eventName (required, string) - *The event name*
- ... (optional, vararg) - *Any other parameters that will be passed in that order to the registered callback functions*

## boolean `remove(eventName, uniqueReference)`

Removes the callback function from the internal stack by specifying its unique reference and the event name.

**Parameters:**
- eventName (required, string) - *The event name that is equal to the registered event name*
- uniqueReference(required, string) - *The unique reference id that you got by using the function `on()`*

**Returns:** A boolean value that is TRUE if the event was removed. Otherwise FALSE.

---

## PRIVATE STATIC FUNCTIONS

## nil `QhunCore.EventEmitter.overrideCoreInstance(instance)`

Overrides the internal core instance. This function is used to make unit tests available and should not be used in third party addons!

**Parameters:**
- instance (required, `QhunCore.EventEmitter`) - *The new core event emitter instance*