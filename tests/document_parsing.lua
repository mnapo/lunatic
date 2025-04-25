local token = require("token")
local vocabulary = require("Vocabulary")

local M = {}
M.SAMPLE_DOCUMENT_CONTENT = "This is a short sample document"
M.SAMPLE_DOCUMENT_NAME = "Test"

M.run = function()
    local source = M.SAMPLE_DOCUMENT
    local tokens, granularity, name = token.induce(M.SAMPLE_DOCUMENT_CONTENT, "words", M.SAMPLE_DOCUMENT_NAME)
    local v = vocabulary:new(tokens, granularity, name)
    print("Source Document: "..M.SAMPLE_DOCUMENT_CONTENT)
    v:print()
end

return M