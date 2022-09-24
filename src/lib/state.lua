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
---@param o table|nil
---@return GridColumn
function GridColumn:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---@class Cursor
---@field context CONTEXT
---@field grid_position Param
Cursor = {}
---@return Cursor
function Cursor:new()
    local o = {
        context = CONTEXT.GRID,
        grid_position = Param:new { value = 1, min = 1, max = 4 },
    }
    setmetatable(o, self)
    self.__index = self
    return o
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
    local o = {
        key = { KeyState:new(), KeyState:new(), KeyState:new(), },
        cursor = Cursor:new(),
        grid_columns = {
            GridColumn:new(),
            GridColumn:new(),
            GridColumn:new(),
            GridColumn:new(),
        },
    }
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

---@param n encoders
---@param delta integer
function State:set_value(n, delta)
    local grid_column_id = self.cursor.grid_position.value
    local grid_column = self.grid_columns[grid_column_id]
    if n == 2 then
        if self.cursor.context == CONTEXT.GRID then
            self.cursor.grid_position:add_value(delta)
        elseif self.cursor.context == CONTEXT.CH then
            grid_column.ch:add_value(delta)
        elseif self.cursor.context == CONTEXT.CC then
            grid_column.cc:add_value(delta)
        elseif self.cursor.context == CONTEXT.VALUE then
            grid_column.value:add_value(delta)
        end
    elseif n == 3 then
        grid_column.value:add_value(delta)
    end
end

return State
