local Shape = {}

function Shape.is_valid(shape)
    if type(shape) ~= "table" then
        return false, "shape must be a table"
    end

    for i = 1, #shape do
        local d = shape[i]

        if type(d) ~= "number" then
            return false, ("dimension %d must be a number"):format(i)
        end

        if d % 1 ~= 0 then
            return false, ("dimension %d must be an integer"):format(i)
        end

        if d < 0 then
            return false, ("dimension %d must be greater than or equal to zero"):format(i)
        end
    end

    return true
end

function Shape.size(shape)
    local s = 1
    for i = 1, #shape do
        s = s * shape[i]
    end
    return s
end

function Shape.rank(shape)
    return #shape
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