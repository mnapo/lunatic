local M = {}

M.CAPTURE_PATTERN_START = "([^"
M.CAPTURE_PATTERN_END = "]+)"
M.SEPARATOR = "%s"
M.gmatch = string.gmatch
M.VOCABULARIES_COUNT = 0

M.to_words = function(source)
    local temp = {}
    for word in M.gmatch(source, M.CAPTURE_PATTERN_START..M.SEPARATOR..M.CAPTURE_PATTERN_END) do
        temp[#temp+1] = word
    end
    return temp
end
M.to_subwords = function(source)
end

M.TOKENIZATION_METHODS = {
    to_words = M.to_words,
    to_subwords = M.to_subwords
}

M.induce = function(source, method, name)
    local granularity_level = method
    if method == "words" then
        method = M.TOKENIZATION_METHODS.to_words
    elseif method == "subwords" then
        method = M.TOKENIZATION_METHODS.to_subwords
    end
    M.VOCABULARIES_COUNT = M.VOCABULARIES_COUNT + 1
    local name = name or "#"..M.VOCABULARIES_COUNT
    return method(source), granularity_level, name
end

M.segment = function(vocabulary, test, method)
end

return M