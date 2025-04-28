local M = {}

M.CAPTURE_PATTERN_START = "([^"
M.CAPTURE_PATTERN_END = "]+)"
M.ERROR_METHOD = "Invalid method"
M.SEPARATOR = "%s"
M.VOCABULARIES_COUNT = 0
M.gmatch = string.gmatch
M.lower = string.lower

M.to_words = function(source)
    local temp = {}
    for word in M.gmatch(source, M.CAPTURE_PATTERN_START..M.SEPARATOR..M.CAPTURE_PATTERN_END) do
        word = M.lower(word)
        if temp[word] == nil then
            temp[word] = true
        end
    end
    for k in pairs(temp) do
        temp[#temp+1] = k
        temp[k] = nil
    end
    return temp
end

M.to_subwords = function(source)
    local temp = M.to_words(source)
    
end

M.TOKENIZATION_METHODS = {
    to_words = M.to_words,
    to_subwords = M.to_subwords
}

M.induce = function(source, method, name)
    local granularity_level = method
    if M.TOKENIZATION_METHODS[method] ~= nil then
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