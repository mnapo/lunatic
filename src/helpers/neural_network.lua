local M = {}

M.sigmoid = function(x)
    return 1/(1+E^((-1)*x))
end

M.tanh = function(x)
    return (math.exp(x)-math.exp((-1)*x))/(math.exp(x)+math.exp((-1)*x))
end

M.relu = function(x)
    if x>0 then
        return x
    else
        return 0
    end
end

M.perceptron = function(x)
    if x>0 then
        return 1
    else
        return 0
    end
end

return M