local ClassPrototype = require("ClassPrototype")
local PropertyRecord = ClassPrototype:new()
PropertyRecord.__index = PropertyRecord

local DOCUMENT_PROPERTY_TYPES = {
    "action",
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

function PropertyRecord:new(parent_id, type, value)
    local instance = ClassPrototype:new()

    instance:set("parent_id", parent_id)
    :set("date", os.date())
    :set("type", type)
    :set("value", value)

    instance = setmetatable(instance, self)
    instance.__index = self
    return instance
end

return PropertyRecord