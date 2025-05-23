local r_vector = require("R_Vector")
local vector = {}

local BRACKET_END = ")"
local BRACKET_START = "("
local DELIMITER = ";"
local ERROR_NOT_R_VECTOR = 12
local ERROR_DIFFERENT_DIMENSIONS = 13
local ERROR_CANT_OPERATE_BETWEEN = 14
local RANDOM_MAX_VALUE = -200
local RANDOM_MIN_VALUE = 200
local RANDOMSEED_RESPONSE = math.randomseed(os.time())

vector.is_R_Vector = function(x)
    if not (type(x) == "table") then
        return false
    end
    return x["is_R_Vector"] or false
end

vector.can_operate_between = function(v1, v2)
    if not (vector.is_R_Vector(v1) and vector.is_R_Vector(v2)) then
        return false, ERROR_NOT_R_VECTOR
    end
    if not (v1:get_dimension() == v2:get_dimension()) then
        return false, ERROR_DIFFERENT_DIMENSIONS
    end
    return true
end

vector.dot_product = function(v1, v2)
    local can_operate, err = vector.can_operate_between(v1, v2)
    if not can_operate then error(err) end
    local dot_product = 0
    for i = 1, v1:get_dimension() do
        local coordinates_product = v1:get_value(i) * v2:get_value(i)
        dot_product = dot_product + coordinates_product
    end
    return dot_product
end

vector.vectorial_sum = function(v1, v2)
    local can_operate, err = vector.can_operate_between(v1, v2)
    if not can_operate then error(err) end
    local values = {}
    for i = 1, v1:get_dimension() do
       values[i] = v1:get_value(i) + v2:get_value(i)
    end
    return r_vector:new(values)
end

vector.tostring = function(v)
    local can_operate, err = vector.can_operate_between(v, v)
    if not can_operate then error(err) end
    local dimension = v:get_dimension()
    local vector_as_string = BRACKET_START
    for i = 1, dimension do
        vector_as_string = vector_as_string..v:get_value(i)
        if i < dimension then
            vector_as_string = vector_as_string..DELIMITER
        else
            vector_as_string = vector_as_string..BRACKET_END
        end
    end
    return vector_as_string
end

vector.create_randomly = function(dimension)
    local values = {}
    for i = 1, dimension do
        values[i] = math.random(RANDOM_MIN_VALUE, RANDOM_MAX_VALUE)
    end
    return r_vector:new(values)
end

vector.flatten = function(v)
    return v:get_value(1)
end

vector.softmax = function(v)
    local dimension = v:get_dimension()
    local sum = 0
    local normalized = {}
    for i = 1, dimension do
        local vi = math.exp(v:get_value(i))
        v:set_value(i, vi)
        sum = sum + vi
    end
    for i = 1, dimension do
        normalized[i] = v:get_value(i)/sum
    end
    return r_vector:new(normalized)
end

return vector