QhunCore.AbstractMigration = {}
QhunCore.AbstractMigration.__index = QhunCore.AbstractMigration

-- the private static migration stack
local migrationStack = {}

-- constructor
function QhunCore.AbstractMigration.new()
    -- private properties
    local instance = {}

    setmetatable(instance, QhunCore.AbstractMigration)

    return instance
end

--[[
    PUBLIC ABSTRACT FUNCTIONS
]]
function QhunCore.AbstractMigration:forward()
    QhunCore.ErrorMessage.new("The forward() function should be implemented in the child class!")
    return
end

function QhunCore.AbstractMigration:rollback()
    QhunCore.ErrorMessage.new("The rollback() function should be implemented in the child class!")
    return
end
