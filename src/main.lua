--[[
    Тут какое-то описание 
]]

local function init()
    -- Стейт контроллера
    State = {
        key = { { pressed = false }, { pressed = false }, { pressed = false }, },
        enc = { { value = 0 }, { value = 0 }, { value = 0 } },
    }
end

local function set_key_pressed_state(n, z)
    State.key[n].pressed = (z == 1)
end

local function set_enc_value_state(n, d)
    State.enc[n].value = State.enc[n].value + d
end

--[[
    Norns shield keys.

    n: {1,2,3} - key number.
    z: {1,0} - key press {down,up}.
]]
local function key(n, z)
    set_key_pressed_state(n, z)
    print(n, State.key[n].pressed)
end

--[[
    Norns shield encoders.

    n: {1,2,3} - encoder number.
    d: integer - encoder delta, clockwise is positive, counterclockwise is negative.
]]
local function enc(n, d)
    set_enc_value_state(n, d)
    print(n, State.enc[n].value)
end

init()
print(State)
print(key(3, 1))
print(key(3, 0))
print(key(2, 1))
print(key(2, 0))

print(enc(3, 1))
print(enc(3, 3))
print(enc(2, 1))
print(enc(2, 2))
