local Tensor = {}
Tensor.__index = Tensor

--
-- Helpers
--

local function product(shape)
    local p = 1
    for i = 1, #shape do
        p = p * shape[i]
    end
    return p
end

local function clone_data(data)
    local out = {}
    for i = 1, #data do
        out[i] = data[i]
    end
    return out
end

--
-- Constructor
--

function Tensor.new(data, shape)
    assert(type(data) == "table", "Tensor.new(): data must be table")
    assert(type(shape) == "table", "Tensor.new(): shape must be table")

    local size = product(shape)

    assert(#data == size,
        "Tensor.new(): data size does not match shape")

    local self = setmetatable({}, Tensor)

    self.data = clone_data(data)
    self.shape = shape
    self.ndim = #shape
    self.size = size

    return self
end

--
-- Access (flat for now)
--

function Tensor:get(i)
    return self.data[i]
end

function Tensor:set(i, value)
    self.data[i] = value
end

--
-- Reshape (no copy, just view conceptually)
--

function Tensor:reshape(new_shape)
    local new_size = product(new_shape)

    assert(new_size == self.size,
        "Tensor.reshape(): incompatible shape")

    local t = Tensor.new(self.data, new_shape)
    return t
end

--
-- Copy
--

function Tensor:copy()
    return Tensor.new(clone_data(self.data), self.shape)
end

--
-- Map
--

function Tensor:map(fn)
    local data = {}

    for i = 1, self.size do
        data[i] = fn(self.data[i], i)
    end

    return Tensor.new(data, self.shape)
end

--
-- Arithmetic (element-wise)
--

function Tensor:add(other)
    assert(self.size == other.size,
        "Tensor.add(): size mismatch")

    local data = {}

    for i = 1, self.size do
        data[i] = self.data[i] + other.data[i]
    end

    return Tensor.new(data, self.shape)
end

function Tensor:sub(other)
    assert(self.size == other.size,
        "Tensor.sub(): size mismatch")

    local data = {}

    for i = 1, self.size do
        data[i] = self.data[i] - other.data[i]
    end

    return Tensor.new(data, self.shape)
end

function Tensor:scale(scalar)
    local data = {}

    for i = 1, self.size do
        data[i] = self.data[i] * scalar
    end

    return Tensor.new(data, self.shape)
end

--
-- Reduction (basic)
--

function Tensor:sum()
    local s = 0
    for i = 1, self.size do
        s = s + self.data[i]
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
    return Tensor.new(self.data, {self.size})
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
    local s = "Tensor(shape={" .. table.concat(self.shape, ",") .. "})"
    return s
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

return Tensor