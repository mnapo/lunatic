local ClassPrototype = require("ClassPrototype")
local token_list = require("TokenList")
local Vocabulary = ClassPrototype:new()
Vocabulary.__index = Vocabulary

local VOCABULARY_DEFAULT_NAME = "Unnamed"
local GRANULARITY_LEVELS = {"words","subwords"}
local SEPARATOR = "########"

function Vocabulary:new(tokens, granularity, name)
    local instance = ClassPrototype:new()

    local granularity = granularity or GRANULARITY_LEVELS[1]
    local name = name or VOCABULARY_DEFAULT_NAME
    local tokens = tokens or token_list:new()

    instance:set("granularity", granularity)
    :set("name", name)
    :set("tokens", tokens)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function Vocabulary:print()
    local tokens = self:get("tokens")
    print(SEPARATOR)
    print('Vocabulary "'..self:get("name")..'"')
    print('\tGranularity level: "'..self:get("granularity")..'"')
    print("\tTotal tokens: "..tokens:count())
    tokens:print()
    print(SEPARATOR)
end

function Vocabulary:push(token)
    local tokens = self:get("tokens")
    tokens:add(token)
    return self
end

return Vocabulary