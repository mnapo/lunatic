local unit = require("Unit")
local vector = require("R_Vector")

local M = {}

M.u = unit:new()
M.w = vector:new{1, 1}
M.u:set("weight", M.w)
    :set("bias", -1)
    :set("activation_function", "perceptron")

M.run = function(x1, x2)
    local input = vector:new{x1, x2}
    local result = M.u:get_output(input)
    print(x1.." AND "..x2.." = "..result)
end

return M