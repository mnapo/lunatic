local Storage = require("lunatic.math.internal.storage")
local stride = require("lunatic.math.internal.stride")
local shape = require("lunatic.math.shape")
local indexing = require("lunatic.math.internal.indexing")
local engine = require("lunatic.math.autograd.engine")

local Tensor = {}
Tensor.__index = Tensor

--
-- Helpers
--

local function clone_data(data)
    local out = {}
    for i = 1, #data do
        out[i] = data[i]
    end
    return out
end

local function init_autograd(self)
    self.requires_grad = false
    self.grad = nil
    self.grad_fn = nil
end

--
-- Construction logic
--

function Tensor.new(data_table, shape_table)
    assert(type(data_table) == "table", "Tensor.new(): data_table must be table")
    assert(type(shape_table) == "table", "Tensor.new(): shape_table must be table")

    local ok, err = shape.is_valid(shape_table)
    assert(ok, err)

    local size = shape.size(shape_table)

    assert(#data_table == size,
        "Tensor.new(): data size does not match shape")

    local self = setmetatable({}, Tensor)

    self.storage = Storage.new(clone_data(data_table))

    self.shape = shape_table
    self.ndim = shape.rank(shape_table)
    self.size = size
    self.strides = stride.compute(shape_table)
    self.offset = 0

    return self
end

local arithmetic = require("lunatic.math.ops.arithmetic")
local reduction = require("lunatic.math.ops.reduction")
local TensorFactory = require("lunatic.math.internal.tensor_factory")

TensorFactory.init(Tensor.new)
arithmetic.init(TensorFactory.create)
reduction.init(TensorFactory.create)

function Tensor._from_storage(storage, shape_table, offset, autograd)
    local self = setmetatable({}, Tensor)

    self.storage = storage

    self.shape = shape_table
    self.ndim = #shape_table
    self.size = shape.size(shape_table)
    self.strides = stride.compute(shape_table)
    self.offset = offset or 0

    if autograd then
        self.requires_grad = autograd.requires_grad
        self.grad = autograd.grad
        self.grad_fn = autograd.grad_fn
    else
        init_autograd(self)
    end

    return self
end

--
-- Getters/Setters
--

function Tensor:shape()
    return self.shape
end

function Tensor:ndim()
    return self.ndim
end

function Tensor:numel()
    return self.size
end

function Tensor:set_requires_grad(value)
    self.requires_grad = value
end

function Tensor:zero_grad()
    self.grad = nil
end

--
-- Access (flat for now, via storage)
--

function Tensor:get(...)
    local indexes = { ... }

    if #indexes == 1 then
        return self.storage:get(indexes[1])
    end

    local index = indexing.to_flat_index(self, indexes)
    return self.storage:get(index)
end

function Tensor:set(...)
    local args = { ... }

    local value = args[#args]
    table.remove(args, #args)

    if #args == 1 then
        self.storage:set(args[1], value)
        return
    end

    local index = indexing.to_flat_index(self, args)
    self.storage:set(index, value)
end

--
-- Shape ops (without copy)
--

function Tensor:reshape(new_shape)
    local new_size = shape.size(new_shape)

    assert(
        new_size == self.size,
        "Tensor.reshape(): incompatible shape"
    )

    return Tensor._from_storage(
        self.storage,
        new_shape,
        self.offset,
        {
            requires_grad = self.requires_grad,
            grad = self.grad,
            grad_fn = self.grad_fn
        }
    )
end

function Tensor:flatten()
    return self:reshape({self.size})
end

--
-- Copy
--

function Tensor:copy()
    return Tensor.new(self.storage:clone():raw(), self.shape)
end

--
-- Map
--

function Tensor:map(fn)
    local data = self.storage:raw()
    local out = {}

    for i = 1, self.size do
        out[i] = fn(data[i], i)
    end

    return Tensor.new(out, self.shape)
end

--
-- Elementwise helper
--

local function elementwise(a, b, op)
    local data = {}

    for i = 1, a.size do
        data[i] = op(a.storage:get(i), b.storage:get(i))
    end

    return Tensor.new(data, a.shape)
end

--
-- Arithmetic
--

function Tensor:add(other)
    return arithmetic.add(self, other)
end

function Tensor:sub(other)
    return arithmetic.sub(self, other)
end

function Tensor:mul(other)
    return arithmetic.mul(self, other)
end

function Tensor:scale(scalar)
    return arithmetic.scale(self, scalar)
end

function Tensor:neg()
    return arithmetic.neg(self)
end

--
-- Reduction
--

function Tensor:sum(...)
    return reduction.sum(self, ...)
end

function Tensor:mean(...)
    return reduction.mean(self, ...)
end

--
-- Metamethods
--

function Tensor:__len()
    return self.size
end

function Tensor:__add(other)
    return self:add(other)
end

function Tensor:__mul(other)
    return self:mul(other)
end

function Tensor:__div(other)
    return arithmetic.div(self, other)
end

function Tensor:__sub(other)
    return self:sub(other)
end

function Tensor:__unm()
    return self:neg()
end

function Tensor:__tostring()
    return "Tensor(shape={" .. table.concat(self.shape, ",") .. "})"
end

--
-- Autograd methods
--

function Tensor:backward(gradient)

    if gradient == nil then
        gradient = Tensor.new({1}, {1})
    end

    engine.backward(
        self,
        gradient
    )

end

return Tensor