local ClassPrototype = require("ClassPrototype")
local DocumentProperty = ClassPrototype:new()
DocumentProperty.__index = DocumentProperty

local DOCUMENT_PROPERTY_TYPES = {
    "annotations",
    "code_switching",
    "collection_process",
    "distribution",
    "demographics",
    "historical_data",
    "languages",
    "motivation",
    "situation"
}

local DOCUMENT_PROPERTY_ACTIONS = {
    "creation",
    "modification"
}

function DocumentProperty:new(type, value, action)
    local instance = ClassPrototype:new()

    local action = action or "creation"

    instance:set("date", os.date())
    :set("type", type)
    :set("value", value)
    :set("action", "creation")

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

return DocumentProperty