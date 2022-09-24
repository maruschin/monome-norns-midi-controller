---@diagnostic disable: lowercase-global

require 'src.state'

function init()
    State = State:new();
end

---Draw UI
---@param state State
function draw(state)
end

---Norns shield keys.
---@param n integer key number: 1, 2, 3.
---@param z integer key press: 1 - pressed, 0 - unpressed.
function key(n, z)
    State:set_key_pressed(n, (z == 1))
    draw(State)
end

---Norns shield encoders.
---@param n integer encoder number: 1, 2, 3.
---@param d delta encoder delta, clockwise is positive, counterclockwise is negative.
function enc(n, d)
    State:set_enc_value(n, d)
    draw(State)
end
