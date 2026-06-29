local ClassPrototype = require("ClassPrototype")
local R_Vector = ClassPrototype:new()
R_Vector.__index = R_Vector

local ERROR_NOT_TABLE = 1
local ERROR_NOT_REAL_NUMBER = 2

function R_Vector:new(t)
    local content_type = type(t)
    if not (content_type == "table") then
        error(ERROR_NOT_TABLE, content_type)
    end

    for i = 1, #t do
        if not (type(t[i]) == "number") then
            error(ERROR_NOT_REAL_NUMBER)
        end
    end

    local instance = ClassPrototype:new()
    :set("dimension", #t)
    :set("values", t)
    :set("is_R_Vector", true)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function R_Vector:set_value(id, value)
    local values = self:get("values")
    values[id] = value
    return self
end

function R_Vector:get_value(id)
    return self:get("values")[id]
end

function R_Vector:get_dimension()
    return self:get("dimension")
end

function R_Vector.is_vector()
    return true
end

function R_Vector.is_R_vector()
    return true
end

return R_Vector