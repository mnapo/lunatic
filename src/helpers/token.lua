local M = {}

M.CAPTURE_PATTERN_START = "([^"
M.CAPTURE_PATTERN_END = "]+)"
M.ERROR_INSUFFICIENT_TOKENS = "There's not enough tokens to sort (there should be two at least)"
M.ERROR_METHOD = "Invalid method"
M.ERROR_TO_BE_REPORTED = 'Internal Lua "error" or really strange behaviour is happening. We are going to see what is going on next time'
M.MAX_SUBWORDS_LEARNING = 10
M.MIN_TOKENS = 2
M.MORPHEME_KEY_ID = "char-"
M.TOKENS_THRESHOLD = 4
M.TRACING_SPACE = "_"
M.TRACING_SPACE_DOUBLE = "__"
M.VOCABULARIES_COUNT = 0
M.WHITE_SPACE = "%s"
M.gmatch = string.gmatch
M.len = string.len
M.lower = string.lower
M.sub = string.sub

M.tokenize_by_pairs = function(tokens)
    local temp = M.tokenize_by_characters(tokens)
end

M.tokenize_by_characters = function(tokens)
    local temp = {}
    for i = 1, #tokens do
        local morpheme = tokens[i].morpheme
        local length = M.len(morpheme)
        for j = 1, length do
            local character = M.sub(morpheme, j, j)
            local key = M.MORPHEME_KEY_ID..character
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

M.tokenize_by_delimiter = function(source, delimiter)
    local temp = {}
    for morpheme in M.gmatch(source, M.CAPTURE_PATTERN_START..delimiter..M.CAPTURE_PATTERN_END) do
        morpheme = M.lower(morpheme)
        if temp[morpheme] == nil then
            temp[morpheme] = 1
        else
            temp[morpheme] = temp[morpheme] + 1
        end
    end
    for morpheme, frequency in pairs(temp) do
        temp[#temp+1] = {morpheme=morpheme, frequency=frequency}
        temp[morpheme] = nil
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
    for i = M.TOKENS_THRESHOLD+1, #tokens do
        tokens[i] = nil
    end
end

M.split_with_tracing_space = function(source)
    local temp = M.to_words(source, true)
end

M.bytepair_encoding = function(source)
    local tokens = M.to_words(source, true)
    tokens = M.tokenize_by_characters(tokens)
    return tokens
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