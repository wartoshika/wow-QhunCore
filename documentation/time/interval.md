# QhunCore documentation of `QhunCore.Interval` in `classes/time/interval.lua`

This class represents a recurring async task.

## Example

This example will use the interval class to print a text every 500 milliseconds. The interval will stop when reaching 10 prints.

```lua
local task = QhunCore.Interval.new(500)
local printCounter = 0
task:start(function()

    print("500ms pased")

    -- increment counter
    printCounter = printCounter + 1

    -- stop if print timer reached
    if printCounter == 10 then
        task:complete()
    end
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

**Important:** The callback function is not called once immediately after running the start function!

**Parameters:**
- callback (required, function) - *The function that will be executed after the amount of time passed*

## nil `complete()`

Stops the recurring task. You can start the task any time again when using the `start(...)` method.