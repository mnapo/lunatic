local shape = require("lunatic.math.shape")
local indexing = require("lunatic.math.indexing")

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

--
-- Map output index to input indexes
--

function Broadcast.map_index(out_index, shapeA, shapeB, out_shape)
    local A = Shape.normalize(shapeA, #out_shape)
    local B = Shape.normalize(shapeB, #out_shape)

    local idxA = {}
    local idxB = {}

    for i = 1, #out_shape do
        if A[i] == 1 then
            idxA[i] = 1
        else
            idxA[i] = out_index[i]
        end

        if B[i] == 1 then
            idxB[i] = 1
        else
            idxB[i] = out_index[i]
        end
    end

    return idxA, idxB
end

return Broadcast