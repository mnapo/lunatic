Tensor = require("lunatic.math.tensor")

local function test_scalar_expansion()
    local a = Tensor.new({1}, {1})
    local b = Tensor.new({10, 20, 30}, {3})

    local c = a + b

    print("Scalar Expansion Test:")
    print("A shape:", table.concat(a.shape, ","))
    print("B shape:", table.concat(b.shape, ","))
    print("C shape:", table.concat(c.shape, ","))

    print("C values:")
    for i = 1, #c do
        print(i, c:get(i))
    end
    print("------------------------------")
end

local function test_vector_matrix_addition()
    local a = Tensor.new({1,2,3}, {3})
    local b = Tensor.new({
        10, 20, 30,
        40, 50, 60
    }, {2,3})

    local c = a + b

    print("A:", a)
    print("B:", b)
    print("C:", c)

    for i = 1, #c do
        print("C["..i.."] =", c:get(i))
    end
end

test_scalar_expansion()
test_vector_matrix_addition()