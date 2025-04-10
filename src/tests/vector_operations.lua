vector = require("vector")
r_vector = require("r_vector")

local M = {}

M.run = function()
    --[[local error_raiser_1 = vector:new("i'll cause trouble")
    local error_raiser_2 = vector:new{0, 1, 0.8, -5, "I'm causing trouble too!", -0.3}]]
    local v1 = r_vector:new{0.4, -3, -10, 150, -3000, 40.7}
    print("Vector (0.4; -3; -10; 150; -3000; 40.7) - Values:")
    for i = 1, v1:get_dimension() do
        print("#"..i.." = "..v1:get_value(i))
    end
    local v2 = r_vector:new{8, -3, -1, -5}
    --[[Wrong dot product calculation!
    print(vector.dot_product(v1, 5))
    print(vector.dot_product(v1, "hello"))
    print(vector.dot_product(v1, v2))
    ]]
    local v3 = r_vector:new{121, 500.68, -19, -7, -0.006, 18}
    print("Dot product between (0.4; -3; -10; 150; -3000; 40.7) and (121; 500.68; -19; -7; -0.006; 18) = "..vector.dot_product(v1, v3))
end

return M