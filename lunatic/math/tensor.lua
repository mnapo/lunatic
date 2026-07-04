local Storage = require("lunatic.math.internal.storage")
local stride = require("lunatic.math.internal.stride")
local Shape = require("lunatic.math.shape")

local arithmetic = require("lunatic.math.ops.arithmetic")
arithmetic.init(tensor_factory)

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

local function compute_index(t, indexes)
    assert(#indexes == t.ndim, "Tensor:get(): wrong number of indexes")

    local idx = t.offset or 0

    for i = 1, t.ndim do
        local v = indexes[i]
        assert(v >= 1 and v <= t.shape[i], "Tensor:get(): index out of bounds")

        idx = idx + (v - 1) * t.strides[i]
    end

    return idx + 1 -- Lua 1-based
end

--
-- Constructor
--

function Tensor.new(data, shape)
    assert(type(data) == "table", "Tensor.new(): data must be table")
    assert(type(shape) == "table", "Tensor.new(): shape must be table")

    local ok, err = Shape.is_valid(shape)
    assert(ok, err)

    local size = Shape.size(shape)

    assert(#data == size,
        "Tensor.new(): data size does not match shape")

    local self = setmetatable({}, Tensor)

    self.storage = Storage.new(clone_data(data))

    self.shape = shape
    self.ndim = Shape.rank(shape)
    self.size = size
    self.strides = Stride.compute(shape)
    self.offset = 0

    return self
end

--
-- Getters
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

--
-- Access (flat for now, via storage)
--

function Tensor:get(...)
    local indexes = { ... }

    -- backward compatible flat access
    if #indexes == 1 then
        return self.storage:get(indexes[1])
    end

    local index = compute_index(self, indexes)
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

    local index = compute_index(self, args)
    self.storage:set(index, value)
end

--
-- Reshape (no copy)
--

function Tensor:reshape(new_shape)
    local new_size = product(new_shape)

    assert(new_size == self.size,
        "Tensor.reshape(): incompatible shape")

    local t = Tensor.new(self.storage:raw(), new_shape)
    return t
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

function Tensor:sum()
    local s = 0

    for i = 1, self.size do
        s = s + self.storage:get(i)
    end

    return s
end

function Tensor:mean()
    return self:sum() / self.size
end

--
-- Shape ops
--

function Tensor:flatten()
    return Tensor.new(self.storage:raw(), {self.size})
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

function Tensor:__sub(other)
    return self:sub(other)
end

function Tensor:__unm()
    return self:scale(-1)
end

function Tensor:__tostring()
    return "Tensor(shape={" .. table.concat(self.shape, ",") .. "})"
end

return Tensor