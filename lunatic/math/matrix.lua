local Matrix = {}
Matrix.__index = Matrix

--
-- Constructor
--

function Matrix.new(data)
    assert(type(data) == "table", "Matrix.new(): data must be a table")

    local rows = #data
    assert(rows > 0, "Matrix.new(): empty matrix")

    local cols = #data[1]
    assert(cols > 0, "Matrix.new(): invalid row size")

    -- validate rectangular shape
    for i = 2, rows do
        assert(#data[i] == cols,
            "Matrix.new(): non-rectangular matrix")
    end

    local self = setmetatable({}, Matrix)

    self.data = data
    self.shape = { rows, cols }
    self.ndim = 2
    self.size = rows * cols

    return self
end

--
-- Access
--

function Matrix:get(i, j)
    return self.data[i][j]
end

function Matrix:set(i, j, value)
    self.data[i][j] = value
end

--
-- Copy
--

function Matrix:copy()
    local data = {}

    for i = 1, self.shape[1] do
        data[i] = {}
        for j = 1, self.shape[2] do
            data[i][j] = self.data[i][j]
        end
    end

    return Matrix.new(data)
end

--
-- Element-wise map
--

function Matrix:map(fn)
    local data = {}

    for i = 1, self.shape[1] do
        data[i] = {}
        for j = 1, self.shape[2] do
            data[i][j] = fn(self.data[i][j], i, j)
        end
    end

    return Matrix.new(data)
end

--
-- Arithmetic
--

function Matrix:add(other)
    assert(self.shape[1] == other.shape[1] and self.shape[2] == other.shape[2],
        "Matrix.add(): shape mismatch")

    local data = {}

    for i = 1, self.shape[1] do
        data[i] = {}
        for j = 1, self.shape[2] do
            data[i][j] = self.data[i][j] + other.data[i][j]
        end
    end

    return Matrix.new(data)
end

function Matrix:sub(other)
    assert(self.shape[1] == other.shape[1] and self.shape[2] == other.shape[2],
        "Matrix.sub(): shape mismatch")

    local data = {}

    for i = 1, self.shape[1] do
        data[i] = {}
        for j = 1, self.shape[2] do
            data[i][j] = self.data[i][j] - other.data[i][j]
        end
    end

    return Matrix.new(data)
end

function Matrix:scale(scalar)
    local data = {}

    for i = 1, self.shape[1] do
        data[i] = {}
        for j = 1, self.shape[2] do
            data[i][j] = self.data[i][j] * scalar
        end
    end

    return Matrix.new(data)
end

--
-- Linear algebra (minimal)
--

function Matrix:transpose()
    local rows, cols = self.shape[1], self.shape[2]

    local data = {}

    for j = 1, cols do
        data[j] = {}
        for i = 1, rows do
            data[j][i] = self.data[i][j]
        end
    end

    return Matrix.new(data)
end

function Matrix:matmul(other)
    assert(self.shape[2] == other.shape[1],
        "Matrix.matmul(): incompatible shapes")

    local rows = self.shape[1]
    local cols = other.shape[2]
    local inner = self.shape[2]

    local data = {}

    for i = 1, rows do
        data[i] = {}
        for j = 1, cols do
            local sum = 0
            for k = 1, inner do
                sum = sum + self.data[i][k] * other.data[k][j]
            end
            data[i][j] = sum
        end
    end

    return Matrix.new(data)
end

--
-- Metamethods
--

function Matrix:__add(other)
    return self:add(other)
end

function Matrix:__sub(other)
    return self:sub(other)
end

function Matrix:__unm()
    return self:scale(-1)
end

function Matrix:__len()
    return self.shape[1]
end

function Matrix:__tostring()
    return string.format(
        "Matrix(shape={%d,%d})",
        self.shape[1],
        self.shape[2]
    )
end

return Matrix