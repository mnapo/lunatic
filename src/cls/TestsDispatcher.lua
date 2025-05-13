local ClassPrototype = require("ClassPrototype")
local TestsDispatcher = ClassPrototype:new()
TestsDispatcher.__index = TestsDispatcher

local SINGLETON_TESTS_DISPATCHER = ClassPrototype:new()

function TestsDispatcher:new(visible_titles, visible_descriptions, visible_times)

    local visible_titles = visible_titles or false
    local visible_descriptions = visible_descriptions or false
    local visible_times = visible_times or false

    SINGLETON_TESTS_DISPATCHER
    :set("visible_titles", visible_titles)
    :set("visible_descriptions", visible_descriptions)
    :set("visible_times", visible_times)
    :set("execution_time", 0)

    SINGLETON_TESTS_DISPATCHER = setmetatable(SINGLETON_TESTS_DISPATCHER, self)
    SINGLETON_TESTS_DISPATCHER.__index = self
    return SINGLETON_TESTS_DISPATCHER
end

function TestsDispatcher:print_test_execution_time(test)
end

function TestsDispatcher:print_test_description(test)
end

function TestsDispatcher:print_test_title(test)
end

function TestsDispatcher:print_test(test)
end

function TestsDispatcher:print_total_execution_time()
end

return TestsDispatcher