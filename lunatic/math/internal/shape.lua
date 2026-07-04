local Shape = {}

function Shape.size(shape)
    local s = 1
    for i = 1, #shape do
        s = s * shape[i]
    end
    return s
end

function Shape.equals(a, b)
    if #a ~= #b then return false end
    for i = 1, #a do
        if a[i] ~= b[i] then return false end
    end
    return true
end

function Shape.normalize(shape, ndim)
    local out = {}

    for i = 1, ndim do
        out[i] = shape[#shape - ndim + i] or 1
    end

    return out
end

return Shape