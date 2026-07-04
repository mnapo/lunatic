local Vector = {}
Vector.__index = Vector

--
-- Constructor
--

function Vector.new(data)
    assert(data == nil or type(data) == "table",
        "Vector.new(): data must be a table or nil")

    local self = setmetatable({}, Vector)

    self.data = data or {}
    self.shape = { #self.data }
    self.ndim = 1
    self.size = #self.data

    return self
end

--
-- Public API
--

function Vector:get(index)
    return self.data[index]
end

function Vector:set(index, value)
    self.data[index] = value
end

function Vector:copy()
    local data = {}

    for i = 1, self.size do
        data[i] = self.data[i]
    end

    return Vector.new(data)
end

function Vector:map(fn)
    local data = {}

    for i = 1, self.size do
        data[i] = fn(self.data[i], i)
    end

    return Vector.new(data)
end

function Vector:add(other)
    assert(self.size == other.size,
        "Vector.add(): vectors must have the same size")

    local data = {}

    for i = 1, self.size do
        data[i] = self.data[i] + other.data[i]
    end

    return Vector.new(data)
end

function Vector:sub(other)
    assert(self.size == other.size,
        "Vector.sub(): vectors must have the same size")

    local data = {}

    for i = 1, self.size do
        data[i] = self.data[i] - other.data[i]
    end

    return Vector.new(data)
end

function Vector:scale(value)
    local data = {}

    for i = 1, self.size do
        data[i] = self.data[i] * value
    end

    return Vector.new(data)
end

function Vector:dot(other)
    assert(self.size == other.size,
        "Vector.dot(): vectors must have the same size")

    local sum = 0

    for i = 1, self.size do
        sum = sum + self.data[i] * other.data[i]
    end

    return sum
end

function Vector:norm()
    return math.sqrt(self:dot(self))
end

--
-- Metamethods
--

function Vector:__len()
    return self.size
end

function Vector:__tostring()
    return string.format(
        "Vector(shape={%d})",
        self.shape[1]
    )
end

function Vector:__add(other)
    return self:add(other)
end

function Vector:__sub(other)
    return self:sub(other)
end

function Vector:__unm()
    return self:scale(-1)
end

return Vector