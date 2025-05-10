local ClassPrototype = require("ClassPrototype")
local ErrorsHandler = ClassPrototype:new()
ErrorsHandler.__index = ErrorsHandler
local exit = os.exit
local MODES = {
    "verbose",
    "silent"
}
local LIBRARY_ERROR_HEADER = "### LIBRARY ERROR ###"
local SINGLETON_ERRORS_HANDLER = ClassPrototype:new()

function ErrorsHandler:new(mode)
    local mode = mode or MODES[1]
    SINGLETON_ERRORS_HANDLER:set("mode", mode)

    SINGLETON_ERRORS_HANDLER = setmetatable(SINGLETON_ERRORS_HANDLER, self)
    SINGLETON_ERRORS_HANDLER.__index = self
    return SINGLETON_ERRORS_HANDLER
end

function ErrorsHandler:stop_program()
    exit()
end

function ErrorsHandler:explain(error)
    print(error)
    self:stop_program()
end

function ErrorsHandler.intercept(error)
    if SINGLETON_ERRORS_HANDLER:get("mode") == "verbose" then
        print(LIBRARY_ERROR_HEADER)
        ErrorsHandler:explain(error)
    end
end

return ErrorsHandler