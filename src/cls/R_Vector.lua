local ClassPrototype = require("ClassPrototype")
local R_Vector = {}

local ERROR_NOT_A_TABLE = "Table expected, got "
local ERROR_NOT_A_REAL_NUMBER = "R_Vector must be filled with real numbers!"

function R_Vector.new(t)
    R_Vector.__index = R_Vector
    setmetatable(R_Vector, {__index = ClassPrototype})

    local content_type = type(t)
    if not (content_type == "table") then
        error(ERROR_NOT_A_TABLE..content_type)
    end

    for i = 1, #t do
        if not (type(t[i]) == "number") then
            error(ERROR_NOT_A_REAL_NUMBER)
        end
    end

    local instance = ClassPrototype.new()
        :set("is_R_Vector", true)
        :set("dimension", #t)
        :set("values", t)
    return setmetatable(instance, R_Vector)
end

function R_Vector:get_value(id)
    return self:get("values")[id]
end

function R_Vector:get_dimension()
    return self:get("dimension")
end

function R_Vector:is_vector()
    return true
end

function R_Vector:is_R_vector()
    return true
end

return R_Vector