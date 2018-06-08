# QhunCore documentation of `QhunCore.CheckboxUiElement` in `classes/ui/checkboxUiElement.lua`

This is a simple checkbox element for the user interface.

## Example

```lua
-- print addon load to console
local addonLoadAnnounceCheckbox = QhunCore.CheckboxUiElement.new("Print addon load to console?", "addonLoadAnnounce", {
    -- large padding!
    padding = 20
})
```

---

# Static API

## Constructor

## QhunCore.CheckboxUiElement `QhunCore.CheckboxUiElement.new(lable, storageIdentifyer[, settings])`

Constructs a new instance of the CheckboxUiElement.

**Parameters:**
- lable (required, string) - *The visible lable that stands before the textbox with a small padding*
- storageIdentifyer (required, string) - *The identifyer to access the stored value for the textbox*
- settings (optional, complex table) - *All applicable settings for this ui element*

<details><summary>Structure of <i><u>settings</u></i></summary>
<p>

```
{
    padding?: number = 0
}
```

</p>
</details>

**Returns:** A constructed preconfigured instance