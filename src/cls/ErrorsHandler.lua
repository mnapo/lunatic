local ClassPrototype = require("ClassPrototype")
local ErrorsHandler = ClassPrototype:new()
ErrorsHandler.__index = ErrorsHandler

local MODES = {
    "verbose",
    "silent"
}

function ErrorsHandler:new(mode)
    local instance = ClassPrototype:new()

    local mode = mode or MODES[1]
    instance:set("mode", mode)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function ErrorsHandler:explain(error)
end

function ErrorsHandler:intercept(error)
end

return ErrorsHandler