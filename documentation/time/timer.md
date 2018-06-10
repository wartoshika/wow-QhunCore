# QhunCore documentation of `QhunCore.Timer` in `classes/time/timer.lua`

This class has a global timer with a good resolution to make async timed tasks with e.g. the `QhunCore.Interval` class. To avoid using to much WoWFrames for a timer, this class uses just one timer and checks if a requested time frame is reached and then it will automaticly call registered callback function.

This is an internal class, i will just provide a static API

---

# Static API

## Constructor

## QhunCore.Timer `QhunCore.Timer.new(resolution)`

Creates an instance of the timer by specifying a resolution. This resolution will be the smallest possible value for registered callback functions.

**Important:** This is a singleton class. This class should be only instantiated once! After instanciating you can access the instance by using the singleton access pattern like `QhunCore.Timer.getInstance("QhunCore.Timer")`

**Parameters:**
- resolution (required, number) - *The resolution time in milliseconds*

**Returns:** A preconfigured instance with a bound singleton context

---

## PUBLIC FUNCTIONS

## nil `startTimer()`

Starts the internal timer with the given resolution.

## string `requestTimerFrame(callback, timeInMilliseconds[, interval = false])`

Requests a timeframe in the global timer. The given callback function will be executed if the given time is reached. If the task should be recurring, you should provide the interval flag with TRUE.

**Parameters:**
- callback (required, function) - *The function that should be executed when the given time is over*
- timeInMilliseconds (required, number) - *A time that musst be reached to call the given callback function*
- interval (optional, boolean = false) - *A that if the task is recurring*

**Returns:** A uuid string that you must store if you want to cancel the task with `cancelTimerFrame(uuid)`

## nil `cancelTimerFrame(uuid)`

Cancels an active async task. If canceld, the task will be deleted immediately without calling a last callback function!

**Parameters:**
- uuid (required, string) - *The uuid that you got from the `requestTimerFrame(...)` function

---

## PRIVATE FUNCTIONS

## nil `onTimerUpdate(timePassed)`

An internal update function that will be called each time the WoWFrame has fired its update event

**Parameters:**
- timePassed (required, number) - *The amount of seconds pased after the last frame draw*

## nil `checkForUpdate(millisecondsDone)`

Requests the timer instance to check all registered callbacks if one of them should be executed.

**Parameters:**
millisecondsDone (required, number) - *The amount of milliseconds that have been pased after the last timer update*