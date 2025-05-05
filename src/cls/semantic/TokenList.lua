local ClassPrototype = require("ClassPrototype")
local token = require("Token")
local TokenList = ClassPrototype:new()
TokenList.__index = TokenList

local ERROR_INSUFFICIENT_TOKENS = "There's not enough tokens to sort (there should be two at least)"
local MIN_TOKENS = 2

function TokenList:new(tokens)
    local instance = ClassPrototype:new()

    local tokens = tokens or {}

    instance:set("tokens", tokens)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end


function TokenList:get_tokens()
    return self:get("tokens")
end

function TokenList:count()
    return #self:get_tokens()
end

function TokenList:get_frequency_by_token(token)
    local tokens = self:get_tokens()
    local morpheme = token:get_morpheme()
    for i = 1, #tokens do
        if tokens[i].token:get_morpheme() == morpheme then
            return tokens[i].frequency
        end
    end
    return 0
end

function TokenList:get_frequency(id)
    return self:get_tokens()[id].frequency
end

function TokenList:set_frequency(id, frequency)
    local tokens = self:get_tokens()
    tokens[id].frequency = frequency
end

function TokenList:get_frequency_by_morpheme(morpheme)
    local tokens = self:get_tokens()
    for i = 1, #tokens do
        if tokens[i].token:get_morpheme() == morpheme then
            return tokens[i].frequency
        end
    end
    return 0
end

function TokenList:get_token_by_morpheme(morpheme)
    local tokens = self:get_tokens()
    for i = 1, #tokens do
        if tokens[i].token:get_morpheme() == morpheme then
            return tokens[i].token
        end
    end
    return nil
end

function TokenList:get_id_by_morpheme(morpheme)
    local tokens = self:get_tokens()
    for i = 1, #tokens do
        if tokens[i].token:get_morpheme() == morpheme then
            return i
        end
    end
    return nil
end

function TokenList:exists(morpheme)
    if self:get_id_by_morpheme(morpheme) then
        return true
    end
    return false
end

function TokenList:insert(t, f)
    local tokens = self:get_tokens()
    tokens[#tokens+1] = {token=t, frequency=f}
    return self
end

function TokenList:add(morpheme, frequency)
    local tokens = self:get_tokens()
    local id = self:get_id_by_morpheme(morpheme)
    local frequency = frequency or 1
    if id then
        local new_frequency = tokens[id].frequency+frequency
        self:set_frequency(id, new_frequency)
    else
        local new_token = token:new(morpheme)
        self:insert(new_token, frequency)
    end
    return self
end

function TokenList:add_all(morphemes)
    for i = 1, #morphemes do
        local morpheme = morphemes[i]
        local new_token = token:new(morpheme)
        self:insert(new_token, 1)
    end
    return self
end

function TokenList:remove_token_by_morpheme(morpheme)
end

function TokenList:print()
    local tokens = self:get_tokens()
    for i = 1, #tokens do
        tokens[i].token:print()
        print("\t\t\tfreq. "..tokens[i].frequency)
    end
end

function TokenList:sort_by_frequency(descending)
    local tokens = self:get_tokens()
    if #tokens<MIN_TOKENS then
        return error(ERROR_INSUFFICIENT_TOKENS)
    end
    local compare_frequencies = function(token_1, token_2)
        if descending then
            return token_1.frequency > token_2.frequency
        else
            return token_1.frequency < token_2.frequency
        end
    end
    table.sort(tokens, compare_frequencies)
    return self
end

function TokenList:get_most_frequent()
    local tokens = self:get_tokens()
    local highest_frequency = 0
    local most_frequent = token:new()
    for i = 1, #tokens do
        local frequency = self:get_frequency(i)
        if (frequency > highest_frequency) then
            most_frequent = tokens[i].token
            highest_frequency = frequency
        end
    end
    return most_frequent
end

function TokenList:unify(id1, id2)
    local tokens = self:get_tokens()
    local morpheme1 = tokens[id1].token.morpheme
    local morpheme2 = tokens[id2].token.morpheme
    tokens[id1].token:set_morpheme(morpheme1..morpheme2)
    tokens[id2].token:set_morpheme(nil)
    return self
end

function TokenList:clean()
    local tokens = self:get_tokens()
    local temp = {}
    for i = 1, #tokens do
        local morpheme = tokens[i].token:get_morpheme()
        if (morpheme) then
            temp[#temp+1] = tokens[i]
        end
    end
    self:set("tokens", temp)
end

return TokenList