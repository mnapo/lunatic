local ClassPrototype = require("ClassPrototype")
local vector = require("vector")
local Unit = ClassPrototype:new()
Unit.__index = Unit

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

function Unit:new(network_id)
    local instance = ClassPrototype:new()

    local activation_function = ""
    local bias = 0
    local parent_network_id = network_id or 0
    local weight = 0

    instance:set("activation_function", activation_function)
    :set("bias", bias)
    :set("parent_network_id", parent_network_id)
    :set("weight", weight)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
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

function Unit.calculate_dot_product(v1, v2)
    return vector.dot_product(v1, v2)
end

function Unit.calculate_vectorial_sum(v1, v2)
    return vector.vectorial_sum(v1, v2)
end

function Unit:get_scalar_output(x)
    local weighted_input = x * self:get("weight")
    local biased_input = weighted_input + self:get("bias")
    local activated_input = self:get("activation_function")(biased_input)
    return activated_input
end

function Unit:get_output(x)
    local weighted_input = calculate_dot_product(x, self:get("weight"))
    local biased_input = weighted_input + self:get("bias")
    local activated_input = self:get("activation_function")(biased_input)
    return activated_input
end

return Unit