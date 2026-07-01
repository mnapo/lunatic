local lunatic = require("lunatic")
local mathpkg = lunatic.math

local function assert_equals(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

local function assert_almost_equals(actual, expected, message, epsilon)
    epsilon = epsilon or 1e-10
    assert(math.abs(actual - expected) < epsilon, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

local function test_linalg()
    local Tensor = require("lunatic.math.tensor")
    local linalg = mathpkg.linalg

    assert(type(linalg) == "table", "expected linalg module to be exported from math package")

    local a = Tensor.new({1, 2, 3, 4}, {2, 2})
    local b = Tensor.new({5, 6, 7, 8}, {2, 2})

    assert_equals(linalg.dot(a, b), 70, "dot product")
    assert_almost_equals(linalg.norm(a), 5.47722557505166, "vector norm")

    local c = Tensor.new({1, 2, 3, 4, 5, 6}, {2, 3})
    local d = Tensor.new({7, 8, 9, 10, 11, 12}, {3, 2})
    local product = linalg.matmul(c, d)

    assert_equals(product.shape[1], 2, "matmul rows")
    assert_equals(product.shape[2], 2, "matmul cols")
    assert_equals(product:get(1), 58, "matmul element [1]")
    assert_equals(product:get(4), 154, "matmul element [4]")
end

local function test_statistics()
    local Tensor = require("lunatic.math.tensor")
    local statistics = mathpkg.statistics

    assert(type(statistics) == "table", "expected statistics module to be exported from math package")

    local t = Tensor.new({1, 2, 3, 4}, {4})

    assert_equals(statistics.sum(t), 10, "sum")
    assert_almost_equals(statistics.mean(t), 2.5, "mean")
    assert_almost_equals(statistics.variance(t), 1.25, "variance")
    assert_almost_equals(statistics.std(t), 1.11803398874989, "std")
end

local function test_random()
    local Random = mathpkg.random

    assert(type(Random) == "table", "expected random module to be exported from math package")

    local rng1 = Random.new(123)
    local rng2 = Random.new(123)

    assert_almost_equals(rng1:next(), rng2:next(), "same seed yields same first sample")
    assert(rng1:uniform(0, 1) >= 0 and rng1:uniform(0, 1) <= 1, "uniform returns value in range")
    local normal = rng1:normal()
    assert(type(normal) == "number", "normal returns a number")
end

test_linalg()
test_statistics()
test_random()
print("math modules tests passed")
