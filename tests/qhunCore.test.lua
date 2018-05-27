-- check if the unit test addon is available
if IsAddOnLoaded("QhunUnitTest") then
    -- create a test suite
    local suite = QhunUnitTest.Suite.new("QhunCore")

    -- register all known unit tests
    suite:registerClass("EventEmitter", QhunCore.Test.EventEmitter.new())
    suite:registerClass("Translation", QhunCore.Test.Translation.new())
    suite:registerClass("Storage", QhunCore.Test.Storage.new())
    suite:registerClass("functions.lua", QhunCore.Test.Function.new())

    -- register for slash
    suite:registerForSlashCommand()
end
