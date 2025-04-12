local ClassPrototype = require("ClassPrototype")
local network = require("neural_network")
local vector = require("vector")
local Unit = ClassPrototype:new()
Unit.__index = Unit

local E = math.exp(1)
local ERROR_ACTIVATION_FUNCTION = "Error, the activation function doesn't exist"

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
            value = network.sigmoid
        elseif value == "tanh" then
            value = network.tanh
        elseif value == "relu" then
            value = network.relu
        elseif value == "perceptron" then
            value = network.perceptron
        else
            error(ERROR_ACTIVATION_FUNCTION)
        end
    end
    self[member] = value
    return self
end

function Unit:get_output(x)
    local weighted_input = vector.dot_product(x, self:get("weight"))
    local biased_input = weighted_input + self:get("bias")
    local activated_input = self:get("activation_function")(biased_input)
    return activated_input
end

return Unit