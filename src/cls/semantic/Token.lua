local ClassPrototype = require("ClassPrototype")
local Token = ClassPrototype:new()
Token.__index = Token

local ERROR_RESERVED_MORPHEME = "Can't set reserved morpheme "
local RESERVED_MORPHEME_DELETE = "DELETE"

function Token:new(morpheme)
    local instance = ClassPrototype:new()

    local morpheme = morpheme or ""

    instance:set("morpheme", morpheme)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function Token:get_morpheme()
    return self:get("morpheme")
end

function Token:set_morpheme(new_value)
    if (new_value == RESERVED_MORPHEME_DELETE) then
        return error(ERROR_RESERVED_MORPHEME.." "..RESERVED_MORPHEME_DELETE)
    end
    return self:set("morpheme", new_value)
end

function Token:set_to_discard()
    return self:set("morpheme", RESERVED_MORPHEME_DELETE)
end

function Token:print()
    local morpheme = self:get_morpheme()
    print('\t\t"'..morpheme..'"')
end

return Token