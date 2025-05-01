local ClassPrototype = require("ClassPrototype")
local Vocabulary = ClassPrototype:new()
Vocabulary.__index = Vocabulary

local VOCABULARY_DEFAULT_NAME = "Unnamed"
local GRANULARITY_LEVELS = {"words","subwords"}

function Vocabulary:new(tokens, granularity, name)
    local instance = ClassPrototype:new()

    local granularity = granularity or GRANULARITY_LEVELS[1]
    local name = name or VOCABULARY_DEFAULT_NAME
    local tokens = tokens or {}

    instance:set("granularity", granularity)
    :set("name", name)
    :set("tokens", tokens)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function Vocabulary:print()
    local tokens = self:get("tokens")
    print(self:get("name").." Vocabulary")
    print("\tGranularity level: "..self:get("granularity"))
    for i = 1, #tokens do
        print('\tToken #'..i..': "'..tokens[i]..'"')
    end
end

function Vocabulary:push(t)
    local tokens = self:get("tokens")
    tokens[#tokens+1] = t
end

return Vocabulary