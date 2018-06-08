# QhunCore documentation of `QhunCore.InterfaceSettingGenerator` in `classes/ui/interfaceSettingGenerator.lua`

This class is used to generate all addon interface options and append them to the internal WoW interface addon panel.

This is an internal class, i will provide a static API only.

---
# Static API

## Constructor

## QhunCore.InterfaceSettingGenerator `QhunCore.InterfaceSettingGenerator.new(storage, id, displayName, disabled, elements[, parentDisplayName[, padding = 7]])`

This function constructs an instance of `QhunCore.InterfaceSettingGenerator`.

**Parameters:**
- storage (required, `QhunCore.Storage | QhunCore.ProfileStorage`) - *The storage where to store changed values in*
- id (required, string) - *A manualy defined identification name for this setting*
- displayName (required, string) - *A human readable and translated visible name for this setting*
- disabled (required, boolean) - *A flag if this category is disabled or not*
- elements (required, `QhunCore.AbstractUiElement[]`) - *All elements that should be rendered when clicking on this setting category*
- parentDisplayName (optional, string) - *The name of the parent category when this is a child setting category*
- padding (optional, number, default 7) - *The padding that adjusts the next element top offset*

---

## PUBLIC FUNCTIONS

## nil `createInterfaceOption()`

Creates the given addon interface option and register this interface settings with the buildin WoW Interface option.

## nil `render()`

Renders all given UI elements onto the interface settings panel. This function will be skiped if the elements were rendered before.

## nil `commitChanges()`

Commit all unsaved changes in the interface storage

## nil `resetChanges()`

Reset all unsaved changes in the interface storage

## nil `resetInterfaceElements()`

Reset all interface elements to its saved state