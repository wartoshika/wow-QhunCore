# Documentation of QhunCore Version 3.0.0

This documentation file should provide you an overview over the main features of QhunCore. The other markdown files serve the static API of classes and functions. You can always refer to some other addon that I wrote to see how QhunCore works in an example project.

All classes and functions are bound to the global variable namespace and are accessable from every cornor of LUA. I prefixed everything with a reasonable string to avoid overriding other addon's functions.

## Features

- Easy to use storage mechanism that handles character and global saved variables and also provides a possability to handle profile like storage.
- A message bus that can differ between debug, normal, warning and error messages. There are also message classes that can send to the addon channel.
- Simple interface settings by just providing a table with the preconfigured interface elements.
- An event emitter and listener system that allows to talk in a very efficient way with other classes/methods and even other addons.
- A translation system that handles multiple languages, fallback language and the replacement of variables in the language file.

## List of example projects that uses QhunCore

- `QhunUnitHealth` (Github: [wartoshika/wow-QhunUnitHealth](https://github.com/wartoshika/wow-QhunUnitHealth))

## Folderstructure

- **Addon-Root**

    Some of the files are stored in the addon root folder. These files provide functionality for all categories of the core addon, but they are not important to review for you. The only exception is the `functions.lua` file where i store global functions without a class context. All These functions are prefixed with `qhun*`.

- **classes**

    This is the folder where the main addon logic takes place. Every class provides a context sensitive functionality that can be used by instantiating a class and using this class reference in your local addon context. Subdirectories should contain a group of classes that belolgs to the same category.

- **documentation**

    The storage for the documentation files. Not important for you

- **tests**

    The storage for all unit and integration test files that are using my `QhunUnitTest` addon. This is also not important for you.

## Setup your addon to work with QhunCore

You must create an instance of the `QhunCore.Addon` class by calling its constructor function `QhunCore.Addon.new(...)`. *(See [QhunCore.Addon](./addon.md) documentation)*

This is an example to get your addon ready for QhunCore:

```lua
local addonName = "YourAddonName"

QhunCore.Addon.new(addonName):registerAddonLoad(
    function(addon)
        -- init parts of your addon
    end
):registerAddonUnload(
    function(addon)
        -- commit the storage or do any other task at the unload phase of your addon
    end
)
```

In the callback of the `registerAddonLoad` function you can do the following things with the QhunCore API:

- Register translation files
- Register storages or profile storages
- Register interface options for your addon
- And do a lot of more stuff that needs to be initiated while the addon load phase

**Behind the scenes:** The *PLAYER_LOGIN* event is used to init your addon. Please refer to the WoW event API to see which WoW functions are available at this point. Generally most of the WoW API should be available!

## Static API of all classes

You can review every class in its own documentation file. This list should provide you with links and a list of all classes and functions

- `functions.lua` ([Documentation](./functions.md))
- classes folder
- `QhunCore.Addon` ([Documentation](./addon.md))
- `QhunCore.EventEmitter` ([Documentation](./eventEmitter.md))
- `QhunCore.Translation` ([Documentation](./translation.md))
- storage folder
- `QhunCore.Storage`  ([Documentation](./storage/storage.md))
- `QhunCore.ProfileStorage`  ([Documentation](./storage/profileStorage.md))
- message folder
- `QhunCore.AbstractMessage`  ([Documentation](./message/abstractMessage.md))
- `QhunCore.ConsoleMessage`  ([Documentation](./message/consoleMessage.md))
- `QhunCore.WarningMessage`  ([Documentation](./message/warningMessage.md))
- `QhunCore.ErrorMessage`  ([Documentation](./message/errorMessage.md))
- ui folder
- `QhunCore.InterfaceRenderer` ([Documentation](./ui/interfaceRenderer.md))
- `QhunCore.InterfaceSettingGenerator` ([Documentation](./ui/interfaceSettingGenerator.md))
- `QhunCore.AbstractUiElement` ([Documentation](./ui/abstractUiElement.md))
- `QhunCore.CheckboxUiElement` ([Documentation](./ui/checkboxUiElement.md))
- `QhunCore.ProfileUiElement` ([Documentation](./ui/profileUiElement.md))
- `QhunCore.SelectboxUiElement` ([Documentation](./ui/selectboxUiElement.md))
- `QhunCore.SliderUiElement` ([Documentation](./ui/SliderUiElement.md))
- `QhunCore.TableUiElement` ([Documentation](./ui/tableUiElement.md))
- `QhunCore.TextboxUiElement` ([Documentation](./ui/textboxUiElement.md))
- `QhunCore.TextUiElement` ([Documentation](./ui/textUiElement.md))