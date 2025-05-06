local M =           {}
local token =       require("Token")
local token_list =  require("TokenList")
local vocabulary =  require("Vocabulary")

M.to_words = function() end
M.to_subwords = function() end

M.CAPTURE_PATTERN_START = "([^"
M.CAPTURE_PATTERN_END = "]+)"
M.CHARACTER_DELIMITER = "character"
M.ERROR_INSUFFICIENT_TOKENS = "There's not enough tokens to sort (there should be two at least)"
M.ERROR_METHOD = "Invalid method"
M.LEARNING_CYCLES = 9
M.MIN_TOKENS = 2
M.TRACING_SPACE = "_"
M.TRACING_SPACE_DOUBLE = "__"
M.VOCABULARIES_COUNT = 0
M.WHITE_SPACE = " "
M.WHITE_SPACE_ESCAPED = "%s"

M.gmatch =  string.gmatch
M.len =     string.len
M.lower =   string.lower
M.sub =     string.sub

M.merge = function(list1, list2, allow_duplicates)
    local list2_tokens = list2:get_tokens()
    for i = 1, list2:count() do
        local frequency = list2_tokens[i].frequency
        local morpheme = list2_tokens[i].token:get_morpheme()
        if allow_duplicates then
            list1:insert(list2_tokens[i].token, frequency)
        else
            if list1:exists(morpheme) then
                local id = list1:get_id_by_morpheme(morpheme)
                list1:get_tokens()[id].frequency = list1:get_tokens()[id].frequency + frequency
            else
                list1:add(list2_tokens[i].token:get_morpheme(), frequency)
            end
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

M.explode_by_characters = function(source)
    local characters = {}
    local length = M.len(source)
    for i = 1, length do
        local character = M.sub(source, i, i)
        if character == M.WHITE_SPACE then
            character = M.TRACING_SPACE
        end
        characters[#characters+1] = character
    end
    return characters
end

M.tokenize_by_delimiter = function(source, delimiter)
    local temp = token_list:new()
    if delimiter == M.CHARACTER_DELIMITER then
        local characters = M.explode_by_characters(source)
        temp:add_all(characters)
    else
        for morpheme in M.gmatch(source, M.CAPTURE_PATTERN_START..delimiter..M.CAPTURE_PATTERN_END) do
            local morpheme = M.lower(morpheme)
            temp:add(morpheme)
        end
    end
    return temp
end

M.replace_most_frequent_pair = function(list, most_frequent_morpheme1, most_frequent_morpheme2)
    local tokens = list:get_tokens()
    for i = 1, #tokens-1 do
        local morpheme1 = tokens[i].token.morpheme
        local morpheme2 = tokens[i+1].token.morpheme
        if (morpheme1 == most_frequent_morpheme1) then
            if (morpheme2 == most_frequent_morpheme2) then
                list = list:unify(i, i+1)
            end
        end
    end
    list:clean()
    return list
end

M.merge_most_frequent_pairs = function(token_list1)
    local temp = token_list:new()
    local tokens = token_list1:get_tokens()
    local most_frequent_morpheme1 = ""
    local most_frequent_morpheme2 = ""
    for i = 1, #tokens-1 do
        local morpheme1 = tokens[i].token.morpheme
        --if not morpheme1 == M.TRACING_SPACE then
            local morpheme2 = tokens[i+1].token.morpheme
            local pair_morpheme = morpheme1..morpheme2
            temp:add(pair_morpheme)
            local most_frequent_pair = temp:get_most_frequent()
            local most_frequent_pair_morpheme = most_frequent_pair:get_morpheme()
            if (most_frequent_pair_morpheme == pair_morpheme) then
                most_frequent_morpheme1 = morpheme1
                most_frequent_morpheme2 = morpheme2
            end
        --end
    end
    return M.replace_most_frequent_pair(token_list1, most_frequent_morpheme1, most_frequent_morpheme2)
end

M.to_words = function(source, add_tracing_space)
    local temp = M.tokenize_by_delimiter(source, M.WHITE_SPACE_ESCAPED)
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
    local words = M.split_with_tracing_space(source)
    local characters = M.tokenize_by_delimiter(source, M.CHARACTER_DELIMITER)
    local learnt = token_list:new()
    for i = 1, 1 do
        local characters = M.merge_most_frequent_pairs(characters)
        learnt = M.merge(learnt, characters)
    end
    return learnt
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

M.TOKENIZATION_METHODS = {
    words =     M.to_words,
    subwords =  M.to_subwords
}

return M