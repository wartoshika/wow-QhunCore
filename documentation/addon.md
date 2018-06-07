# QhunCore documentation of `classes/addon.lua`

This class represents a single addon and provides functionality to handle addon load and unload phases, registering translation files, add user interface options or do many other init stuff for your addon.

## Example

An example that uses this addon class is my `QhunUnitHealth` addon. The `registerAddonLoad` function let you define a callback that will be executed during the *PLAYER_LOGIN* event.

```lua
local addonName = "QhunUnitHealth"

QhunCore.Addon.new(addonName):registerAddonLoad(
    function(addon)
        -- register addon languages
        QhunUnitHealth.Translation = QhunCore.Translation.new()

        -- register all known languages
        QhunUnitHealth.Translation:registerLanguage("de", QhunUnitHealth.TranslationValues.de)
        QhunUnitHealth.Translation:registerLanguage("en", QhunUnitHealth.TranslationValues.en, true)

        -- load all variables from the storage
        QhunUnitHealth.Storage = QhunCore.Storage.new(addonName, "global", false)
        QhunUnitHealth.Storage:setDefaultValues(QhunUnitHealth.DefaultOptions)

        -- print load success message
        QhunUnitHealth.Translation:printTranslate(
            "ADDON_LOAD_SUCCESS",
            {
                version = GetAddOnMetadata(addonName, "Version"),
                name = GetAddOnMetadata(addonName, "Title")
            }
        )

        -- create ui
        QhunUnitHealth.Ui = QhunUnitHealth.Ui.new()
        QhunUnitHealth.Ui:createFrames()
        QhunUnitHealth.Ui:registerEvents()

        -- create interface options
        addon:registerInterfaceSettings(QhunUnitHealth.Storage, QhunUnitHealth.InterfaceOptions.generateOptions())
    end
):registerAddonUnload(
    function(addon)
        print("QhunUnitHealth unload")
    end
)

```

# Static API

## PUBLIC FUNCTIONS

## QhunCore.Addon `registerAddonLoad(callbackFunction)`

Registers a callback function to be called during the initialisation. Most WoW functions will be available at this time. The *PLAYER_LOGIN* event is used to call those functions.

**Parameters:**
- callbackFunction (required, function) - *The function that should be called during initialisation*

**Returns:** Self

## QhunCore.Addon `registerAddonUnload(callbackFunction)`

Registers a callback function to be called during the unload phase of WoW addons. The *PLAYER_LOGOUT* event will be used to call those functions.

**Parameters:**
- callbackFunction (required, function) - *The function that should be called during the unload phase*

**Returns:** Self

## QhunCore.Addon | FALSE `registerInterfaceSettings(storage, interfaceOptions)`

Registers addon specific interface settings to let the user configure some parameters of your addon.

**Parameters:**
- storage (required, `QhunCore.Storage` | `QhunCore.ProfileStorage`) - *The storage to store the changed values in*
- interfaceOptions (required, complex table) - *The interface options*

<details><summary>Structure of <i><u>interfaceOptions</u></i></summary>
<p>

```
    {
        -- if the order key is given, the interface generator will preserve the given
        -- order.
        _order?: {
            -- the value should be the unique key used for interfaceOptions string
            [noKeyGiven: nil]: string
        },
        -- first option is the main page
        -- every other option will have a sub category
        -- the interfaceOptions key must be unique als will be used
        -- to open the interface option to this category
        [interfaceOptions: string]: {
            -- the visible name for the category
            name: string
            -- if the category is disabled or not
            disabled?: boolean = false
            -- every element that will be rendered
            -- on the settings page
            elements: {? extends QhunCore.AbstractUiElement}[] | QhunCore.ProfileUiElement
        }
    }
```

</p>
</details>
<details><summary>An example for the <i><u>registerInterfaceSettings</u></i> function</summary>
<p>

```lua
addon:registerInterfaceSettings(QhunUnitHealth.Storage, {
        _order = {
            "MAIN_OPTIONS",
           -- "PLAYER_OPTIONS",
           -- "TARGET_OPTIONS",
           -- "TARGET_OF_TARGET_OPTIONS",
           -- "FOCUS_OPTIONS",
           -- "PARTY_OPTIONS"
        },
        MAIN_OPTIONS = {
            name = "QhunUnitHealth",
            elements = {
                QhunCore.TextUiElement.new(
                    t:translate("SETTINGS_MAIN_ENTRY"),
                    {
                        padding = 10
                    }
                ),
                QhunCore.TextUiElement.new(
                    t:translate("SETTINGS_MAIN_ENABLE_DISABLE_FEATURES"),
                    {
                        fontSize = 13,
                        color = {r = 1, g = 215 / 255, b = 0},
                        padding = 10
                    }
                ),
                QhunCore.CheckboxUiElement.new(t:translate("SETTINGS_MAIN_ENABLE_PLAYER"), "PLAYER_ENABLED"),
                QhunCore.CheckboxUiElement.new(t:translate("SETTINGS_MAIN_ENABLE_TARGET"), "TARGET_ENABLED"),
                QhunCore.CheckboxUiElement.new(
                    t:translate("SETTINGS_MAIN_ENABLE_TARGET_OF_TARGET"),
                    "TARGET_OF_TARGET_ENABLED"
                ),
                QhunCore.CheckboxUiElement.new(t:translate("SETTINGS_MAIN_ENABLE_FOCUS"), "FOCUS_ENABLED"),
                QhunCore.CheckboxUiElement.new(
                    t:translate("SETTINGS_MAIN_ENABLE_PARTY"),
                    "PARTY_ENABLED",
                    {
                        padding = 10
                    }
                ),
                QhunCore.TextUiElement.new(
                    t:translate("SETTINGS_MAIN_OTHER_SETTINGS"),
                    {
                        fontSize = 13,
                        color = {r = 1, g = 215 / 255, b = 0},
                        padding = 15
                    }
                ),
                QhunCore.TextUiElement.new(
                    t:translate("SETTINGS_MAIN_DIVIDER_TEXT"),
                    {
                        fontSize = 11
                    }
                ),
                QhunCore.TextboxUiElement.new(t:translate("SETTINGS_MAIN_DIVIDER"), "DIVIDER")
            }
        },
        -- PLAYER_OPTIONS = generateSubOption(t, "PLAYER", "PLAYER"),
        -- TARGET_OPTIONS = generateSubOption(t, "TARGET", "TARGET"),
        -- TARGET_OF_TARGET_OPTIONS = generateSubOption(t, "TARGET_OF_TARGET", "TARGET_OF_TARGET"),
        -- FOCUS_OPTIONS = generateSubOption(t, "FOCUS", "FOCUS"),
        -- PARTY_OPTIONS = generateSubOption(t, "PARTY", "PARTY")
})
```

</p>
</details>