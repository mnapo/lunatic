local shape = require("lunatic.math.shape")
local broadcast = require("lunatic.math.broadcast")

local arithmetic = {}

--
-- Tensor Factory injection
--

arithmetic.factory = nil

function arithmetic.init(factory)
    arithmetic.factory = factory
end

--
-- Helpers
--

local function align_shapes(a_shape, b_shape)
    local max_dim = math.max(#a_shape, #b_shape)

    local A = shape.normalize(a_shape, max_dim)
    local B = shape.normalize(b_shape, max_dim)

    return A, B
end

local function resolve_broadcast_shape(a_shape, b_shape)
    local A, B = align_shapes(a_shape, b_shape)

    local result = {}

    for i = 1, #A do
        if A[i] == B[i] then
            result[i] = A[i]
        elseif A[i] == 1 then
            result[i] = B[i]
        elseif B[i] == 1 then
            result[i] = A[i]
        else
            error("Broadcast error: incompatible shapes")
        end
    end

    return result
end

local function map_index(out_idx, shape, target_shape)
    local idx_a = {}
    local idx_b = {}

    for i = 1, #shape do
        if target_shape[i] == 1 then
            idx_a[i] = 1
        else
            idx_a[i] = out_idx[i]
        end

        if target_shape[i] == 1 then
            idx_b[i] = 1
        else
            idx_b[i] = out_idx[i]
        end
    end

    return idx_a, idx_b
end

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
-- Guard: ensure initialization
--

local function ensure_factory()
    assert(arithmetic.factory, "arithmetic: factory not initialized")
end

--
-- Ops
--

function arithmetic.add(a, b)
    ensure_factory()

    local out_shape = broadcast.resolve(a.shape, b.shape)

    local data = {}

    local max_size = shape.size(out_shape)

    for i = 1, max_size do

        -- convert linear index to multi-index (via strides-like expansion)
        local idx = i - 1

        local a_val, b_val

        if a.size == 1 then
            a_val = a.storage:get(1)
        else
            a_val = a.storage:get(i)
        end

        if b.size == 1 then
            b_val = b.storage:get(1)
        else
            b_val = b.storage:get(i)
        end

        data[i] = a_val + b_val
    end

    return arithmetic.factory(data, out_shape)
end

function arithmetic.sub(a, b)
    ensure_factory()
    assert(a.size == b.size, "sub: size mismatch")

    local data = elementwise(a, b, function(x, y)
        return x - y
    end)

    return arithmetic.factory(data, a.shape)
end

function arithmetic.mul(a, b)
    ensure_factory()
    assert(a.size == b.size, "mul: size mismatch")

    local data = elementwise(a, b, function(x, y)
        return x * y
    end)

    return arithmetic.factory(data, a.shape)
end

function arithmetic.scale(a, scalar)
    ensure_factory()

    local data = elementwise_scalar(a, scalar, function(x, s)
        return x * s
    end)

    return arithmetic.factory(data, a.shape)
end

function arithmetic.neg(a)
    ensure_factory()

    local data = elementwise_scalar(a, 0, function(_, x)
        return -x
    end)

    return arithmetic.factory(data, a.shape)
end

return arithmetic