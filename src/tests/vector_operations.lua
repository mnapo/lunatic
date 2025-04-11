vector = require("vector")
r_vector = require("r_vector")

local M = {}

M.run = function()
    --[[local error_raiser_1 = vector:new("i'll cause trouble")
    local error_raiser_2 = vector:new{0, 1, 0.8, -5, "I'm causing trouble too!", -0.3}]]
    local v1 = vector.create_randomly(6)
    print("Vector "..vector.tostring(v1).." | Values:")
    for i = 1, v1:get_dimension() do
        print("#"..i.." = "..v1:get_value(i))
    end
    local v2 = vector.create_randomly(4)
    --[[Wrong dot product calculation!
    print(vector.dot_product(v1, 5))
    print(vector.dot_product(v1, "hello"))
    print(vector.dot_product(v1, v2))
    ]]
    local v3 = vector.create_randomly(6)
    print("Dot product between "..vector.tostring(v1).." and "..vector.tostring(v3).." = "..vector.dot_product(v1, v3))
    local v4 = vector.create_randomly(4)
    print("Vectorial sum between "..vector.tostring(v2).." and "..vector.tostring(v4).." = "..vector.tostring(vector.vectorial_sum(v2, v4)))
end

return M