local lunatic = require("lunatic")

local function assert_equals(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

local function test_matrix_operations()
    local Matrix = lunatic.math.Matrix
    assert(type(Matrix) == "table", "expected Matrix module to be exported from entrypoint")

    -- Test creation and access
    local m1 = Matrix.new({
        {1, 2},
        {3, 4}
    })
    assert_equals(m1:get(1, 1), 1, "matrix access [1,1]")
    assert_equals(m1:get(2, 2), 4, "matrix access [2,2]")
    assert_equals(m1.shape[1], 2, "matrix rows")
    assert_equals(m1.shape[2], 2, "matrix cols")

    -- Test addition
    local m2 = Matrix.new({
        {5, 6},
        {7, 8}
    })
    local sum = m1 + m2
    assert_equals(sum:get(1, 1), 6, "addition [1,1]")
    assert_equals(sum:get(2, 2), 12, "addition [2,2]")

    -- Test subtraction
    local diff = m2 - m1
    assert_equals(diff:get(1, 1), 4, "subtraction [1,1]")
    assert_equals(diff:get(2, 2), 4, "subtraction [2,2]")

    -- Test scaling
    local scaled = m1:scale(3)
    assert_equals(scaled:get(1, 1), 3, "scale [1,1]")
    assert_equals(scaled:get(2, 2), 12, "scale [2,2]")

    -- Test transpose
    local transposed = m1:transpose()
    assert_equals(transposed:get(1, 2), 3, "transpose [1,2]")
    assert_equals(transposed:get(2, 1), 2, "transpose [2,1]")
    assert_equals(transposed.shape[1], 2, "transpose rows")
    assert_equals(transposed.shape[2], 2, "transpose cols")

    -- Test matrix multiplication
    local m3 = Matrix.new({
        {1, 0},
        {0, 1}
    })
    local product = m1:matmul(m3)
    assert_equals(product:get(1, 1), 1, "matmul [1,1]")
    assert_equals(product:get(1, 2), 2, "matmul [1,2]")
    assert_equals(product:get(2, 1), 3, "matmul [2,1]")
    assert_equals(product:get(2, 2), 4, "matmul [2,2]")

    -- Test non-square matrix operations
    local m4 = Matrix.new({
        {1, 2, 3},
        {4, 5, 6}
    })
    local m5 = Matrix.new({
        {7, 8},
        {9, 10},
        {11, 12}
    })
    local product2 = m4:matmul(m5)
    assert_equals(product2.shape[1], 2, "non-square matmul rows")
    assert_equals(product2.shape[2], 2, "non-square matmul cols")
    assert_equals(product2:get(1, 1), 58, "non-square matmul [1,1]")
    assert_equals(product2:get(2, 1), 139, "non-square matmul [2,1]")
end

test_matrix_operations()
print("matrix operations test passed")
