local ClassPrototype = require("ClassPrototype")
local PropertyRecord = require("PropertyRecord")
local Document = ClassPrototype:new()
Document.__index = Document

function Document:new(source)
    local instance = ClassPrototype:new()

    instance:set("source", source)
    :set("properties", {})

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

function Document:get_property(type)
end

function Document:set_property(type, value)

end

return Document