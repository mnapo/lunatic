local ClassPrototype = require("ClassPrototype")
local Layer = require("Layer")

function NeuralNetwork:new(layers, activation_function)
    local instance = ClassPrototype:new()

    activation_function = activation_function or ""
    layers = layers or {}

    instance:set("activation_function", activation_function)
    :set("layers", layers)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function NeuralNetwork:add_layer(name, units)
end

return NeuralNetwork