local r_vector = require("R_Vector")
local unit = require("Unit")
local layer = require("Layer")
local network = require("NeuralNetwork")

local M = {}

M.h1 = unit:new(r_vector:new{1, 1}, 0)
M.h2 = unit:new(r_vector:new{1, 1}, -1)
M.o = unit:new(r_vector:new{1, -2}, 0)

M.li = layer:new("input")
M.lh = layer:new("hidden")
:push(M.h1):push(M.h2)
M.lo = layer:new("output")
:push(M.o)

M.n = network:new()
:push(M.li):push(M.lh):push(M.lo)
:set("activation_function", "relu")

M.run = function(x1, x2)
    local input = r_vector:new{x1, x2}
    print(x1.." XOR "..x2.." = "..M.n:get_output(input))
end

return M