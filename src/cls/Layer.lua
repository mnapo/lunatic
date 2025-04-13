local ClassPrototype = require("ClassPrototype")
local R_Vector = require("R_Vector")
local Layer = ClassPrototype:new()
Layer.__index = Layer

local ERROR_INVALID_TYPE = "Layer type is wrong."
local ERROR_NEXT_LAYER_UNDEFINED = "There isn't a next layer defined"
local ERROR_NOT_UNIT = "Error, Unit expected. Got "

local is_Unit = function(x)
    if not (type(x) == "table") then
        return false
    end
    return x["is_Unit"] or false
end
local is_Layer = function(x)
    if not (type(x) == "table") then
        return false
    end
    return x["is_Layer"] or false
end

function Layer:new(type)
    local instance = ClassPrototype:new()

    local type = type or "hidden"
    local units = {}

    instance:set("is_Layer", true)
    :set("type", type)
    :set("units", units)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function Layer:set(member, value)
    if member == "activation_function" then
        local units = self:get("units")
        for i = 1, #units do
            units[i]:set("activation_function", value)
        end
    end
    self[member] = value
    return self
end

function Layer:push(u)
    if not (is_Unit(u)) then
        return false, ERROR_NOT_UNIT..type(u)
    end
    local units = self:get("units")
    units[#units+1] = u
    return self
end

function Layer:pop()
    local units = self:get("units")
    units[#units] = nil
    return self
end

function Layer:print()
    local units = self:get("units")
    local name = self:get("name")
    print("LAYER "..name)
    for i = 1, #units do
        local unit = units[i]
        --local weight = vector.tostring(unit:get("weight"))
        local bias = unit:get("bias")
        print("UNIT "..name..i..": weight = "..weight..", bias = "..bias)
    end
end

function Layer:get_output(input)
    local type = self:get("type")
    local output
    if type == "output" then
        output = input
    elseif type == "scalar_output" then
        output = input
        output[#output+1] = "scalar"
    elseif type == "input" or type == "hidden" then
        local next_layer = self:get("network"):get("layers")[self:get("id")+1]
        if not (is_Layer(next_layer)) then
            error(ERROR_NEXT_LAYER_UNDEFINED)
        end
        output = {}
        local next_layer_units = next_layer:get("units")
        for i = 1, #next_layer_units do
            output[i] = next_layer_units[i]:get_output(input)
        end
        output = R_Vector:new(output)
    else
        error(ERROR_INVALID_TYPE)
    end
    return output
end

return Layer