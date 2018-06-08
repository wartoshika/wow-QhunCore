# QhunCore documentation of `QhunCore.TextUiElement` in `classes/ui/textUiElement.lua`

This is a simple text ui element to show a static text to the user.

## Example

```lua
-- a simple white text with default settings
local white = QhunCore.TextUiElement.new("my awesome lable")

-- a red text
local red = QhunCore.TextUiElement.new("my awesome lable", {
    color = {
        r = 1,
        g = 0,
        b = 0
    }
})

-- a large green text
local green = QhunCore.TextUiElement.new("my awesome lable", {
    fontSize = 16,
    color = {
        r = 0,
        g = 1,
        b = 0
    }
})
```

---

# Static API

## Constructor

## QhunCore.TextUiElement `QhunCore.TextUiElement.new(text[, settings])`

Constructs a new instance of the TextUiElement.

**Parameters:**
- text (required, string) - *The visible translated text for the interface*
- settings (optional, complex table) - *All applicable settings for this ui element*

<details><summary>Structure of <i><u>settings</u></i></summary>
<p>

```
{
    -- the visible font width
    fontSize?: number = 11,
    -- the color in RGB from 0 to 1
    color?: {
        r: number = 1,
        g: number = 1,
        b: number = 1
    },
    -- adds some extra padding to this element
    padding?: number = 0
}
```

</p>
</details>

**Returns:** A constructed preconfigured instance