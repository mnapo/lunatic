local unit = require("Unit")
local vector = require("R_Vector")

local M = {}
M.u = unit:new()

M.setup = function()
    M.u:set("weight", {1, 1})
    :set("bias", 0)
end

M.run = function(input)
    return M.u:get_output(intput)
end

return M