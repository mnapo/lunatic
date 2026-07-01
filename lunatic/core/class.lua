local function Class(base)
    local cls = {}
    cls.__index = cls
    cls.__base = base

    setmetatable(cls, {
        __index = base,
        __call = function(self, ...)
            return self:new(...)
        end
    })

    function cls:new(...)
        local instance = setmetatable({}, self)

        if instance.init then
            instance:init(...)
        end

        return instance
    end

    return cls
end

return Class