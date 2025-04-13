local M = {}

M.sigmoid = function(z)
    return 1/(1+E^((-1)*z))
end

M.tanh = function(z)
    return (math.exp(z)-math.exp((-1)*z))/(math.exp(z)+math.exp((-1)*z))
end

M.relu = function(z)
    if z>0 then
        return z
    else
        return 0
    end
end

M.perceptron = function(z)
    if z>0 then
        return 1
    else
        return 0
    end
end

return M