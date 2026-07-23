local shape = require("lunatic.math.shape")
local broadcast = require("lunatic.math.broadcast")
local indexing = require("lunatic.math.internal.indexing")
local Node = require("lunatic.math.autograd.node")
local Context = require("lunatic.math.autograd.context")
local AddGrad = require("lunatic.math.autograd.functions.add")
local MulGrad = require("lunatic.math.autograd.functions.mul")
local SubGrad = require("lunatic.math.autograd.functions.sub")
local NegGrad = require("lunatic.math.autograd.functions.neg")
local DivGrad = require("lunatic.math.autograd.functions.div")

local arithmetic = {}

arithmetic.factory = nil

function arithmetic.init(factory)
    arithmetic.factory = factory
end

local function ensure_factory()
    assert(arithmetic.factory, "arithmetic: factory not initialized")
end

--
-- Autograd helpers
--

local function attach_grad_fn(result, operation, inputs, backward_fn)

    if not Context.is_enabled() then
        return result
    end
    
    local requires_grad = false

    for _, tensor in ipairs(inputs) do
        if tensor.requires_grad then
            requires_grad = true
            break
        end
    end

    if not requires_grad then
        return result
    end

    result.requires_grad = true

    local node = Node.new(
        operation,
        inputs,
        backward_fn
    )

    node:set_output(result)

    result.grad_fn = node

    return result
end

--
-- Core Elementwise Operations
--

local function elementwise(a, b, op)
    ensure_factory()

    local out_shape = broadcast.resolve(a.shape, b.shape)
    local out_size = shape.size(out_shape)

    local data = {}

    -- normalize shapes to output ndim and build normalized strides
    local ndim = #out_shape
    local A = shape.normalize(a.shape, ndim)
    local B = shape.normalize(b.shape, ndim)

    local function normalize_strides(tensor, norm_shape)
        local out = {}
        local orig_ndim = #tensor.shape
        for i = 1, #norm_shape do
            local orig_idx = orig_ndim - #norm_shape + i
            if orig_idx >= 1 then
                out[i] = tensor.strides[orig_idx]
            else
                out[i] = 0
            end
        end
        return out
    end

    local stridesA = normalize_strides(a, A)
    local stridesB = normalize_strides(b, B)

    for i = 1, out_size do
        local out_idx = indexing.unravel(out_shape, i)

        local idxA, idxB = broadcast.map_index(out_idx, a.shape, b.shape, out_shape)

        local linA = indexing.compute(A, stridesA, a.offset, idxA)
        local linB = indexing.compute(B, stridesB, b.offset, idxB)

        local va = a.storage:get(linA)
        local vb = b.storage:get(linB)

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

    local result = elementwise(
        a,
        b,
        function(x, y)
            return x + y
        end
    )

    return attach_grad_fn(
        result,
        "add",
        {a, b},
        AddGrad.backward
    )

end

function arithmetic.sub(a, b)

    local result = elementwise(
        a,
        b,
        function(x, y)
            return x - y
        end
    )

    return attach_grad_fn(
        result,
        "sub",
        {a, b},
        SubGrad.backward
    )

end

function arithmetic.mul(a, b)

    local result = elementwise(
        a,
        b,
        function(x, y)
            return x * y
        end
    )

    return attach_grad_fn(
        result,
        "mul",
        {a, b},
        MulGrad.backward
    )

end

function arithmetic.sub(a, b)

    local result = elementwise(
        a,
        b,
        function(x, y)
            return x / y
        end
    )

    return attach_grad_fn(
        result,
        "div",
        {a, b},
        DivGrad.backward
    )

end

function arithmetic.scale(a, scalar)
    return scalar_elementwise(a, scalar, function(x, s) return x * s end)
end

function arithmetic.neg(a)

    local result = scalar_elementwise(
        a,
        0,
        function(_, x)
            return -x
        end
    )

    return attach_grad_fn(
        result,
        "neg",
        {a},
        NegGrad.backward
    )

end

--
-- OPTIONAL: explicit elementwise API (future extensibility)
--

arithmetic.elementwise = elementwise

return arithmetic