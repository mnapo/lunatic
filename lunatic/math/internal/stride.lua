local Stride = {}

--
-- Compute strides for row-major layout
--

function Stride.compute(shape)
    local ndim = #shape
    local strides = {}

    local stride = 1

    for i = ndim, 1, -1 do
        strides[i] = stride
        stride = stride * shape[i]
    end

    return strides
end

--
-- Convert multi-index to flat index
--

function Stride.offset(indexes, strides, offset)
    local index = offset or 0

    for i = 1, #indexes do
        index = index + (indexes[i] - 1) * strides[i]
    end

    return index + 1
end

return Stride