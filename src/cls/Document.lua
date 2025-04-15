local ClassPrototype = require("ClassPrototype")
local DocumentProperty = require("DocumentProperty")
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

function Document:get_property_history(type)
    local temp = {}
    for i = 1, #self:get("properties") do
        local property = self:get("properties")[i]
        if (property.type == type) then
            temp[#temp] = property
        end
    end
    return temp[temp]
end

function Document:get_property(type)
    local history = self:get_property_history(type)
    return history[#history]
end

function Document:set_property(type, value)
    local history = self:get_property_history(type)
    local action = "creation"
    if #history > 0 then
        action = "modification"
    end
    local properties = self:get("properties")
    properties[#properties+1] = DocumentProperty:new(type, value, action)
    self:set("properties", properties)
    return self
end

return Document