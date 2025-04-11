local M = {}
local SEPARATOR = "----------------------------------------------------------------------"

M.run = function()
    local vectorial_test = require("vector_operations")
    local and_test = require("and_perceptron")
    local or_test = require("or_perceptron")
    local xor_test = require("xor_network")
    print(SEPARATOR)
    print("Vectorial tests")
    print(SEPARATOR)
    vectorial_test.run()
    print(SEPARATOR)
    print("Neural Networks tests")
    print(SEPARATOR)
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

return M