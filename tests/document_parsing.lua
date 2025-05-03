local token = require("token")
local vocabulary = require("Vocabulary")

local M = {}
M.SAMPLE_DOCUMENT_1_CONTENT = "This is a short sample document"
M.SAMPLE_DOCUMENT_2_CONTENT = "And another sample and this time without repetition this time"
M.SAMPLE_DOCUMENT_3_CONTENT = "low lowest newer wider new"

M.run = function()
    local source = M.SAMPLE_DOCUMENT_1_CONTENT
    local tokens, granularity, name = token.induce(source, "words")
    local v1 = vocabulary:new(tokens, granularity, name)
    print("Source Document: "..source)
    v1:print()

    source = M.SAMPLE_DOCUMENT_2_CONTENT
    tokens, granularity, name = token.induce(source, "words")
    local v2 = vocabulary:new(tokens, granularity, name)
    print("Source Document: "..source)
    v2:print()

    source = M.SAMPLE_DOCUMENT_3_CONTENT
    tokens, granularity, name = token.induce(source, "subwords")
    local v3 = vocabulary:new(tokens, granularity, name)
    print("Source Document: "..source)
    v3:print()
end

return M