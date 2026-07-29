local shape = require("lunatic.math.shape")
local broadcast = require("lunatic.math.broadcast")
local indexing = require("lunatic.math.internal.indexing")

local Node = require("lunatic.math.autograd.node")
local Context = require("lunatic.math.autograd.context")

local AddGrad = require("lunatic.math.autograd.functions.add")
local SubGrad = require("lunatic.math.autograd.functions.sub")
local MulGrad = require("lunatic.math.autograd.functions.mul")
local DivGrad = require("lunatic.math.autograd.functions.div")
local NegGrad = require("lunatic.math.autograd.functions.neg")

local arithmetic = {}

arithmetic.factory = nil


function arithmetic.init(factory)
    arithmetic.factory = factory
end


local function ensure_factory()
    assert(
        arithmetic.factory,
        "arithmetic: factory not initialized"
    )
end


--
-- Autograd
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
-- Tensor-Tensor elementwise
--

local function elementwise(a, b, operation)

    ensure_factory()

    local out_shape =
        broadcast.resolve(
            a.shape,
            b.shape
        )


    local out_size =
        shape.size(out_shape)


    local data = {}


    local ndim = #out_shape

    local A =
        shape.normalize(
            a.shape,
            ndim
        )

    local B =
        shape.normalize(
            b.shape,
            ndim
        )


    local function normalize_strides(tensor)

        local out = {}
        local offset =
            ndim - #tensor.shape

        for i = 1, ndim do

            local source = i - offset

            if source >= 1 then
                out[i] = tensor.strides[source]
            else
                out[i] = 0
            end

        end

        return out
    end


    local stridesA = normalize_strides(a)
    local stridesB = normalize_strides(b)


    for i = 1, out_size do

        local out_index =
            indexing.unravel(
                out_shape,
                i
            )


        local idxA, idxB =
            broadcast.map_index(
                out_index,
                a.shape,
                b.shape,
                out_shape
            )


        local flatA =
            indexing.compute(
                A,
                stridesA,
                a.offset,
                idxA
            )


        local flatB =
            indexing.compute(
                B,
                stridesB,
                b.offset,
                idxB
            )


        data[i] =
            operation(
                a.storage:get(flatA),
                b.storage:get(flatB)
            )

    end


    return arithmetic.factory(
        data,
        out_shape
    )

end


--
-- Scalar operations
--

local function scalar_elementwise(a, scalar, operation)

    ensure_factory()

    local data = {}

    for i = 1, a.size do

        data[i] =
            operation(
                a.storage:get(i),
                scalar
            )

    end


    return arithmetic.factory(
        data,
        a.shape
    )

end


--
-- Public operations
--

function arithmetic.add(a, b)

    return attach_grad_fn(
        elementwise(
            a,
            b,
            function(x, y)
                return x + y
            end
        ),
        "add",
        {a, b},
        AddGrad.backward
    )

end


function arithmetic.sub(a, b)

    return attach_grad_fn(
        elementwise(
            a,
            b,
            function(x, y)
                return x - y
            end
        ),
        "sub",
        {a, b},
        SubGrad.backward
    )

end


function arithmetic.mul(a, b)

    return attach_grad_fn(
        elementwise(
            a,
            b,
            function(x, y)
                return x * y
            end
        ),
        "mul",
        {a, b},
        MulGrad.backward
    )

end


function arithmetic.div(a, b)

    return attach_grad_fn(
        elementwise(
            a,
            b,
            function(x, y)
                return x / y
            end
        ),
        "div",
        {a, b},
        DivGrad.backward
    )

end


function arithmetic.scale(a, scalar)

    return scalar_elementwise(
        a,
        scalar,
        function(x, s)
            return x * s
        end
    )

end


function arithmetic.neg(a)

    return attach_grad_fn(
        scalar_elementwise(
            a,
            0,
            function(x, _)
                return -x
            end
        ),
        "neg",
        {a},
        NegGrad.backward
    )

end


return arithmetic