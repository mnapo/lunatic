local Context = {}

Context.enabled = true

function Context.enable()
    Context.enabled = true
end

function Context.disable()
    Context.enabled = false
end

function Context.is_enabled()
    return Context.enabled
end

return Context