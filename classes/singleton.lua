QhunCore.Singleton = {}
QhunCore.Singleton.__index = QhunCore.Singleton

-- private static properties
local singletonInstanceStack = {}
local getInstance, bindInstance

function QhunCore.Singleton.new()
    local instance = {}
    setmetatable(instance, QhunCore.Singleton)
    return instance
end

--[[
    PUBLIC STATIC FUNCTIONS
]]
function QhunCore.Singleton.getInstance(name)
    return singletonInstanceStack[name]
end

--[[
    PUBLIC FUNCTIONS
]]
function QhunCore.Singleton:bindInstance(name)
    -- set the instance by its table link hash
    singletonInstanceStack[name] = self

    -- print debug
    qhunDebug("A singleton instance was bound to name: " .. name)
end
