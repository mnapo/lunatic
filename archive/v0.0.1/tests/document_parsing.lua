local token = require("tokenization")
local vocabulary = require("Vocabulary")

local M = {}
M.TOTAL_SAMPLES = 2

M.SAMPLE_DOCUMENT_1_CONTENT = "This is a short a sample b document document c sample short a"
M.SAMPLE_DOCUMENT_2_CONTENT = "low low low low low lowest lowest newer newer newer newer newer newer wider wider wider new new"
M.COUNT = 1
M.NAME_PREFIX = "#"

M.set_count = function(mode)
    M.COUNT = M.COUNT + 1
    if (M.COUNT > M.TOTAL_SAMPLES) then
        M.COUNT = 0
    end
end

M.generate_name = function()
    local name = M.NAME_PREFIX..M.COUNT
    M.set_count()
    return name
end

M.generate = function(source, granularity)
    local tokens = token.induce(source, granularity)
    local name = M.generate_name()
    local v = vocabulary:new(tokens, granularity, name)
    print("Source Document: "..source)
    v:print()
end

M.run = function()
    M.generate(M.SAMPLE_DOCUMENT_1_CONTENT, "words")
    M.generate(M.SAMPLE_DOCUMENT_2_CONTENT, "subwords")
end

return M