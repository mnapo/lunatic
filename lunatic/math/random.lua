local Random = {}
Random.__index = Random

function Random.new(seed)
    local self = setmetatable({}, Random)

    self.seed = seed or os.time()
    self.state = self.seed

    return self
end

function Random:next()
    -- Linear congruential generator (simple & stable)
    self.state = (1664525 * self.state + 1013904223) % 2^32
    return self.state / 2^32
end

function Random:uniform(a, b)
    a = a or 0
    b = b or 1
    return a + (b - a) * self:next()
end

function Random:normal()
    -- Box-Muller (basic version)
    local u1 = self:next()
    local u2 = self:next()

    local z0 = math.sqrt(-2 * math.log(u1 + 1e-10)) *
               math.cos(2 * math.pi * u2)

    return z0
end

return Random