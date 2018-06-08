QhunCore.MigrationExecutor = {}
QhunCore.MigrationExecutor.__index = QhunCore.MigrationExecutor

-- constructor
function QhunCore.MigrationExecutor.new()
    -- private properties
    local instance = {
        _migrationStack = {}
    }

    setmetatable(instance, QhunCore.MigrationExecutor)

    return instance
end

--[[
    PUBLIC STATIC FUNCTIONS
]]
-- registers a migration to be proceed before the addon is loaded.
-- IMPORTANT: Migrations will be executed in the order of registration!
--[[
    {
        -- the migration class to proceed
        migration: QhunCore.AbstractMigration
    }
]]
function QhunCore.MigrationExecutor.registerMigration(migration)
    table.insert(migrationStack, migration)
end

--[[
    PUBLIC FUNCTIONS
]]
-- runs all registered migrations
--[[
    {
        migrations: QhunCore.AbstractMigration[]
    }
]]
function QhunCore.MigrationExecutor:runMigrations(migrations)

    -- save the migrations
    self._migrationStack = migrations
end
