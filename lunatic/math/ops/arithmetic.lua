local arithmetic = {}

--
-- Internal helpers
--

local function elementwise(a, b, op)
    local size = a.size
    local data = {}

    local a_storage = a.storage:raw()
    local b_storage = b.storage:raw()

    for i = 1, size do
        data[i] = op(a_storage[i], b_storage[i])
    end

    return data
end

local function elementwise_scalar(a, scalar, op)
    local size = a.size
    local data = {}

    local a_storage = a.storage:raw()

    for i = 1, size do
        data[i] = op(a_storage[i], scalar)
    end

    return data
end

--
-- Operations
--

function arithmetic.add(a, b)
    -- NOTE: broadcasting will replace this in LAS-009
    assert(a.size == b.size, "arithmetic.add: size mismatch")

    local data = elementwise(a, b, function(x, y)
        return x + y
    end)

    return a.__tensor_factory(data, a.shape)
end

function arithmetic.sub(a, b)
    assert(a.size == b.size, "arithmetic.sub: size mismatch")

    local data = elementwise(a, b, function(x, y)
        return x - y
    end)

    return a.__tensor_factory(data, a.shape)
end

function arithmetic.mul(a, b)
    assert(a.size == b.size, "arithmetic.mul: size mismatch")

    local data = elementwise(a, b, function(x, y)
        return x * y
    end)

    return a.__tensor_factory(data, a.shape)
end

function arithmetic.scale(a, scalar)
    local data = elementwise_scalar(a, scalar, function(x, s)
        return x * s
    end)

    return a.__tensor_factory(data, a.shape)
end

function arithmetic.neg(a)
    local data = elementwise_scalar(a, 0, function(_, x)
        return -x
    end)

    return a.__tensor_factory(data, a.shape)
end

return arithmetic