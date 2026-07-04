local Indexing = {}

function Indexing.check_bounds(shape, indexes)
    for i = 1, #shape do
        local v = indexes[i]
        if v < 1 or v > shape[i] then
            return false
        end
    end
    return true
end

function Indexing.compute(shape, strides, offset, indexes)
    assert(#indexes == #shape, "Indexing: dimension mismatch")

    local index = offset or 0

    for i = 1, #shape do
        local v = indexes[i]

        assert(v >= 1 and v <= shape[i], "Indexing: out of bounds")

        index = index + (v - 1) * strides[i]
    end

    return index + 1 -- Lua 1-based indexing
end

function Indexing.to_flat_index(tensor, indexes)
    return Indexing.compute(
        tensor.shape,
        tensor.strides,
        tensor.offset,
        indexes
    )
end

return Indexing