local ClassPrototype = require("ClassPrototype")
local ErrorsHandler = ClassPrototype:new()
ErrorsHandler.__index = ErrorsHandler
local exit = os.exit

local MODES = {
    "verbose",
    "silent"
}
local ERROR_CODES = {
    "Table expected, got ",
    "R_Vector must be filled with real numbers!",
    "Layer type is wrong",
    "There isn't a next layer defined",
    "Unit expected",
    "Wrong layer id",
    "Layer expected",
    "Id number needs to be a positive integer",
    "Can't set reserved morpheme",
    "There's not enough tokens to sort (there should be two at least)",
    "Activation function doesn't exist",
    "It can only be calculated the dot product/vectorial sum between two real numbers vectors",
    "Dot product between two vectors can't be calculated if they're of different dimensions",
    "Can't operate between these objects"
    
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

function ErrorsHandler:explain(error_code, additional_info)
    print(ERROR_CODES[error_code])
    self:stop_program()
end

function ErrorsHandler.intercept(error)
    if SINGLETON_ERRORS_HANDLER:get("mode") == "verbose" then
        print(LIBRARY_ERROR_HEADER)
        ErrorsHandler:explain(error)
    end
end

return ErrorsHandler