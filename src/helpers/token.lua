local M = {}

M.to_words = function(source)
end

M.to_subwords = function(source)
end

M.TOKENIZATION_METHODS = {
    to_words = M.to_words,
    to_subwords = M.to_subwords
}

M.induce = function(source, method)
    local granularity_level = method
    if method == "words" then
        method = M.TOKENIZATION_METHODS.to_words
    elseif method == "subwords" then
        method = M.TOKENIZATION_METHODS.to_subwords
    end
    local induced = Vocabulary:new(method(source), granularity_level)
    return induced
end

M.segment = function(vocabulary, test, method)
end

return M