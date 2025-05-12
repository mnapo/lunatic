local ClassPrototype = require("ClassPrototype")
local TestsDispatcher = ClassPrototype:new()
TestsDispatcher.__index = TestsDispatcher


function TestsDispatcher:new(visible_titles, visible_descriptions, visible_times)

    local visible_titles = visible_titles or false
    local visible_descriptions = visible_descriptions or false
    local visible_times = visible_times or false

    local instance = ClassPrototype:new()
    :set("visible_titles", visible_titles)
    :set("visible_descriptions", visible_descriptions)
    :set("visible_times", visible_times)
    :set("execution_time", 0)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

return TestsDispatcher