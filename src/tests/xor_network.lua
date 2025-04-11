local r_vector = require("R_Vector")
local unit = require("Unit")
local layer = require("Layer")
local network = require("NeuralNetwork")

local M = {}

M.h1 = unit:new()
M.w1 = r_vector:new{1, 1}
M.h1:set("weight", M.w1):set("bias", 0):set("activation_function", "relu")
M.h2 = unit:new()
M.w2 = r_vector:new{1, 1}
M.h2:set("weight", M.w2):set("bias", -1):set("activation_function", "relu")
M.o = unit:new()
M.wo = r_vector:new{1, -2}
M.o:set("weight", M.wo):set("bias", 0):set("activation_function", "relu")

M.li = layer:new("input")
M.lh = layer:new("hidden"):push(M.h1):push(M.h2)
M.lo = layer:new("output"):push(M.o)

M.n = network:new():push(M.li):push(M.lh):push(M.lo)

M.run = function(x1, x2)
    local input = r_vector:new{x1, x2}
    print(x1.." XOR "..x2.." = "..M.n:get_output(input))
end

return M