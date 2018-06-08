# QhunCore documentation of `QhunCore.SelectboxUiElement` in `classes/ui/selectboxUiElement.lua`

This is a simple slider with min and max values for the user interface.

## Example

```lua
-- pizza order selectbox
local pizzaSelector = QhunCore.SelectboxUiElement.new("Choose pizza", "pizza.storage", {
    PIZZA_MARGARITA = "Pizza Margarita",
    PIZZA_TONNO = "Pizza Tonno",
    PIZZA_QHUN = "Surprise Pizza!"
}, {
    width = 100
}, function(choosenPizza)
    print("You have choosen the pizza with the key", choosenPizza)
end)
```

---

# Static API

## Constructor

## QhunCore.SelectboxUiElement `QhunCore.SelectboxUiElement.new(lable, storageIdentifyer, values[, settings[, onChangeCallback]])`

Constructs a new instance of the SelectboxUiElement.

**Parameters:**
- lable (required, string) - *The visible lable that stands before the textbox with a small padding*
- storageIdentifyer (required, string) - *The identifyer to access the stored value for the textbox*
- values (required, simple table) - *The values for the selectbox*
- settings (optional, complex table) - *All applicable settings for this ui element*
- onChangeCallback (optional, `function(newSelectedKey: string)`) - *A function that will be called after the select box has been changed)*

<details><summary>Structure of <i><u>values</u></i></summary>
<p>

```
{
    -- a unique key that represents the selected value. the value of the table
    -- is the visible part
    [uniqueKey: string]: string
}
```

</p>
</details>

<details><summary>Structure of <i><u>settings</u></i></summary>
<p>

```
{
    padding?: number = 0,
    -- the width of the selectbox
    width?: number = 150
}
```

</p>
</details>

**Returns:** A constructed preconfigured instance