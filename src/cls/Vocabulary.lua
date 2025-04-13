local ClassPrototype = require("ClassPrototype")
local Vocabulary = ClassPrototype:new()
Vocabulary.__index = Vocabulary

local GRANULARITY_LEVELS = {"words","subwords"}

function Vocabulary:new(granularity)
    local instance = ClassPrototype:new()

    local granularity = granularity or GRANULARITY_LEVELS[1]
    instance:set("granularity", granularity)
    :set("tokens", {})

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function Vocabulary:push(t)
    local tokens = self:get("tokens")
    tokens[#tokens+1] = t
end

return Vocabulary