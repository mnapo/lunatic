local ClassPrototype = require("ClassPrototype")
local Layer = require("Layer")
local vector = require("vector")
local NeuralNetwork = ClassPrototype:new()
NeuralNetwork.__index = NeuralNetwork

local DEFAULT_NAME_COMMON = "L"
local DEFAULT_NAME_HIDDEN = "H"
local DEFAULT_NAME_INPUT = "X"
local DEFAULT_NAME_OUTPUT = "O"
local ERROR_LAYER_WRONG_ID = "Wrong layer id"
local ERROR_NOT_LAYER = "Error, Layer expected. Got "
local ERROR_NOT_NUMBER = "Id number needs to be a positive integer"

local generate_name = function(type, id)
    if type == "input" then
        return DEFAULT_NAME_INPUT
    elseif type == "hidden" then
        return DEFAULT_NAME_HIDDEN
    elseif type == "output" then
        return DEFAULT_NAME_OUTPUT
    end
    return DEFAULT_NAME_COMMON
end

local is_Layer = function(x)
    if not (type(x) == "table") then
        return false
    end
    return x["is_Layer"] or false
end

function NeuralNetwork:new(layers)
    local instance = ClassPrototype:new()

    local layers = layers or {}

    instance:set("last", 0)
    :set("layers", layers)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function NeuralNetwork:set(member, value)
    if member == "activation_function" then
        local layers = self:get("layers")
        for i = 1, #layers do
            layers[i]:set("activation_function", value)
        end
    end
    self[member] = value
    return self
end

function NeuralNetwork:push(l)
    if not (is_Layer(l)) then
        return false, ERROR_NOT_LAYER..type(l)
    end
    local layers = self:get("layers")
    local new_id = self:get("last")+1
    self:set("last", new_id)
    layers[#layers+1] = l
    l:set("id", new_id)
    l:set("name", generate_name(l:get("type"), new_id))
    l:set("network", self)
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
        error(ERROR_LAYER_WRONG_ID)
    end
    return self:get("layers", id)
end

function NeuralNetwork:get_output(input)
    local output
    local layers = self:get("layers")
    for i = 1, #layers do
        local layer = layers[i]
        input = layer:get_output(input)
    end
    if input[#input] == "scalar" then
        output = vector.flatten(input)
    else
        output = input
    end
    return output
end

return NeuralNetwork