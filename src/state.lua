State = {
    key = { { pressed = false }, { pressed = false }, { pressed = false }, },
    enc = { { value = 0 }, { value = 0 }, { value = 0 } },
}

function State:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function State:set_key_pressed(n, z)
    self.key[n].pressed = (z == 1)
end

function State:set_enc_value(n, d)
    self.enc[n].value = self.enc[n].value + d
end
