local M = {}
local token = require("Token")
local token_list = require("TokenList")

M.CAPTURE_PATTERN_START = "([^"
M.CAPTURE_PATTERN_END = "]+)"
M.ERROR_INSUFFICIENT_TOKENS = "There's not enough tokens to sort (there should be two at least)"
M.ERROR_METHOD = "Invalid method"
M.MAX_SUBWORDS_LEARNING = 100
M.MIN_TOKENS = 2
M.TOKENS_THRESHOLD = 10
M.TRACING_SPACE = "_"
M.TRACING_SPACE_DOUBLE = "__"
M.VOCABULARIES_COUNT = 0
M.WHITE_SPACE = "%s"
M.gmatch = string.gmatch
M.len = string.len
M.lower = string.lower
M.sub = string.sub

M.merge = function(list1, list2)
    local tokens = list2:get_tokens()
    for i = 1, list2:count() do
        local frequency = tokens[i].frequency
        local morpheme = tokens[i].token:get_morpheme()
        if list1:exists(morpheme) then
            local id = list1:get_id_by_morpheme(morpheme)
            list1:get_tokens()[id].frequency = list1:get_tokens()[id].frequency + frequency
        else
            list1:add(tokens[i].token, frequency)
        end
    end
    return list1
end

M.sort_by_frequency = function(tokens, descending)
    if #tokens<M.MIN_TOKENS then
        return error(M.ERROR_INSUFFICIENT_TOKENS)
    end
    local compare_frequencies = function(token_1, token_2)
        if descending then
            return token_1.frequency > token_2.frequency
        else
            return token_1.frequency < token_2.frequency
        end
    end
    table.sort(tokens, compare_frequencies)
end

M.trim_less_frequent = function(tokens)
    if #tokens > M.TOKENS_THRESHOLD then
        for i = M.TOKENS_THRESHOLD+1, #tokens do
            tokens[i] = nil
        end
    end
end

M.tokenize_by_characters = function(tokens, quantity)
    local temp = token_list:new()
    local tokens = tokens:get_tokens()
    local quantity = quantity or 1
    quantity = quantity-1
    for i = 1, #tokens do
        local morpheme = tokens[i].token:get_morpheme()
        print(morpheme)
        local length = M.len(morpheme)
        for j = 1, length-quantity do
            local character = M.sub(morpheme, j, j+quantity)
            if temp:exists(character) then
                local id = temp:get_id_by_morpheme(character)
                local new_frequency = temp:get_frequency(id)+1
                temp:set_frequency(id, new_frequency)
            else
                local new_token = token:new(character)
                temp:add(new_token, 1)
            end
        end
    end
    return temp
end

M.tokenize_by_pairs = function(tokens)
    return M.tokenize_by_characters(tokens, 2)
end

M.tokenize_by_delimiter = function(source, delimiter)
    local temp = token_list:new()
    for morpheme in M.gmatch(source, M.CAPTURE_PATTERN_START..delimiter..M.CAPTURE_PATTERN_END) do
        local morpheme = M.lower(morpheme)
        if temp:exists(morpheme) then
            local id = temp:get_id_by_morpheme(morpheme)
            local new_frequency = temp:get_frequency_by_morpheme(morpheme)+1
            temp:set_frequency(id, new_frequency)
        else
            local new_token = token:new(morpheme)
            temp:add(new_token, 1)
        end
    end
    return temp
end

M.to_words = function(source, add_tracing_space)
    local temp = M.tokenize_by_delimiter(source, M.WHITE_SPACE)
    if add_tracing_space then
        local tokens = temp:get_tokens()
        for i = 1, temp:count() do
            local morpheme = tokens[i].token:get_morpheme()
            if (M.len(morpheme)%2==0) then
                tokens[i].token:set_morpheme(morpheme..M.TRACING_SPACE_DOUBLE)
            else
                tokens[i].token:set_morpheme(morpheme..M.TRACING_SPACE)
            end
        end
    end
    return temp
end

M.split_with_tracing_space = function(source)
    return M.to_words(source, true)
end

M.bytepair_encoding = function(source, max)
    local max = max or M.MAX_SUBWORDS_LEARNING
    local initial_token_list = M.split_with_tracing_space(source)
    local learnt_pairs = M.tokenize_by_pairs(initial_token_list)
    local encoded = M.merge(initial_token_list, learnt_pairs)
    --[[local individual_characters = M.tokenize_by_characters(initial_token_list)
    if (encoded:count()+individual_characters:count()<max) then
        encoded = M.merge(encoded, individual_characters)
    end]]
    encoded:sort_by_frequency(true)
    return encoded
end

M.to_subwords = function(source)
    local vocabulary = M.bytepair_encoding(source)
    return vocabulary
end

M.TOKENIZATION_METHODS = {
    words = M.to_words,
    subwords = M.to_subwords
}

M.induce = function(source, method, name)
    local granularity_level = method
    if M.TOKENIZATION_METHODS[method] then
        method = M.TOKENIZATION_METHODS[method]
    else
        return error(M.ERROR_METHOD)
    end
    M.VOCABULARIES_COUNT = M.VOCABULARIES_COUNT + 1
    local name = name or "#"..M.VOCABULARIES_COUNT
    return method(source), granularity_level, name
end

M.segment = function(vocabulary, test, method)
end

return M