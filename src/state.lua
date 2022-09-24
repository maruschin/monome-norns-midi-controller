---@alias keys
---| 1 # K1, кноб над экраном.
---| 2 # K2, кноб справа от экрана.
---| 3 # K3, кноб справа от экрана, правее K2.

---@alias encoders
---| 1 # E1, энкодер над экраном.
---| 2 # E2, энкодер справа от экрана.
---| 3 # E3, энкодер справа от экрана, правее E2.

---@alias delta integer Encoder delta, clockwise is positive, counterclockwise is negative.

---@class KeyState
KeyState = { pressed = false }
---@return KeyState
function KeyState:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---@class Param
Param = { value = 0, min = 0, max = 127 }
---@return Param
function Param:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---Установить новое значение параметра
---@param delta delta
function Param:add_value(delta)
    local value = self.value + delta
    self.value = math.min(math.max(self.min, value), self.max)
end

---@class GridColumn
---@field ch Param midi channel 1-16.
---@field cc Param midi control change 0-119.
---@field value Param midi control change value 0-127.
GridColumn = {
    ch = Param:new { value = 1, min = 1, max = 16 },
    cc = Param:new { value = 0, min = 0, max = 119 },
    value = Param:new { value = 0, min = 0, max = 127 },
}
---@return GridColumn
function GridColumn:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---@class State
---@field key table<keys, KeyState> state of keys.
---@field grid_columns table<integer, table> column of grid.
State = {
    key = { KeyState:new(), KeyState:new(), KeyState:new(), },
    grid_columns = {
        GridColumn:new(),
        GridColumn:new(),
        GridColumn:new(),
        GridColumn:new(),
    },
}
---@return State
function State:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---@param n keys
---@param z boolean
function State:set_key_pressed(n, z)
    self.key[n].pressed = z
end

---@param n encoders
---@param d delta
function State:set_enc_value(n, d)
    self.enc[n]:add_value(d)
end
