local ClassPrototype = {}
ClassPrototype.__index = ClassPrototype

function ClassPrototype.new()
    ClassPrototype.__index = ClassPrototype
    local instance = {}
    return setmetatable(instance, ClassPrototype)
end

function ClassPrototype:get(member)
    return self[member]
end

function ClassPrototype:set(member, value)
    self[member] = value
    return self
end

function ClassPrototype:remove(member, value)
    self = nil
end

return ClassPrototype