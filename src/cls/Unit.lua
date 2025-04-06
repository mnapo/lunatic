local ClassPrototype = require("ClassPrototype")
local Unit = {}

local e = math.exp(1)

local sigmoid = function(z)
    return 1/(1+e^((-1)*z))
end

local tanh = function(z)
    return (e^z-e^((-1)*z))/(e^z+e^((-1)*z))
end

local relu = function(z)
    if z>0 then
        return z
    else
        return 0
    end
end

function Unit.new(network_id)
    Unit.__index = Unit
    setmetatable(Unit, {__index = ClassPrototype})

    local activation_function = ""
    local bias = 0
    local parent_network_id = network_id or 0
    local weight = 0

    local instance = ClassPrototype.new()
        :set("activation_function", activation_function)
        :set("bias", bias)
        :set("parent_network_id", parent_network_id)
        :set("weight", weight)

    return setmetatable(instance, Unit)
end

function Unit:set(member, value)
    if member == "activation_function" then
        if value == "sigmoid" then
            value = sigmoid
        elseif value == "tanh" then
            value = tanh
        elseif value == "relu" then
            value = relu
        end
    end
    self[member] = value
    return self
end

function Unit:get_output(x)
    local weighted_input = x * self:get("weight")
    local biased_input = weighted_input + self:get("bias")
    local activated_input = self:get("activation_function")(biased_input)
    return activated_input
end

return Unit