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

---Init function
function init()
    state = State:new();
end

---Draw UI
---@param state State
function draw(state)
end

---Norns shield keys.
---@param n integer key number: 1, 2, 3.
---@param z integer key press: 1 - pressed, 0 - unpressed.
function key(n, z)
    local pressed = (z == 1)
    state:set_key_pressed(n, pressed)
    state:change_context(n, pressed)
    draw(state)
end

---Norns shield encoders.
---@param n integer encoder number: 1, 2, 3.
---@param d delta encoder delta, clockwise is positive, counterclockwise is negative.
function enc(n, d)
    draw(state)
end
