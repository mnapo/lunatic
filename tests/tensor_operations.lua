local lunatic = require("lunatic")

local function assert_equals(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

local function assert_almost_equals(actual, expected, message, epsilon)
    epsilon = epsilon or 1e-10
    assert(math.abs(actual - expected) < epsilon, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

local function test_tensor_operations()
    local Tensor = lunatic.math.Tensor
    assert(type(Tensor) == "table", "expected Tensor module to be exported")

    -- Test creation
    local data = {1, 2, 3, 4, 5, 6}
    local shape = {2, 3}
    local t1 = Tensor.new(data, shape)
    assert_equals(t1.size, 6, "tensor size")
    assert_equals(t1.ndim, 2, "tensor ndim")
    assert_equals(t1.shape[1], 2, "tensor shape[1]")
    assert_equals(t1.shape[2], 3, "tensor shape[2]")

    -- Test access
    assert_equals(t1:get(1), 1, "tensor get(1)")
    assert_equals(t1:get(6), 6, "tensor get(6)")

    -- Test set
    t1:set(3, 10)
    assert_equals(t1:get(3), 10, "tensor set/get")

    -- Test copy
    local t1_copy = t1:copy()
    t1_copy:set(1, 99)
    assert_equals(t1:get(1), 1, "tensor copy independence")
    assert_equals(t1_copy:get(1), 99, "tensor copy modification")

    -- Test reshape
    local t2_data = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
    local t2 = Tensor.new(t2_data, {3, 4})
    local t2_reshaped = t2:reshape({2, 6})
    assert_equals(t2_reshaped.shape[1], 2, "reshaped shape[1]")
    assert_equals(t2_reshaped.shape[2], 6, "reshaped shape[2]")
    assert_equals(t2_reshaped:get(1), 1, "reshaped data preserved")
    assert_equals(t2_reshaped:get(12), 12, "reshaped data preserved")

    -- Test addition
    local t3_data = {1, 2, 3, 4}
    local t3 = Tensor.new(t3_data, {2, 2})
    local t4_data = {5, 6, 7, 8}
    local t4 = Tensor.new(t4_data, {2, 2})
    local sum = t3 + t4
    assert_equals(sum:get(1), 6, "tensor addition [1]")
    assert_equals(sum:get(4), 12, "tensor addition [4]")

    -- Test subtraction
    local diff = t4 - t3
    assert_equals(diff:get(1), 4, "tensor subtraction [1]")
    assert_equals(diff:get(4), 4, "tensor subtraction [4]")

    -- Test scaling
    local scaled = t3:scale(2)
    assert_equals(scaled:get(1), 2, "tensor scale [1]")
    assert_equals(scaled:get(4), 8, "tensor scale [4]")

    -- Test sum
    local t5_data = {1, 2, 3, 4}
    local t5 = Tensor.new(t5_data, {2, 2})
    assert_equals(t5:sum(), 10, "tensor sum")

    -- Test mean
    assert_almost_equals(t5:mean(), 2.5, "tensor mean")

    -- Test flatten
    local t6_data = {1, 2, 3, 4, 5, 6}
    local t6 = Tensor.new(t6_data, {2, 3})
    local flattened = t6:flatten()
    assert_equals(flattened.shape[1], 6, "flattened shape")
    assert_equals(flattened:get(3), 3, "flattened data")

    -- Test map
    local t7_data = {1, 2, 3}
    local t7 = Tensor.new(t7_data, {3})
    local mapped = t7:map(function(x) return x * 2 end)
    assert_equals(mapped:get(1), 2, "tensor map [1]")
    assert_equals(mapped:get(3), 6, "tensor map [3]")

    -- Test negation
    local neg = -t3
    assert_equals(neg:get(1), -1, "tensor negation [1]")
    assert_equals(neg:get(4), -4, "tensor negation [4]")
end

test_tensor_operations()
print("tensor operations test passed")
