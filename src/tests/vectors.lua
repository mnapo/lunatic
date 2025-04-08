unit = require("Unit")
vector = require("R_Vector")

local input = 1
local u1 = unit:new(1)
    :set("activation_function", "sigmoid")
    :set("bias", 0.4)
    :set("weight", 1)
print(u1:get_output(input))

--local error_raiser_1 = vector:new("i'll cause trouble")
--local error_raiser_2 = vector:new{0, 1, 0.8, -5, "I'm causing trouble too!", -0.3}
local v1 = vector:new{0.4, -3, -10, 150, -3000, 40.7}
for i = 1, v1:get_dimension() do
    print(v1:get_value(i))
end

local v2 = vector:new{8, -3, -1, -5}
--[[Wrong dot product calculation!
u1.calculate_dot_product(v1, v2)]]

local v3 = vector:new{121, 500.68, -19, -7, -0.006, 18}
--error!
u1.calculate_dot_product(v1, 5)

print(u1.calculate_dot_product(v1, v3))