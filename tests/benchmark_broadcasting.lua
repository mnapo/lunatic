-- Simple benchmark harness for elementwise and broadcasting ops
local Tensor = require("lunatic.math.tensor")

local function rand_table(n)
    local t = {}
    for i = 1, n do t[i] = math.random() end
    return t
end

local function bench(name, fn, iter)
    iter = iter or 5
    collectgarbage(); collectgarbage()
    local t0 = os.clock()
    for i = 1, iter do fn() end
    local t1 = os.clock()
    print(string.format("%-30s : %0.6f sec (avg %0.6f)", name, t1 - t0, (t1 - t0) / iter))
end

math.randomseed(os.time())

local sizes = {1000, 10000, 100000}

print("Benchmarking elementwise and broadcasting ops")
for _, n in ipairs(sizes) do
    print("\nSize:", n)

    local a_data = rand_table(n)
    local b_data = rand_table(n)

    local a = Tensor.new(a_data, {n})
    local b = Tensor.new(b_data, {n})
    local scalar = Tensor.new({2}, {1})

    bench(string.format("add same-shape [%d]", n), function()
        local c = a + b
    end, 10)

    bench(string.format("mul same-shape [%d]", n), function()
        local c = a:mul(b)
    end, 10)

    bench(string.format("scale scalar [%d]", n), function()
        local c = a:scale(2)
    end, 10)

    bench(string.format("broadcast scalar->vector [%d]", n), function()
        local c = scalar + a
    end, 10)

    -- 2D broadcasting: vector + matrix (rows = 10)
    local rows = 10
    local cols = n / rows
    if cols >= 1 and math.floor(cols) == cols then
        local m_data = rand_table(n)
        local v_data = rand_table(cols)
        local m = Tensor.new(m_data, {rows, cols})
        local v = Tensor.new(v_data, {cols})

        bench(string.format("vector + matrix [%dx%d]", rows, cols), function()
            local c = v + m
        end, 10)
    end
end

print('\nBenchmark complete')
