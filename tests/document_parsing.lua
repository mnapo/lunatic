local token = require("token")
local vocabulary = require("Vocabulary")

local M = {}
M.SAMPLE_DOCUMENT_1_CONTENT = "This is a short sample document"
M.SAMPLE_DOCUMENT_2_CONTENT = "And another sample and this time without repetition this time"

M.run = function()
    local source = M.SAMPLE_DOCUMENT_1_CONTENT
    local tokens, granularity, name = token.induce(source, "words", "Test 1")
    local v1 = vocabulary:new(tokens, granularity, name)
    print("Source Document: "..source)
    v1:print()

    source = M.SAMPLE_DOCUMENT_2_CONTENT
    tokens, granularity, name = token.induce(source, "words", "Test 2")
    local v2 = vocabulary:new(tokens, granularity, name)
    print("Source Document: "..source)
    v2:print()
end

return M