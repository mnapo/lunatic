local ClassPrototype = require("ClassPrototype")
local vector = require("vector")
local Unit = ClassPrototype:new()
Unit.__index = Unit

local E = math.exp(1)
local ERROR_ACTIVATION_FUNCTION = "Error, the activation function doesn't exist"

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
local perceptron = function(z)
    if z>0 then
        return 1
    else
        return 0
    end
end

function Unit:new(layer_id)
    local instance = ClassPrototype:new()

    local activation_function = ""
    local bias = 0
    local parent_layer_id = layer_id or 0
    local weight = 0

    instance:set("activation_function", activation_function)
    :set("bias", bias)
    :set("parent_layer_id", parent_layer_id)
    :set("weight", weight)
    :set("is_Unit", true)

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
        elseif value == "perceptron" then
            value = perceptron
        else
            error(ERROR_ACTIVATION_FUNCTION)
        end
    end
    self[member] = value
    return self
end

function Unit:get_scalar_output(x)
    local weighted_input = x * self:get("weight")
    local biased_input = weighted_input + self:get("bias")
    local activated_input = self:get("activation_function")(biased_input)
    return activated_input
end

function Unit:get_output(x)
    local weighted_input = vector.dot_product(x, self:get("weight"))
    local biased_input = weighted_input + self:get("bias")
    local activated_input = self:get("activation_function")(biased_input)
    return activated_input
end

return Unit