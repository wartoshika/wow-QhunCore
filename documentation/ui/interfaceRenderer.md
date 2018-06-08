# QhunCore documentation of `QhunCore.InterfaceRenderer` in `classes/ui/interfaceRenderer.lua`

This class is used to render all given addon interface settings or other objects. It makes problems like element padding, height, width and offset easy to handle.

## Example

This example will render the given elements and shows them on the given parent ui frame.

```lua
-- define renderable elements
local elements = {
    QhunCore.TextboxUiElement.new("Good lable", "my.storage.identifyer", {
        padding = 10,
        boxWidth = 50
    }),
    QhunCore.SliderUiElement.new("Good slider lable", "my.slider.storage.identifyer", {
        mix = 5, max = 20
    })
}

-- create a storage for this example
local storage = QhunCore.Storage.new("exampleAddonName", "exampleStorageName")

-- now start constructing an instance of the renderer
local renderer = QhunCore.InterfaceRenderer.new(
    elements, UIParent, storage,
    0, -- zero padding for the wrapper frame
    {
        -- this values define the horizontal and vertical offset from the parent frame.
        -- the offset is calculated from TOPLEFT
        x = 5,
        y = 5
    }
)

-- the renderer is ready to use. now render those defined ui elements
-- the offsets, heights and widths will automaticly be adjusted.
renderer:render()

```

# Static API

## Constructor

## QhunCore.InterfaceRenderer `QhunCore.InterfaceRenderer.new(elements, parentFrame, storage[, padding = 0[, startOffset = {x=0,y=0}]])`

Constructs an instance of the interface renderer class.

**Parameters:**
- elements (required, `QhunCore.AbstractUiElement[]`) - *The elements to render*
- parentFrame (required, WoW Frame table) - *The element that should be the parent frame of all rendered child frames*
- storage (required, `QhunCore.Storage | QhunCore.ProfileStorage`) - *The storage where the values should be stored in*
- padding (optional, number, default 0) - *The BOTTOM offset for the next element that shoule be drawed*
- startOffset (optional, complex table, default {x=0,y=0}) - *The horizontal and vertical offset for the wrapper frame. Offset is calculated from TOPLEFT origin*

<details><summary>Structure of <i><u>startOffset</u></i></summary>
<p>

```
{
    x: number = 0,
    y: number = 0
}
```

</p>
</details>

---

## PUBLIC FUNCTIONS

## WoW Frame `render()`

Renders all given frames from the constructor onto the ui and binding them to the given parent frame. This function will call every render function from the derived `QhunCore.AbstractUiElement` class. It will create a wrapper frame that will using the width and height properties from the client elements.

**Returns:** The created wrapper frame containing all rendered child elements