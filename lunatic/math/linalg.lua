local linalg = {}

function linalg.dot(a, b)
    assert(a.size == b.size, "dot(): size mismatch")

    local s = 0
    for i = 1, a.size do
        s = s + a.data[i] * b.data[i]
    end

    return s
end

function linalg.norm(t)
    local s = 0
    for i = 1, t.size do
        s = s + t.data[i] * t.data[i]
    end
    return math.sqrt(s)
end

function linalg.matmul(a, b)
    assert(#a.shape == 2 and #b.shape == 2,
        "matmul(): requires 2D tensors")

    assert(a.shape[2] == b.shape[1],
        "matmul(): shape mismatch")

    local rows = a.shape[1]
    local cols = b.shape[2]
    local inner = a.shape[2]

    local data = {}

    for i = 1, rows do
        for j = 1, cols do
            local sum = 0
            for k = 1, inner do
                sum = sum + a.data[(i-1)*inner + k] *
                            b.data[(k-1)*cols + j]
            end
            data[(i-1)*cols + j] = sum
        end
    end

    return require("lunatic.math.tensor").new(data, {rows, cols})
end

return linalg