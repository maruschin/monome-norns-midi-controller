require 'src.main'

TestKeys = {}

function TestKeys:test_key_is_pressed()
    local state = State:new()
    for _key, _value in ipairs(state.key) do
        key(_key, 1)
        LU.assertTrue(_value.pressed)
    end
end

function TestKeys:test_key_is_not_pressed()
    local state = State:new()
    for _key, _value in ipairs(state.key) do
        key(_key, 0)
        LU.assertFalse(_value.pressed)
    end
end
