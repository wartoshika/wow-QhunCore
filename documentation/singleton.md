# QhunCore documentation of `QhunCore.Singleton` in `classes/singleton.lua`

This class is an abstract class that provides a singleton like design pattern for classes. Singletons are stored by its class name in a stack to access those class instances from a static context everywhere within your code.

## Example

This is an example class that uses the singleton class as its parent class and allow other classes/methods to access this instance

```lua
QhunCore.Timer = {}
QhunCore.Timer.__index = QhunCore.Timer

-- constructor
function QhunCore.Timer.new()
    -- call super constructor
    local instance = QhunCore.Singleton.new()

    -- bind instance to singleton
    instance:bindInstance("QhunCore.Timer")

    -- set class metatable
    setmetatable(instance, QhunCore.Timer)

    return instance
end

-- set inheritance
setmetatable(QhunCore.Timer, {__index = QhunCore.Singleton})
```

You can now call the singleton getter method from where the class is available in two possible ways:
- `QhunCore.Timer.getInstance("QhunCore.Timer")`
- `QhunCore.Singleton.getInstance("QhunCore.Timer")`

Each of there functions will return your bound instance. Due to the non existing object orientation and reflection there is no way to get the class name automaticly. You need to bind your instance to a good name (I suggest the class name).

---

# Static API

## Constructor

## QhunCore.Singleton `QhunCore.Singleton.new()`

Constructs a new abstract instance of the singleton class. This constructor function should be called in your own class constructor context.

---

## PUBLIC STATIC FUNCTIONS

## (? extends QhunCore.Singleton) `QhunCore.Singleton.getInstance(name)`

Get the previously bound instance by its unique name.

**Parameters:**
- name (required, string) - *A unique name that will be used to bind the instance to*

**Returns:** Whatever instance you bound to or nil if the given name has no instance.

---

## PUBLIC FUNCTIONS

## nil `bindInstance(name)`

Binds the current instance to this name in a singleton like context.

**Parameters:**
- name (required, string) - *The unique name that is used to access this instance later*
