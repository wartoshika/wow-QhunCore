# QhunCore documentation of `QhunCore.SliderUiElement` in `classes/ui/sliderUiElement.lua`

This is a simple slider with min and max values for the user interface.

## Example

```lua
-- a font size slider
local fontSizeSlider = QhunCore.SliderUiElement.new("my awesome slider lable", "my.storage.id", {
    -- min font size is 4
    min = 4,
    -- max font size is 16
    max = 16
})

-- a translarency slider
local translarencySlider = QhunCore.SliderUiElement.new("a cool alpha value slider", "my.alpha.storage", {
    -- 0 to 1 transparency (0 to 100%)
    min = 0,
    max = 1,

    -- only change if the decimal a deep decimal value changes
    decimals = 2
})
```

---

# Static API

## Constructor

## QhunCore.SliderUiElement `QhunCore.SliderUiElement.new(lable, storageIdentifyer[, settings])`

Constructs a new instance of the SliderUiElement.

**Parameters:**
- lable (required, string) - *The visible lable that stands before the textbox with a small padding*
- storageIdentifyer (required, string) - *The identifyer to access the stored value for the textbox*
- settings (optional, complex table) - *All applicable settings for this ui element*

<details><summary>Structure of <i><u>settings</u></i></summary>
<p>

```
{
    -- the minimal slider value
    min?: number = 0
    -- the maximal slider value
    max?: number = 100,
    -- the width of the slider element
    width?: number = 250,
    -- the step width for the knob
    steps?: number = 1,
    -- amount of decimals that should be used to think that the value has been changed
    decimals?: number = 0,
    padding?: number = 0,
    -- shows this tooltip when hovering over the slider
    tooltip?: string = nil
}
```

</p>
</details>

**Returns:** A constructed preconfigured instance