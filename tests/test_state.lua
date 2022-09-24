require 'src.main'

TestParam = {}
function TestParam:test_add_value()
    local min_value = 0
    local max_value = 128
    local param = Param:new { value = min_value, min = 0, max = max_value }
    LU.assertEquals(param.value, min_value)
    param:add_value(64)
    LU.assertEquals(param.value, 64)
    param:add_value(64)
    LU.assertEquals(param.value, 128)
    param:add_value(64)
    LU.assertEquals(param.value, max_value)
    param:add_value(64)
    LU.assertEquals(param.value, max_value)
    param:add_value(-64)
    LU.assertEquals(param.value, 64)
    param:add_value(-64)
    LU.assertEquals(param.value, min_value)
    param:add_value(-64)
    LU.assertEquals(param.value, min_value)
end

TestState = {}
function TestState:test_change_context()
    local state = State:new()
    LU.assertEquals(state.cursor.context, CONTEXT.grid)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.ch)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.cc)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.value)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.value)
    state:change_context(2, true)
    LU.assertEquals(state.cursor.context, CONTEXT.cc)
    state:change_context(2, true)
    LU.assertEquals(state.cursor.context, CONTEXT.ch)
    state:change_context(2, true)
    LU.assertEquals(state.cursor.context, CONTEXT.grid)
    state:change_context(2, true)
    LU.assertEquals(state.cursor.context, CONTEXT.grid)
end
