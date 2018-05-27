QhunCore.Translation = {}
QhunCore.Translation.__index = QhunCore.Translation

-- constructor
function QhunCore.Translation.new()
    -- private properties
    local instance = {
        _fallback = ""
    }

    setmetatable(instance, QhunCore.Translation)
    return instance
end

--[[
    PUBLIC FUNCTIONS
]]
-- registers a new locale
--[[
  -- string of two chars for the language
  localeName: string,
  localeValues: {
    -- the key represents the later access possability
    -- the value can have params. they are declared as _varName_
    [uniqueStringIdentifyer: string]: string
  } = {},
  isFallback?: boolean = false
]]
function QhunCore.Translation:registerLanguage(localeName, localeValues, isFallback)
    -- default fallback option
    if isFallback == nil then
        isFallback = false
    end

    -- set the locale values
    self["_" .. localeName] = localeValues

    -- set fallback
    if isFallback then
        self._fallback = localeName
    end

    -- print debug
    qhunDebug('A locale "' .. localeName .. '" was registered')
end

-- translates the given identifyer
--[[
    identifyer: string,
    variables: {[variableName: string]: string|number}
]]
function QhunCore.Translation:translate(identifyer, variables)

    -- get the current game client language
    local gameClientLanguage = GetLocale():sub(0, 2)
    local translated = {}

    -- try accessing the current game client language
    if type(self["_" .. gameClientLanguage]) ~= "nil" and type(self["_" .. gameClientLanguage][identifyer]) ~= "nil" then
        -- variable was found!
        translated = self["_" .. gameClientLanguage][identifyer]
    elseif
        self._fallback:len() > 0 and type(self["_" .. self._fallback]) ~= "nil" and
            type(self["_" .. self._fallback][identifyer]) ~= "nil"
     then
        -- variable was found in the fallback language!
        translated = self["_" .. self._fallback][identifyer]
    else
        -- variable was not found!
        QhunCore.ErrorMessage.new(identifyer .. " was not found in the language file"):send()
        return "MISS_LANG:" .. identifyer
    end

    -- parse the variables
    -- add empty table if vars is nil
    if variables == nil then
        variables = {}
    end

    -- parse variables
    for k, v in pairs(variables) do
        translated = translated:gsub("_" .. k .. "_", v)
    end

    -- check if the translated value contains a link to another entry
    if translated:sub(1, 2) == "@@" then
        -- a link is available, parse that link
        translated = self:translate(translated:sub(3), variables)
    end

    return translated
end

-- translates the given identifyer and print the result onto the default console
function QhunCore.Translation:printTranslate(identifyer, variables)
    QhunCore.ConsoleMessage.new(self:translate(identifyer, variables)):send()
end
