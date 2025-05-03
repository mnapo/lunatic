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
    self:get("morpheme")
end

function Token:get_morpheme()
    self:get("morpheme")
end

function Token:set_morpheme(new_value)
    self:set("morpheme", new_value)
end

function Token:print()
    print(self:get("morpheme"))
end

return Token