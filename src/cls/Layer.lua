local ClassPrototype = require("ClassPrototype")
local Unit = require("Unit")

function Layer:new(units, activation_function)
    local instance = ClassPrototype:new()

    activation_function = activation_function or ""
    units = units or {}

    instance:set("activation_function", activation_function)
    :set("layers", layers)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function Layer:add_unit(unit)
end

return Layer