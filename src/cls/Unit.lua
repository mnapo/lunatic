local ClassPrototype = require("ClassPrototype")
local Unit = {}

local ERROR_NOT_R_VECTOR = "Error, it can only be calculated the dot product between two real numbers vectors"
local ERROR_DIFFERENT_DIMENSIONS = "The dot product between two vectors can't be calculated if they're of different dimensions"
local E = math.exp(1)

local sigmoid = function(z)
    return 1/(1+E^((-1)*z))
end

local tanh = function(z)
    return (E^z-E^((-1)*z))/(E^z+E^((-1)*z))
end

local relu = function(z)
    if z>0 then
        return z
    else
        return 0
    end
end

local calculate_dot_product = function(v1, v2)
    if not (v1:is_R_Vector() and v2:is_R_Vector()) then
        error(ERROR_NOT_R_VECTOR)
    end
    local v1_dimension = v1:get_dimension()
    if not (v1_dimension == v2:get_dimension()) then
        error(ERROR_DIFFERENT_DIMENSIONS)
    end
    local dot_product = 0
    for i = 1, v1_dimension do
        local coordinates_product = v1:get_value(i) * v2:get_value(i)
        dot_product = dot_product + coordinates_product
    end
    return dot_product
end

function Unit.new(network_id)
    Unit.__index = Unit
    setmetatable(Unit, {__index = ClassPrototype})

    local activation_function = ""
    local bias = 0
    local parent_network_id = network_id or 0
    local weight = 0

    local instance = ClassPrototype.new()
        :set("activation_function", activation_function)
        :set("bias", bias)
        :set("parent_network_id", parent_network_id)
        :set("weight", weight)

    return setmetatable(instance, Unit)
end

function Unit:set(member, value)
    if member == "activation_function" then
        if value == "sigmoid" then
            value = sigmoid
        elseif value == "tanh" then
            value = tanh
        elseif value == "relu" then
            value = relu
        end
    end
    self[member] = value
    return self
end

function Unit:get_output(x)
    local weighted_input = x * self:get("weight")
    local biased_input = weighted_input + self:get("bias")
    local activated_input = self:get("activation_function")(biased_input)
    return activated_input
end

return Unit