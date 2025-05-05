local token = require("tokenization")
local vocabulary = require("Vocabulary")

local M = {}
M.SAMPLE_DOCUMENT_1_CONTENT = "This is a short a sample b document document c sample short a"
M.SAMPLE_DOCUMENT_2_CONTENT = "low low low low low lowest lowest newer newer newer newer newer newer wider wider wider new new newer"

M.run = function()
    local source = M.SAMPLE_DOCUMENT_1_CONTENT
    local tokens, granularity, name = token.induce(source, "words")
    local v1 = vocabulary:new(tokens, granularity, name)
    print("Source Document: "..source)
    v1:print()

    source = M.SAMPLE_DOCUMENT_2_CONTENT
    tokens, granularity, name = token.induce(source, "subwords")
    --local v2 = vocabulary:new(tokens, granularity, name)
    --print("Source Document: "..source)
    --v2:print()
end

return M