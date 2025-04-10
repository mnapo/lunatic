local unit = require("Unit")
local vector = require("R_Vector")

local M = {}

M.u = unit:new()
M.w = vector:new{1, 1}
M.u:set("weight", M.w)
    :set("bias", -1)
    :set("activation_function", "perceptron")

M.run = function(input)
    input = vector:new(input)
    local result = M.u:get_output(input)
    print(input:get_value(1).." AND "..input:get_value(2).." = "..result)
end

return M