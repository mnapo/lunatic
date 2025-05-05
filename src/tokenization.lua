local M =           {}
local token =       require("Token")
local token_list =  require("TokenList")
local vocabulary =  require("Vocabulary")

M.to_words = function() end
M.to_subwords = function() end

M.TOKENIZATION_METHODS = {
    words =     M.to_words,
    subwords =  M.to_subwords
}

M.CAPTURE_PATTERN_START = "([^"
M.CAPTURE_PATTERN_END = "]+)"
M.ERROR_INSUFFICIENT_TOKENS = "There's not enough tokens to sort (there should be two at least)"
M.ERROR_METHOD = "Invalid method"
M.LEARNING_CYCLES = 15
M.MIN_TOKENS = 2
M.TRACING_SPACE = "_"
M.TRACING_SPACE_DOUBLE = "__"
M.VOCABULARIES_COUNT = 0
M.WHITE_SPACE = "%s"

M.gmatch =  string.gmatch
M.len =     string.len
M.lower =   string.lower
M.sub =     string.sub

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

M.tokenize_by_delimiter = function(source, delimiter)
    local temp = token_list:new()
    for morpheme in M.gmatch(source, M.CAPTURE_PATTERN_START..delimiter..M.CAPTURE_PATTERN_END) do
        local morpheme = M.lower(morpheme)
        temp:add(morpheme)
    end
    return temp
end

M.explode_by_characters = function(source)
    local characters = {}
    local length = M.len(source)
    for i = 1, length-1 do
        local character = M.sub(source, i, i)
        characters[#characters+1] = character
    end
    return characters
end

M.merge_most_frequents = function(characters)
    local temp = {}
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

M.bpe = function(source, max)
    local max = max or M.LEARNING_CYCLES
    local temp = M.split_with_tracing_space(source)
    local characters = M.explode_by_characters(source)
    temp = merge_most_frequents(characters)
    return temp
end

M.to_subwords = function(source)
    local vocabulary = M.bpe(source)
    return vocabulary
end

M.induce = function(source, method, name)
    if M.TOKENIZATION_METHODS[method] then
        method = M.TOKENIZATION_METHODS[method]
    else
        return error(M.ERROR_METHOD)
    end
    return method(source)
end

M.segment = function(vocabulary, test, method)
end

return M