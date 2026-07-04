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

    --[[ Test reshape
    local t2_data = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
    local t2 = Tensor.new(t2_data, {3, 4})
    local t2_reshaped = t2:reshape({2, 6})
    assert_equals(t2_reshaped.shape[1], 2, "reshaped shape[1]")
    assert_equals(t2_reshaped.shape[2], 6, "reshaped shape[2]")
    assert_equals(t2_reshaped:get(1), 1, "reshaped data preserved")
    assert_equals(t2_reshaped:get(12), 12, "reshaped data preserved")
    ]]
    
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

local function test_new_api_methods()
    local Tensor = lunatic.math.Tensor

    -- Test :add() method (as opposed to + operator)
    local t1_data = {1, 2, 3, 4}
    local t1 = Tensor.new(t1_data, {2, 2})
    local t2_data = {5, 6, 7, 8}
    local t2 = Tensor.new(t2_data, {2, 2})
    
    local sum_method = t1:add(t2)
    assert_equals(sum_method:get(1), 6, "tensor :add() method [1]")
    assert_equals(sum_method:get(2), 8, "tensor :add() method [2]")
    assert_equals(sum_method:get(4), 12, "tensor :add() method [4]")

    -- Test :sub() method (as opposed to - operator)
    local diff_method = t2:sub(t1)
    assert_equals(diff_method:get(1), 4, "tensor :sub() method [1]")
    assert_equals(diff_method:get(2), 4, "tensor :sub() method [2]")
    assert_equals(diff_method:get(4), 4, "tensor :sub() method [4]")

    -- Test multi-dimensional indexing with :set() and :get()
    local t3_data = {1, 2, 3, 4, 5, 6}
    local t3 = Tensor.new(t3_data, {2, 3})
    t3:set(1, 2, 99)  -- Set element at [1,2]
    assert_equals(t3:get(1, 2), 99, "tensor multi-dim set/get [1,2]")
    
    -- Verify original [1,1] unchanged
    assert_equals(t3:get(1, 1), 1, "tensor multi-dim get [1,1]")
    
    -- Verify flat access still works on same tensor
    assert_equals(t3:get(2), 99, "tensor multi-dim flat access after set")

    -- Test :scale() with larger tensor
    local t4_data = {1, 2, 3}
    local t4 = Tensor.new(t4_data, {3})
    local scaled = t4:scale(3)
    assert_equals(scaled:get(1), 3, "tensor :scale() [1]")
    assert_equals(scaled:get(2), 6, "tensor :scale() [2]")
    assert_equals(scaled:get(3), 9, "tensor :scale() [3]")

    print("new API methods test passed")
end

local function test_backward_compatibility()
    local Tensor = lunatic.math.Tensor

    -- Create tensor using new API
    local data = {1, 2, 3, 4, 5, 6}
    local t = Tensor.new(data, {2, 3})

    -- Verify old flat access still works
    assert_equals(t:get(1), 1, "backward compat: flat get [1]")
    assert_equals(t:get(2), 2, "backward compat: flat get [2]")
    assert_equals(t:get(6), 6, "backward compat: flat get [6]")

    -- Verify old flat set still works
    t:set(3, 99)
    assert_equals(t:get(3), 99, "backward compat: flat set/get")

    -- Verify metamethods work alongside new methods
    local t1_data = {1, 2, 3, 4}
    local t1 = Tensor.new(t1_data, {2, 2})
    local t2_data = {1, 1, 1, 1}
    local t2 = Tensor.new(t2_data, {2, 2})

    -- Using + operator
    local sum_operator = t1 + t2
    assert_equals(sum_operator:get(1), 2, "backward compat: + operator")

    -- Using :add() method
    local sum_method = t1:add(t2)
    assert_equals(sum_method:get(1), 2, "backward compat: :add() method same result")

    -- Both should produce same result
    assert_equals(sum_operator:get(4), sum_method:get(4), "backward compat: + operator vs :add() consistency")

    -- Verify that old property access still works
    assert_equals(t1.size, 4, "backward compat: .size property")
    assert_equals(t1.ndim, 2, "backward compat: .ndim property")
    assert_equals(t1.shape[1], 2, "backward compat: .shape property")

    print("backward compatibility test passed")
end

test_tensor_operations()
test_new_api_methods()
test_backward_compatibility()
print("all tensor operations tests passed")
