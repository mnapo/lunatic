local TokenList = ClassPrototype:new()
TokenList.__index = TokenList

local ERROR_INSUFFICIENT_TOKENS = "There's not enough tokens to sort (there should be two at least)"
local MIN_TOKENS = 2

function TokenList:new(morpheme)
    local instance = ClassPrototype:new()

    local morpheme = morpheme or ""

    instance:set("tokens", {})

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function TokenList:add(morpheme, frequency)
    local morpheme = morpheme or ""
    local frequency = frequency or 1
    local tokens = self:get("tokens")
    tokens[#tokens+1] = {morpheme=morpheme, frequency=frequency}
    return self
end

function TokenList:add_token(morpheme, frequency)
    self:add(morpheme, frequency)
    return self
end

function TokenList:count()
    return #self:get("tokens")
end

function TokenList:get_token_id_by_morpheme(morpheme)
end

function TokenList:remove_token_by_morpheme(morpheme)
end

function TokenList:print()
    print(self:get("morpheme"))
end

function TokenList:sort_by_frequency(descending)
    local tokens = self:get("tokens")
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

return TokenList