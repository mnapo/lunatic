local shape = require("lunatic.math.shape")

local Broadcast = {}

--
-- Check compatibility + resolve output shape
--

function Broadcast.resolve(shapeA, shapeB)
    local A, B = shape.normalize(shapeA, math.max(#shapeA, #shapeB)),
                 shape.normalize(shapeB, math.max(#shapeA, #shapeB))

    local out = {}

    for i = 1, #A do
        if A[i] == B[i] then
            out[i] = A[i]

        elseif A[i] == 1 then
            out[i] = B[i]

        elseif B[i] == 1 then
            out[i] = A[i]

        else
            error("Broadcast error: incompatible shapes")
        end
    end

    return out
end

--
-- Check only
--

function Broadcast.compatible(shapeA, shapeB)
    local ok = pcall(function()
        Broadcast.resolve(shapeA, shapeB)
    end)

    return ok
end

return Broadcast