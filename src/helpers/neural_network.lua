local M = {}

local ERROR_ACTIVATION_FUNCTION = "Error, the activation function doesn't exist"

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

M.get_activation_function = function(function_name)
    if function_name == "sigmoid" then
        return M.sigmoid
    elseif function_name == "tanh" then
        return M.tanh
    elseif function_name == "relu" then
        return M.relu
    elseif function_name == "perceptron" then
        return M.perceptron
    else
        error(ERROR_ACTIVATION_FUNCTION)
    end
end

return M