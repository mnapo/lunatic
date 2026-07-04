Tensor = require("lunatic.math.tensor")

local function assert_equals(a, b, msg)
    if a ~= b then error((msg or "assert_equals failed") .. ": got " .. tostring(a) .. " expected " .. tostring(b)) end
end

local function test_incompatible_shapes()
    local a = Tensor.new({1,2}, {2})
    local b = Tensor.new({1,2,3}, {3})

    local ok, err = pcall(function() local _ = a + b end)
    assert(not ok and string.find(err, "Broadcast error"), "incompatible shapes should raise Broadcast error")
    print("incompatible shapes: pass")
end

local function test_scalar_and_matrix()
    local a = Tensor.new({10}, {1})
    local b = Tensor.new({1,2,3,4}, {2,2})

    local c = a + b
    assert_equals(#c, 4, "scalar+matrix size")
    assert_equals(c:get(1), 11, "scalar+matrix [1]")
    assert_equals(c:get(4), 14, "scalar+matrix [4]")
    print("scalar and matrix: pass")
end

local function test_singleton_middle_dim()
    local a = Tensor.new({1,2}, {2,1}) -- two rows, single column
    local b = Tensor.new({10,20,30,40,50,60}, {2,3}) -- two rows, three columns

    local c = a + b
    assert_equals(#c, 6, "singleton middle dim size")
    -- row1: 1 + [10,20,30] -> [11,21,31]
    assert_equals(c:get(1), 11, "singleton [1]")
    assert_equals(c:get(3), 31, "singleton [3]")
    -- row2: 2 + [40,50,60] -> [42,52,62]
    assert_equals(c:get(4), 42, "singleton [4]")
    assert_equals(c:get(6), 62, "singleton [6]")
    print("singleton middle dim: pass")
end

local function test_zero_dimension()
    local a = Tensor.new({}, {0})
    local b = Tensor.new({}, {0})

    local c = a + b
    assert_equals(#c, 0, "zero-dimension result size")
    print("zero-dimension: pass")
end

-- Run tests
print("Running broadcasting edge-case tests...")
test_incompatible_shapes()
test_scalar_and_matrix()
test_singleton_middle_dim()
test_zero_dimension()
print("All broadcasting edge-case tests passed")
