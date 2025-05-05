local token = require("tokenization")
local vocabulary = require("Vocabulary")

local M = {}
M.SAMPLE_DOCUMENT_1_CONTENT = "This is a short a sample b document document c sample short a"
M.SAMPLE_DOCUMENT_2_CONTENT = "low low low low low lowest lowest newer newer newer newer newer newer wider wider wider new new newer"
M.TOTAL_SAMPLES = 2
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

M.run = function()
    local source = M.SAMPLE_DOCUMENT_1_CONTENT
    local granularity = "words"
    local tokens = token.induce(source, granularity)
    local name = M.generate_name()
    local v1 = vocabulary:new(tokens, granularity, name)
    print("Source Document: "..source)
    v1:print()

    source = M.SAMPLE_DOCUMENT_2_CONTENT
    granularity = "subwords"
    tokens = token.induce(source, "subwords")
    name = M.generate_name()
    local v2 = vocabulary:new(tokens, granularity, name)
    print("Source Document: "..source)
    v2:print()
end

return M