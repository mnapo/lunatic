local shape = require("lunatic.math.shape")
local broadcast = require("lunatic.math.broadcast")
local indexing = require("lunatic.math.internal.indexing")

local arithmetic = {}

arithmetic.factory = nil

function arithmetic.init(factory)
    arithmetic.factory = factory
end

local function ensure_factory()
    assert(arithmetic.factory, "arithmetic: factory not initialized")
end

--
-- Core Elementwise Operations
--

local function elementwise(a, b, op)
    ensure_factory()

    local out_shape = broadcast.resolve(a.shape, b.shape)
    local out_size = shape.size(out_shape)

    local data = {}

    for i = 1, out_size do

        -- 1. output linear → multi-index
        local out_idx = indexing.unravel(out_shape, i)

        -- 2. broadcast mapping
        local idxA, idxB = broadcast.map_index(
            out_idx,
            a.shape,
            b.shape,
            out_shape
        )

        -- 3. multi-index → linear index
        local linA = indexing.compute(a.shape, a.strides, a.offset, idxA)
        local linB = indexing.compute(b.shape, b.strides, b.offset, idxB)

        -- 4. value access
        local va = a.storage:get(linA)
        local vb = b.storage:get(linB)

        -- 5. apply op
        data[i] = op(va, vb)
    end

    return arithmetic.factory(data, out_shape)
end

--
-- Scalar Elementwise Operations
--

local function scalar_elementwise(a, scalar, op)
    ensure_factory()

    local data = {}
    local size = a.size

    for i = 1, size do
        local v = a.storage:get(i)
        data[i] = op(v, scalar)
    end

    return arithmetic.factory(data, a.shape)
end

--
-- Public ops
--

function arithmetic.add(a, b)
    return elementwise(a, b, function(x, y) return x + y end)
end

function arithmetic.sub(a, b)
    return elementwise(a, b, function(x, y) return x - y end)
end

function arithmetic.mul(a, b)
    return elementwise(a, b, function(x, y) return x * y end)
end

function arithmetic.div(a, b)
    return elementwise(a, b, function(x, y) return x / y end)
end

function arithmetic.scale(a, scalar)
    return scalar_elementwise(a, scalar, function(x, s) return x * s end)
end

function arithmetic.neg(a)
    return scalar_elementwise(a, 0, function(_, x) return -x end)
end

--
-- OPTIONAL: explicit elementwise API (future extensibility)
--

arithmetic.elementwise = elementwise

return arithmetic