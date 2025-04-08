local vector = {}

local ERROR_NOT_R_VECTOR = "Error, it can only be calculated the dot product/vectorial sum between two real numbers vectors"
local ERROR_DIFFERENT_DIMENSIONS = "The dot product between two vectors can't be calculated if they're of different dimensions"
local ERROR_CANT_OPERATE_BETWEEN = "Error, you can't operate between these objects"

vector.is_R_vector = function(x)
    if not (type(x) == "table") then
        return false
    end
    return x["is_R_vector"] or false
end

vector.can_operate_between = function(v1, v2)
    if not (v1:is_R_Vector() and v2:is_R_Vector()) then
        return false, ERROR_NOT_R_VECTOR
    end
    if not (v1:get_dimension() == v2:get_dimension()) then
        return false, ERROR_DIFFERENT_DIMENSIONS
    end
    return true
end

vector.dot_product = function(v1, v2)
    local can_operate, err = can_operate_between(v1, v2)
    if not can_operate then error(err) end
    local dot_product = 0
    for i = 1, v1:get_dimension() do
        local coordinates_product = v1:get_value(i) * v2:get_value(i)
        dot_product = dot_product + coordinates_product
    end
    return dot_product
end

vector.vectorial_sum = function(v1, v2)
    local can_operate, err = can_operate_between(v1, v2)
    if not can_operate then error(err) end
    local sum = 0
    for i = 1, v1:get_dimension() do
        sum = sum + v1:get_value(i) + v2:get_value(i)
    end
    return sum
end

return vector