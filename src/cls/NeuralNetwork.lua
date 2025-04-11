local ClassPrototype = require("ClassPrototype")
local Layer = require("Layer")
local NeuralNetwork = ClassPrototype:new()
NeuralNetwork.__index = NeuralNetwork

local ERROR_NOT_LAYER = "Error, Layer expected. Got "
local ERROR_NOT_NUMBER = "Id number needs to be a positive integer"

local is_Layer = function(x)
    if not (type(x) == "table") then
        return false
    end
    return x["is_Layer"] or false
end

function NeuralNetwork:new(layers, type, activation_function)
    local instance = ClassPrototype:new()

    local activation_function = activation_function or ""
    local layers = layers or {}

    instance:set("activation_function", activation_function)
    :set("last", 0)
    :set("layers", layers)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function NeuralNetwork:push(l)
    if not (is_Layer(l)) then
        return false, ERROR_NOT_LAYER..type(l)
    end
    local new_id = self:get("last")+1
    local layers = self:get("layers")
    layers[#layers+1] = l
    l:set(new_id)
    return self
end

function NeuralNetwork:pop()
    local layers = self:get("layers")
    layers[#layers] = nil
    return self
end

function NeuralNetwork:get_layer(id)
    if (type(id) ~= "number" or id <= 0) then
        error(ERROR_NOT_NUMBER)
    end
    if id > self:get("last") then
        return false
    end
    return true
end

function NeuralNetwork:get_output(input)
    local layers = self:get("layers")
    local output = 0
    for i = 1, #layers do
        local layer = self:get_layer(i)
        input = layer:calculate_output(input)
        if layer:get("type") == "output" then
            output = input
        end
    end
    return output
end

return NeuralNetwork