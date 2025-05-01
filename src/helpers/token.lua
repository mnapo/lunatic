local M = {}

M.CAPTURE_PATTERN_START = "([^"
M.CAPTURE_PATTERN_END = "]+)"
M.ERROR_METHOD = "Invalid method"
M.MAX_SUBWORDS_LEARNING = 10
M.VOCABULARIES_COUNT = 0
M.WHITE_SPACE = "%s"
M.gmatch = string.gmatch
M.lower = string.lower

M.tokenize = function(source, count_apparitions, delimiter)
    local temp = {}
    for word in M.gmatch(source, M.CAPTURE_PATTERN_START..delimiter..M.CAPTURE_PATTERN_END) do
        word = M.lower(word)
        if temp[word] == nil then
            temp[word] = true
        end
    end
    if count_apparitions then
        for word, _ in pairs(temp) do
            temp[#temp+1] = word
            temp[word] = nil
        end
    end
    return temp
end

M.to_words = function(source, delimiter)
    return M.tokenize(source, false, M.WHITE_SPACE)
end

M.bytepair_encoding = function(source, max)

end

M.to_subwords = function(source)
    return M.bytepair_encoding(source, M.MAX_SUBWORDS_LEARNING)
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