local M = {}

M.run_vectorial = function()
    local vectorial_test = require("vector_operations")
    vectorial_test.run()
end

M.run_networks = function()
    local and_test = require("and_perceptron")
    local or_test = require("or_perceptron")
    local xor_test = require("xor_network")
    and_test.run(1, 1)
    and_test.run(1, 0)
    and_test.run(0, 1)
    and_test.run(0, 0)
    or_test.run(1, 1)
    or_test.run(1, 0)
    or_test.run(0, 1)
    or_test.run(0, 0)
    xor_test.run(1, 1)
    xor_test.run(1, 0)
    xor_test.run(0, 1)
    xor_test.run(0, 0)
end

M.run_documents = function()
    local documents = require("document_parsing")
    documents.run()
end

return M