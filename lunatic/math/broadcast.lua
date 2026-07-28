local indexing = require("lunatic.math.internal.indexing")
local shape = require("lunatic.math.shape")
local reduction = require("lunatic.math.ops.reduction")

local Broadcast = {}

--
-- Helpers
--

local function find_reduction_axes(
    gradient_shape,
    target_shape
)

    local axes = {}

    local ndim = #gradient_shape

    local normalized = {}

    for i = 1, ndim do
        normalized[i] = 1
    end


    local offset = ndim - #target_shape

    for i = 1, #target_shape do
        normalized[offset + i] = target_shape[i]
    end


    for i = 1, ndim do

        if normalized[i] == 1
            and gradient_shape[i] > 1 then

            axes[#axes + 1] = i

        end

    end


    return axes

end


--
-- Check compatibility + resolve output shape
--

function Broadcast.resolve(shapeA, shapeB)

    local A, B =
        shape.normalize(
            shapeA,
            math.max(#shapeA, #shapeB)
        ),
        shape.normalize(
            shapeB,
            math.max(#shapeA, #shapeB)
        )

    local out = {}

    for i = 1, #A do

        if A[i] == B[i] then

            out[i] = A[i]

        elseif A[i] == 1 then

            out[i] = B[i]

        elseif B[i] == 1 then

            out[i] = A[i]

        else

            error(
                "Broadcast error: incompatible shapes"
            )

        end

    end

    return out

end


--
-- Check only
--

function Broadcast.compatible(shapeA, shapeB)

    local ok = pcall(function()

        Broadcast.resolve(
            shapeA,
            shapeB
        )

    end)

    return ok

end


--
-- Map output index to input indexes
--

function Broadcast.map_index(
    out_index,
    shapeA,
    shapeB,
    out_shape
)

    local A =
        shape.normalize(
            shapeA,
            #out_shape
        )

    local B =
        shape.normalize(
            shapeB,
            #out_shape
        )


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


--
-- Reduce broadcasted gradient
--

function Broadcast.reduce_gradient(
    gradient,
    target_shape
)

    local axes =
        find_reduction_axes(
            gradient.shape,
            target_shape
        )


    for i = #axes, 1, -1 do

        gradient =
            reduction.sum_axis(
                gradient,
                axes[i],
                true
            )

    end


    return gradient:reshape(
        target_shape
    )

end

return Broadcast