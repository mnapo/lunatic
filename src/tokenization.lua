local M =           {}
local token =       require("Token")
local token_list =  require("TokenList")
local vocabulary =  require("Vocabulary")

M.to_words = function() end
M.to_subwords = function() end
M.TOKENIZATION_METHODS = {}

M.CAPTURE_PATTERN_START = "([^"
M.CAPTURE_PATTERN_END = "]+)"
M.CHARACTER_DELIMITER = "character"
M.ERROR_METHOD = "Invalid method"
M.LEARNING_CYCLES = 12
M.RESERVED_MORPHEME_DELETE = "DELETE"
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

M.to_words = function(source, add_tracing_space, allow_double_tracing_space)
    local temp = M.tokenize_by_delimiter(source, M.WHITE_SPACE_ESCAPED)
    if add_tracing_space then
        local tokens = temp:get_tokens()
        for i = 1, temp:count() do
            local morpheme = tokens[i].token:get_morpheme()
            if (M.len(morpheme)%2==0) then
                if (allow_double_tracing_space) then
                    tokens[i].token:set_morpheme(morpheme..M.TRACING_SPACE_DOUBLE)
                else
                    tokens[i].token:set_morpheme(morpheme..M.TRACING_SPACE)
                end
            else
                tokens[i].token:set_morpheme(morpheme..M.TRACING_SPACE)
            end
        end
    end
    return temp
end

M.split_with_tracing_space = function(source)
    return M.to_words(source, true, true)
end

M.replace_by_pair = function(base_list, pair)
    local tokens = base_list:get_tokens()
    local pair_morpheme = pair.token:get_morpheme()
    for i = 1, #tokens-1 do
        local token1 = tokens[i]
        if token1 then
            local morpheme1 = tokens[i].token:get_morpheme()
            local morpheme2 = tokens[i+1].token:get_morpheme()
            if (morpheme2) then
                local union = morpheme1..morpheme2
                if (union == pair_morpheme) then
                    base_list:replace(i, pair)
                    base_list:replace(i+1, {token=token:new():set_to_discard(), frequency=nil})
                end
            end
        end
    end
    base_list:clean()
end

M.explode_by_pairs = function(base_list)
    local tokens = base_list:get_tokens()
    local temp = token_list:new()
    for i = 1, #tokens-1 do
        local morpheme1 = tokens[i].token:get_morpheme()
        if (M.sub(morpheme1,-1) ~= M.TRACING_SPACE) then
            local morpheme2 = tokens[i+1].token:get_morpheme()
            local new_morpheme = morpheme1..morpheme2
            temp:add(new_morpheme)
        end
    end
    return temp
end

M.remove_fully_parsed_words = function(base_list, parsed_words_list)
    local tokens = base_list:get_tokens()
    for i = 1, #tokens do
        local morpheme1 = tokens[i].token:get_morpheme()
        local parsed_words_tokens = parsed_words_list:get_tokens()
        for j = 1, #parsed_words_tokens do
            local morpheme2 = parsed_words_tokens[j].token:get_morpheme()
            if (morpheme1 == morpheme2) then
                base_list:replace(i, {token=token:new():set_to_discard(), frequency=nil})
            end
        end
    end
    base_list:clean()
end

M.bpe = function(source, max)
    local max = max or M.LEARNING_CYCLES
    local characters = M.tokenize_by_delimiter(source, "character")
    local learnt = M.merge(token_list:new(), characters)
    local words =  M.to_words(source, true, false)
    local pairs = token_list:new()
    for i = 1, max do
        pairs = M.explode_by_pairs(characters)
        pairs:sort_by_frequency(true)
        local most_frequent_pair = pairs:get_tokens()[1]
        learnt:add(most_frequent_pair.token:get_morpheme())
        M.replace_by_pair(characters, most_frequent_pair)
        M.remove_fully_parsed_words(characters, words)
        characters:update_frequencies()
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