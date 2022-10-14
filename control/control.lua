-- scriptname: Grid Controller
-- v1.0.0 @Evgeny Maruschenko/Eugene Maruschin
---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-global
local success, State = pcall(include, 'lib/state')
---@diagnostic enable: undefined-global
if not success then
    print('[INFO] Include: ' .. State)
    State = require 'lib.state'
end

key2_pressed = 1
local UI = require 'ui'
local pages


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

function GridColumn:repr()
    return 'ch: ' .. self.ch.value .. ' cc: ' .. self.cc.value .. ' value: ' .. self.value.value
end

---Init function
function init()
    state = {}
    for i = 1, 16 do state[i] = GridColumn:new() end
    state_repr = {}
    for i = 1, 16 do state_repr[i] = state[i]:repr() end
    list = UI.ScrollingList.new(10, 10, 1, state_repr)
end

---Draw UI
function redraw()
    screen.clear()
    list:set_index(key2_pressed)
    list:redraw()
    screen.update()
    print(key2_pressed)
end

---Norns shield keys.
---@param n integer key number: 1, 2, 3.
---@param z integer key press: 1 - pressed, 0 - unpressed.
function key(n, z)
    local pressed = (z == 1)
    local key1 = n == 1
    local key2 = n == 2
    local key3 = n == 3
    if key2 and pressed then
        key2_pressed = key2_pressed + 1
    end
    if key3 and pressed then
        key2_pressed = key2_pressed - 1
    end
    redraw()
end

---Norns shield encoders.
---@param n integer encoder number: 1, 2, 3.
---@param d delta encoder delta, clockwise is positive, counterclockwise is negative.
function enc(n, d)
end

---Clean up function
function cleanup()
    state = nil
end
