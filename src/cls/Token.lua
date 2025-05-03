local Token = ClassPrototype:new()
Token.__index = Token

function Token:new(morpheme)
    local instance = ClassPrototype:new()

    local morpheme = morpheme or ""

    instance:set("morpheme", morpheme)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function Token:get_frequency()
    self:get("frequency")
end

function Token:get_morpheme()
    self:get("morpheme")
end

function Token:set_morpheme(new_value)
    self:set("morpheme", new_value)
end

function Token:set_frequency(new_value)
    self:set("frequency", new_value)
end

function Token:print()
    local morpheme = self:get_morpheme()
    local frequency = self:get_frequency()
    print(morpheme, frequency)
end

return Token