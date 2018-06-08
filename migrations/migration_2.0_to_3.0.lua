QhunCore.Migrations.Version_2_0_to_3_0 = {}
QhunCore.Migrations.Version_2_0_to_3_0.__index = QhunCore.Migrations.Version_2_0_to_3_0

-- constructor
function QhunCore.Migrations.Version_2_0_to_3_0.new()

    -- construct the parent class
    local instance = QhunCore.AbstractMigration.new()

    setmetatable(instance, migration)

    return instance
end

--[[
    PUBLIC FUNCTIONS
]]
function QhunCore.Migrations.Version_2_0_to_3_0:forward()
    print("FORWARD!")
end

function QhunCore.Migrations.Version_2_0_to_3_0:rollback()
    print("ROLLBACK!")
end