local Tensor = require("lunatic.math.tensor")

local function assert_equals(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

local function assert_raises(fn, message)
    local ok, err = pcall(fn)
    assert(not ok, message or "expected failure")
    assert(type(err) == "string" and err ~= "", "expected an error message")
end

local function test_reshape_preserves_data_and_shape()
    local t = Tensor.new({1, 2, 3, 4, 5, 6}, {2, 3})
    local reshaped = t:reshape({3, 2})

    assert_equals(reshaped.shape[1], 3, "reshape row count")
    assert_equals(reshaped.shape[2], 2, "reshape column count")
    assert_equals(reshaped:get(1), 1, "reshape preserves first element")
    assert_equals(reshaped:get(6), 6, "reshape preserves last element")
    assert_equals(reshaped:get(2, 1), 3, "reshape preserves multi-index mapping")
    print("reshape preserves data and shape: pass")
end

local function test_reshape_rejects_incompatible_sizes()
    local t = Tensor.new({1, 2, 3, 4}, {2, 2})

    assert_raises(function()
        t:reshape({2, 3})
    end, "reshape should reject incompatible sizes")

    print("reshape rejects incompatible sizes: pass")
end

local function test_flatten_returns_single_dim_tensor()
    local t = Tensor.new({1, 2, 3, 4, 5, 6}, {2, 3})
    local flat = t:flatten()

    assert_equals(flat.shape[1], 6, "flatten shape")
    assert_equals(flat.ndim, 1, "flatten ndim")
    assert_equals(flat:get(1), 1, "flatten first element")
    assert_equals(flat:get(6), 6, "flatten last element")
    print("flatten returns single-dimension tensor: pass")
end

local function test_flatten_after_reshape_roundtrip()
    local t = Tensor.new({10, 20, 30, 40}, {2, 2})
    local reshaped = t:reshape({4, 1})
    local flat = reshaped:flatten()

    assert_equals(flat.shape[1], 4, "flatten-after-reshape shape")
    assert_equals(flat:get(3), 30, "flatten-after-reshape element")
    print("flatten after reshape roundtrip: pass")
end

print("Running shape ops tests...")
test_reshape_preserves_data_and_shape()
test_reshape_rejects_incompatible_sizes()
test_flatten_returns_single_dim_tensor()
test_flatten_after_reshape_roundtrip()
print("All shape ops tests passed")
