local ClassPrototype = {}
ClassPrototype.__index = ClassPrototype

function ClassPrototype:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    return instance
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