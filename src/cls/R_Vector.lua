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
            error(ERROR_NOT_REAL_NUMBER)
        end
    end

    local instance = t
    instance["is_R_Vector"] = true
    instance["dimension"] = #instance
    return setmetatable(instance, R_Vector)
end