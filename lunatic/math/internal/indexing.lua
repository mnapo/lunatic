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

function Indexing.unravel(shape, index)
    local out = {}

    local remaining = index - 1

    for i = #shape, 1, -1 do
        local dim = shape[i]
        out[i] = (remaining % dim) + 1
        remaining = math.floor(remaining / dim)
    end

    return out
end

return Indexing