# QhunCore documentation of `QhunCore.Interval` in `classes/time/interval.lua`

This class represents an async task that will be executed once after the given amount of time.

## Example

This is an example that will wait 2 seconds before printing a message to the console.

```lua
local task = QhunCore.Timeout.new(2000)
task:start(function()

    print("2 seconds passed")
end)
```

---

# Static API

## Constructor

## QhunCore.Interval `QhunCore.Interval.new(timeInMilliseconds)`

Creates a new async recurring task with the given time as interval.

**Parameters:**
- timeInMilliseconds (required, number) - *The time that will be wait before executing the task again*

**Returns:** A preconfigured instance of the interval timer

---

## PUBLIC FUNCTIONS

## nil `start(callback)`

Start the task and call the given callback after the given amount of time.

**Parameters:**
- callback (required, function) - *The function that will be executed after the amount of time passed*