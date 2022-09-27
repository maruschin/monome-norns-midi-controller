require 'control'

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
    LU.assertEquals(state.cursor.context, CONTEXT.GRID)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.CH)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.CC)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.VALUE)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.VALUE)
    state:change_context(2, true)
    LU.assertEquals(state.cursor.context, CONTEXT.CC)
    state:change_context(2, true)
    LU.assertEquals(state.cursor.context, CONTEXT.CH)
    state:change_context(2, true)
    LU.assertEquals(state.cursor.context, CONTEXT.GRID)
    state:change_context(2, true)
    LU.assertEquals(state.cursor.context, CONTEXT.GRID)
end

function TestState:test_change_grid_position()
    local state = State:new()
    LU.assertEquals(state.cursor.context, CONTEXT.GRID)
    LU.assertEquals(state.cursor.grid_position.value, 1)
    state:set_value(2, 3)
    LU.assertEquals(state.cursor.grid_position.value, 4)
    state:set_value(2, 1)
    LU.assertEquals(state.cursor.grid_position.value, 4)
    state:set_value(2, -3)
    LU.assertEquals(state.cursor.grid_position.value, 1)
    state:set_value(2, -1)
    LU.assertEquals(state.cursor.grid_position.value, 1)
end

function TestState:test_change_channel()
    local state = State:new()
    local grid_column_param = state.grid_columns[1].ch
    local min_value = 1
    local max_value = 16
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.CH)
    LU.assertEquals(grid_column_param.value, min_value)
    state:set_value(2, (max_value - min_value))
    LU.assertEquals(grid_column_param.value, max_value)
    state:set_value(2, 1)
    LU.assertEquals(grid_column_param.value, max_value)
    state:set_value(2, -(max_value - min_value))
    LU.assertEquals(grid_column_param.value, min_value)
    state:set_value(2, -1)
    LU.assertEquals(grid_column_param.value, min_value)
end

function TestState:test_change_command_change()
    local state = State:new()
    local grid_column_param = state.grid_columns[1].cc
    local min_value = 0
    local max_value = 119
    state:change_context(3, true)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.CC)
    LU.assertEquals(grid_column_param.value, min_value)
    state:set_value(2, (max_value - min_value))
    LU.assertEquals(grid_column_param.value, max_value)
    state:set_value(2, 1)
    LU.assertEquals(grid_column_param.value, max_value)
    state:set_value(2, -(max_value - min_value))
    LU.assertEquals(grid_column_param.value, min_value)
    state:set_value(2, -1)
    LU.assertEquals(grid_column_param.value, min_value)
end

function TestState:test_change_value()
    local state = State:new()
    local grid_column_param = state.grid_columns[1].value
    local min_value = 0
    local max_value = 127
    state:change_context(3, true)
    state:change_context(3, true)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.VALUE)
    LU.assertEquals(grid_column_param.value, min_value)
    state:set_value(2, (max_value - min_value))
    LU.assertEquals(grid_column_param.value, max_value)
    state:set_value(2, 1)
    LU.assertEquals(grid_column_param.value, max_value)
    state:set_value(2, -(max_value - min_value))
    LU.assertEquals(grid_column_param.value, min_value)
    state:set_value(2, -1)
    LU.assertEquals(grid_column_param.value, min_value)
end

function TestState:test_change_value_knob_3()
    local state = State:new()
    local grid_column_param = state.grid_columns[1].value
    local min_value = 0
    local max_value = 127
    LU.assertEquals(state.cursor.context, CONTEXT.GRID)
    LU.assertEquals(grid_column_param.value, min_value)
    state:set_value(3, (max_value - min_value))
    LU.assertEquals(grid_column_param.value, max_value)
    state:set_value(3, 1)
    LU.assertEquals(grid_column_param.value, max_value)
    state:set_value(3, -(max_value - min_value))
    LU.assertEquals(grid_column_param.value, min_value)
    state:set_value(3, -1)
    LU.assertEquals(grid_column_param.value, min_value)
end

function TestState:test_mixed_change()
    local state = State:new()
    LU.assertEquals(state.cursor.context, CONTEXT.GRID)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.CH)
    state:set_value(2, 7)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.CC)
    state:set_value(2, 35)
    state:change_context(3, true)
    LU.assertEquals(state.cursor.context, CONTEXT.VALUE)
    state:set_value(2, 75)

    LU.assertEquals(state.grid_columns[2].ch.value, 8)
    LU.assertEquals(state.grid_columns[2].cc.value, 35)
    LU.assertEquals(state.grid_columns[2].value.value, 75)
end
