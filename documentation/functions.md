# QhunCore documentation of `functions.lua`

These functions are available to the global LUA namespace. Every function is prefixed with `qhun*` to anil overriding existing functions.

## nil `qhunDump(dumpable)`

Dumps the first parameter onto the default console. This also works for neasted tables. If there is any unprintable element, the builtin `tostring` method is used.

**Parameter:**
- dumpable (required, any) - *the element to dump*

## table `qhunGetTableKeys(tbl)`

Get all keys from the given table.

**Parameters:**
- tbl (required, table) - *the table to get the keys from*

**Returns:** A table containing all keys in a random order.

## nil `qhunDebug(text)`

Prints a given text onto the console. The print will only be executed if a global variable `QHUN_DEBUG` has a truthy value. The given text will be printed using the buildin `print` method.

**Parameters:**
- text (required, string) - *the text to debug print*

## boolean `qhunTableHasValue(table, value)`

Checks if a given table has the given value. The check will use the equal operator (==).

**Parameters:**
- table (required, table) - *The table to test against*
- value (required, any) - *The value to look for*

**Returns:** A boolean value. TRUE if the value was found, FALSE otherwise.

## number `qhunRound(number[, decimals = 0])`

Rounds a given number to the amount of given decimals. 

**Parameters:**
- number (required, number) - *The number to round*
- decimals (optional, number, default 0)

**Returns:** The rounded number

## string `qhunUuid()`

Get a unique string in a UUID style. The returned value cannot be 100% unique because of the underlaying builtin `math.random` function. Dont use this function for security things!

**Returns:** A unique string in the format `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`

## number | nil `qhunTableGetIndexByValue(table, value)`

Get the value's table index.

**Parameters:**
- table (required, table) - *The table to look in*
- value (required, any) - *The value to look for*

**Returns:** The index or nil

## boolean `qhunDerivedFrom(object, class)`

Checks if the given object derived from the given class.

**Parameters:**
- object (required, instantiated table) - *The object to test*
- class (required, class table) - *The class to test against*

**Returns:** A boolean TRUE for a match and otherwise FALSE

## boolean `qhunInstanceOf(object, class)`

Checks if the given object is an instance of the given class. This function does not test for inheritance!

**Parameters:**
- object (required, instantiated table) - *The object to test*
- class (required, class table) - *The class to test against*

**Returns:** A boolean TRUE for a match and otherwise FALSE

## table `qhunTableValueOrDefault(originalTable, defaultValues)`

A function that takes everything from the originalTable and fills missing keys from the defaultValues. This function will also look for neasted table structures.

**Parameters:**
- originalTable (required, table) - *The table containing the current values*
- defaultValues (required, table) - *The table containing default values that will be put into the originalTable*

**Returns:** A table containing everything from the originalTable plus the values from the defaultValues.

## any `qhunGetTableWithDot(originalTable, dottedIdentifyer)`

Gets an element from a table. The identifyer is the key of the table. If the identifyer contains a dot between two keys, the function will look for the element in neasted tables. An example could be `main.layer2.layer3`.

**Parameters:**
- originalTable (required, table) - *The table to look in*
- dottedIdentifyer (required, string) - *The key of the table's element*

**Returns:** The element at the given position or nil if nothing was found.

## nil `qhunSetTableWithDot(originalTable, dottedIdentifyer, value)`

Sets a value at the given table. If a dotted identifyer is given, the function will look for the destination in neasted tables.

**Parameters:**
- originalTable (required, table) - *The table to look in*
- dottedIdentifyer (required, string) - *The key of the table's element*
- value (required, any) - *The value to set*

## table `qhunCloneTable(original)`

Clones a given table including its metatable.

**Parameters:**
- original (required, table) - *The table to clone*

**Returns:** The cloned table

## table `qhunGetMoneyValue(copper)`

Returns the amount of gold, silver and copper from a total copper value

**Parameters:**
- copper (required, number) - *The total copper amount*

**Returns:** The following table structure:
- gold (number) - *the amount of gold*
- silver (number) - *the amount of silver*
- copper (number) - *the amount of copper*
- isNegative (boolean) - *a flag if the given copper value is negative*