local M = {}
local token = require("Token")
local token_list = require("TokenList")

M.CAPTURE_PATTERN_START = "([^"
M.CAPTURE_PATTERN_END = "]+)"
M.ERROR_INSUFFICIENT_TOKENS = "There's not enough tokens to sort (there should be two at least)"
M.ERROR_METHOD = "Invalid method"
M.ERROR_TO_BE_REPORTED = 'Internal Lua "error" or really strange behaviour is happening. We are going to inspect what is going on soon'
M.MAX_SUBWORDS_LEARNING = 30
M.MIN_TOKENS = 2
M.MORPHEME_CHAR_KEY_ID = "char-"
M.MORPHEME_WORD_KEY_ID = "word-"
M.TOKENS_THRESHOLD = 10
M.TRACING_SPACE = "_"
M.TRACING_SPACE_DOUBLE = "__"
M.VOCABULARIES_COUNT = 0
M.WHITE_SPACE = "%s"
M.gmatch = string.gmatch
M.len = string.len
M.lower = string.lower
M.sub = string.sub

M.sanitize = function(tokens, granularity)
    local temp = {}
    local key = M.MORPHEME_CHAR_KEY_ID
    if granularity == "words" then
        key = M.MORPHEME_WORD_KEY_ID
    end
    local key_length = M.len(key)
    for i = 1, #tokens do
        if tokens[i] then
            if tokens[i].morpheme then
                if tokens[i].frequency then
                    if (tonumber(tokens[i].frequency) and M.sub(tokens[i].morpheme, 1, key_length)==key) then
                        print(tokens[i].morpheme, tokens[i].frequency)
                        temp[#temp+1] = tokens[i]
                    end
                end
            end
        end
    end
    return temp
end

M.merge = function(vocabulary_1, vocabulary_2)
    local temp = vocabulary_1
    for i = 1, #vocabulary_2 do
        temp[#vocabulary_1+1] = vocabulary_2[i]
    end
    return temp
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
    local temp = {}
    local quantity = quantity or 1
    quantity = quantity-1
    for i = 1, #tokens do
        local morpheme = tokens[i].morpheme
        local length = M.len(morpheme)
        for j = 1, length-quantity do
            local character = M.sub(morpheme, j, j+quantity)
            local key = M.MORPHEME_CHAR_KEY_ID..character
            if temp[key] == nil then
                temp[key] = 1
            else
                local total = temp[key]+1
                temp[key] = total
            end
        end
    end
    for morpheme, frequency in pairs(temp) do
        if tonumber(morpheme) then
            print(M.ERROR_TO_BE_REPORTED)
        else
            temp[#temp+1] = {morpheme=morpheme, frequency=frequency}
            temp[morpheme] = nil
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
            temp:add(new_token)
        end
    end
    return temp
end

M.to_words = function(source, add_tracing_space)
    local temp = M.tokenize_by_delimiter(source, M.WHITE_SPACE)
    if add_tracing_space then
        for i = 1, #temp do
            if (M.len(temp[i].morpheme)%2==0) then
                temp[i].morpheme = temp[i].morpheme..M.TRACING_SPACE_DOUBLE
            else
                temp[i].morpheme = temp[i].morpheme..M.TRACING_SPACE
            end
        end
    end
    return temp
end

M.split_with_tracing_space = function(source)
    return M.to_words(source, true)
end

M.bytepair_encoding = function(source)
    local initial_vocabulary = M.split_with_tracing_space(source)

    --[[M.sort_by_frequency(initial_vocabulary)
    M.trim_less_frequent(initial_vocabulary)
    local individual_characters = M.tokenize_by_characters(initial_vocabulary)
    M.sort_by_frequency(individual_characters)
    M.trim_less_frequent(individual_characters)
    local learnt_pairs = M.tokenize_by_pairs(initial_vocabulary)
    local vocabulary = M.merge(initial_vocabulary, individual_characters)
    initial_vocabulary = nil
    individual_characters = nil
    if #vocabulary<M.MAX_SUBWORDS_LEARNING then
        M.sort_by_frequency(learnt_pairs)
        M.trim_less_frequent(learnt_pairs)
        vocabulary = M.merge(vocabulary, learnt_pairs)
    end]]
    return initial_vocabulary
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