---@alias keys
---| 1 # K1, кноб над экраном.
---| 2 # K2, кноб справа от экрана.
---| 3 # K3, кноб справа от экрана, правее K2.

---@alias encoders
---| 1 # E1, энкодер над экраном.
---| 2 # E2, энкодер справа от экрана.
---| 3 # E3, энкодер справа от экрана, правее E2.

---@alias delta integer Encoder delta, clockwise is positive, counterclockwise is negative.

---@enum CONTEXT cursor context.
CONTEXT = {
    GRID = 'grid',
    CH = 'ch',
    CC = 'cc',
    VALUE = 'value',
}

---Class for save pressed key state.
---@class KeyState
---@field pressed boolean
KeyState = {}
---@param o table|nil
---@return KeyState
function KeyState:new(o)
    o = o or { pressed = false }
    setmetatable(o, self)
    self.__index = self
    return o
end

---Save param value and settings.
---@class Param
---@field value integer value of param.
---@field min integer min of param value.
---@field max integer max of param value.
Param = {}
---@param o table|nil
---@return Param
function Param:new(o)
    o = o or { value = 0, min = 0, max = 127 }
    setmetatable(o, self)
    self.__index = self
    return o
end

---Установить новое значение параметра
---@param value integer
function Param:set(value)
    self.value = math.min(math.max(self.min, value), self.max)
end

---Добавить значение параметра
---@param delta delta
function Param:add(delta)
    self:set(self.value + delta)
end

---@class GridColumn
---@field ch Param midi channel 1-16.
---@field cc Param midi control change 0-119.
---@field value Param midi control change value 0-127.
GridColumn = {}
---@param o table|nil
---@return GridColumn
function GridColumn:new(o)
    o = {
        ch = Param:new { value = 1, min = 1, max = 16 },
        cc = Param:new { value = 0, min = 0, max = 119 },
        value = Param:new { value = 0, min = 0, max = 127 },
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---@class Cursor
---@field context CONTEXT
---@field grid_position Param
Cursor = {}
---@return Cursor
---@param columns_number integer
function Cursor:new(columns_number)
    local o = {
        context = CONTEXT.GRID,
        grid_position = Param:new { value = 1, min = 1, max = columns_number },
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Cursor:round_context()
    if self.context == CONTEXT.GRID then
        self.context = CONTEXT.CH
    elseif self.context == CONTEXT.CH then
        self.context = CONTEXT.CC
    elseif self.context == CONTEXT.CC then
        self.context = CONTEXT.VALUE
    elseif self.context == CONTEXT.VALUE then
        self.context = CONTEXT.GRID
    end
end

function Cursor:up_context()
    if self.context == CONTEXT.GRID then
        self.context = CONTEXT.CH
    elseif self.context == CONTEXT.CH then
        self.context = CONTEXT.CC
    elseif self.context == CONTEXT.CC then
        self.context = CONTEXT.VALUE
    end
end

function Cursor:down_context()
    if self.context == CONTEXT.CH then
        self.context = CONTEXT.GRID
    elseif self.context == CONTEXT.CC then
        self.context = CONTEXT.CH
    elseif self.context == CONTEXT.VALUE then
        self.context = CONTEXT.CC
    end
end

---@class State
---@field key table<keys, KeyState> state of keys.
---@field cursor Cursor
---@field grid_columns table<integer, GridColumn> column of grid.
State = {}
---@return State
function State:new()
    local columns_number = 16
    local o = {
        key = { KeyState:new(), KeyState:new(), KeyState:new(), },
        cursor = Cursor:new(columns_number),
        grid_columns = {},
    }
    for i = 1, columns_number do
        o.grid_columns[i] = GridColumn:new()
    end

    setmetatable(o, self)
    self.__index = self
    return o
end

---@param n keys
---@param pressed boolean
function State:set_key_pressed(n, pressed)
    self.key[n].pressed = pressed
end

---@param n keys
---@param pressed boolean
function State:change_context(n, pressed)
    if pressed then
        if n == 2 then
            self.cursor:down_context()
        elseif n == 3 then
            self.cursor:up_context()
        end
    end
end

---Return active grid column.
---@return GridColumn
function State:get_active_column()
    return self.grid_columns[self.cursor.grid_position.value]
end

---@param delta integer
function State:set_value_by_context(delta)
    local grid_column = self:get_active_column()
    if self.cursor.context == CONTEXT.GRID then
        self.cursor.grid_position:add(delta)
    elseif self.cursor.context == CONTEXT.CH then
        grid_column.ch:add(delta)
    elseif self.cursor.context == CONTEXT.CC then
        grid_column.cc:add(delta)
    elseif self.cursor.context == CONTEXT.VALUE then
        grid_column.value:add(delta)
    end
end

return State
