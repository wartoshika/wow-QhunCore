# QhunCore documentation of `QhunCore.TextboxUiElement` in `classes/ui/textboxUiElement.lua`

This is a simple text input field for the user interface

## Example

```lua
local textbox = QhunCore.TextboxUiElement.new("my awesome lable", "my.storage.id", {
    boxWidth = 50
})
```

---

# Static API

## Constructor

## QhunCore.TextboxUiElement `QhunCore.TextboxUiElement.new(lable, storageIdentifyer[, settings])`

Constructs a new instance of the TextboxUiElement.

**Parameters:**
- lable (required, string) - *The visible lable that stands before the textbox with a small padding*
- storageIdentifyer (required, string) - *The identifyer to access the stored value for the textbox*
- settings (optional, complex table) - *All applicable settings for this ui element*

<details><summary>Structure of <i><u>settings</u></i></summary>
<p>

```
{
    -- the width of the textbox
    boxWidth?: number = 20
    padding?: number = 0
}
```

</p>
</details>

**Returns:** A constructed preconfigured instance