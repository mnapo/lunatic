local statistics = {}

function statistics.sum(tensor)
    local s = 0
    for i = 1, tensor.size do
        s = s + tensor.data[i]
    end
    return s
end

function statistics.mean(tensor)
    return statistics.sum(tensor) / tensor.size
end

function statistics.variance(tensor)
    local mean = statistics.mean(tensor)
    local acc = 0

    for i = 1, tensor.size do
        local d = tensor.data[i] - mean
        acc = acc + d * d
    end

    return acc / tensor.size
end

function statistics.std(tensor)
    return math.sqrt(statistics.variance(tensor))
end

return statistics