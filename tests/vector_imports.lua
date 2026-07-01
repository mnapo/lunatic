local lunatic = require("lunatic")

local function assert_equals(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

local function test_vector_imports()
    local Vector = lunatic.Vector
    assert(type(Vector) == "table", "expected Vector module to be exported from entrypoint")

    local v1 = Vector.new({1, 2, 3})
    local v2 = Vector.new({4, 5, 6})

    local sum = v1 + v2
    assert_equals(sum:get(1), 5, "addition at index 1")
    assert_equals(sum:get(2), 7, "addition at index 2")
    assert_equals(sum:get(3), 9, "addition at index 3")

    local scaled = v1:scale(2)
    assert_equals(scaled:get(1), 2, "scale at index 1")
    assert_equals(scaled:get(2), 4, "scale at index 2")
    assert_equals(scaled:get(3), 6, "scale at index 3")

    local dot = v1:dot(v2)
    assert_equals(dot, 32, "dot product")
end

test_vector_imports()
print("vector imports test passed")
