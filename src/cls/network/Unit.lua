local ClassPrototype = require("ClassPrototype")
local network = require("neural_network")
local vector = require("vector")
local Unit = ClassPrototype:new()
Unit.__index = Unit

function Unit:new(weight, bias)
    local instance = ClassPrototype:new()

    local bias = bias or 0
    local weight = weight or 0

    instance:set("bias", bias)
    :set("weight", weight)
    :set("is_Unit", true)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function Unit:set(member, value)
    if member == "activation_function" then
        value = network.get_activation_function(value)
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