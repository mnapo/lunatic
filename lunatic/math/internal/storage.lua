local Storage = {}
Storage.__index = Storage

--
-- Constructor
--

function Storage.new(data)
    assert(type(data) == "table", "Storage.new(): data must be table")

    local self = setmetatable({}, Storage)

    self.data = data
    self.size = #data

    return self
end

--
-- Access
--

function Storage:get(i)
    return self.data[i]
end

function Storage:set(i, value)
    self.data[i] = value
end

--
-- Clone (shallow copy)
--

function Storage:clone()
    local out = {}

    for i = 1, self.size do
        out[i] = self.data[i]
    end

    return Storage.new(out)
end

--
-- Raw data access
--

function Storage:raw()
    return self.data
end

return Storage