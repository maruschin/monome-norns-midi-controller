--[[
    Тут какое-то описание 
]]

require("src/state")

local function init()
    -- Стейт контроллера
    CState = State:new();
end

--[[
    Norns shield keys.

    n: {1,2,3} - key number.
    z: {1,0} - key press {down,up}.
]]
local function key(n, z)
    CState:set_key_pressed(n, z)
    print(n, CState.key[n].pressed)
end

--[[
    Norns shield encoders.

    n: {1,2,3} - encoder number.
    d: integer - encoder delta, clockwise is positive, counterclockwise is negative.
]]
local function enc(n, d)
    CState:set_enc_value(n, d)
    print(n, CState.enc[n].value)
end

init()
print(key(3, 1))
print(key(3, 0))
print(key(2, 1))
print(key(2, 0))

print(enc(3, 1))
print(enc(3, 3))
print(enc(2, 1))
print(enc(2, 2))
