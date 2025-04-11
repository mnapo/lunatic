local ClassPrototype = require("ClassPrototype")
local R_Vector = require("R_Vector")
local Layer = ClassPrototype:new()
Layer.__index = Layer

local ERROR_NEXT_LAYER_UNDEFINED = "There isn't a next layer defined"
local ERROR_NOT_UNIT = "Error, Unit expected. Got "

function Layer:new(network, units, activation_function, type)
    local instance = ClassPrototype:new()

    local activation_function = activation_function or ""
    local units = units or {}
    local type = type or "hidden"

    instance:set("activation_function", activation_function)
    :set("is_Unit", true)
    :set("network", network)
    :set("type", type)
    :set("units", units)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
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

function Layer:get_output(input)
    local units = self:get("units")
    if self:get("type") == "output" then
        local unit = units[#units]
        return unit:get_output(input)
    elseif (self:get("network"):get_layer(self:get("id")+1)) then
        local network = self:get("network")
        local next_layer = network:get_layer(id)
        local next_layer_units = next_layer:get("units")
        local values = {}
        for i = 1, #units do
            values[i] = units[i]:get_output(next_layer_units[i])
        end
        return R_Vector:new(values)
    else
        return ERROR_NEXT_LAYER_UNDEFINED
    end
end

return Layer