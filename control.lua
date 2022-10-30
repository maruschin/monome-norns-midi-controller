-- scriptname: Grid Controller
-- v1.0.0
-- Eugene Maruschin
-- Sasha DZA
--
--
--
--
---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-global
local success, State = pcall(include, 'lib/state')
---@diagnostic enable: undefined-global
if not success then
    print('[INFO] Include: ' .. State)
    State = require 'lib.state'
end


local success, UI = pcall(require, 'ui')
if not success then
    UI = require 'mock.ui'
    screen = require 'mock.screen'
end


---@type State
local state


---Init function
function init()
    state = State:new()
    g = grid.connect()
end

---Draw line.
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@param level integer
function draw_line(x1, y1, x2, y2, level)
    screen.level(level)
    screen.line_width(1)
    screen.move(x1, y1)
    screen.line(x2, y2)
    screen.close()
    screen.stroke()
end

---Draw text.
---@param x integer
---@param y integer
---@param text string|integer
---@param level integer
function draw_text(x, y, text, level)
    screen.level(level)
    screen.move(x, y)
    screen.text(text)
end

---Draw screen row.
---@param x integer
---@param y integer
---@param row_num integer Row number.
---@param column GridColumn Grid column.
---@param active boolean
function draw_row(x, y, row_num, column, active)
    local level = active and 16 or 8
    draw_text(x, y, row_num, level)
    draw_line(x + 12, y - 8, x + 12, y, level)
    draw_text(x + 16, y, 'ch: ' .. column['ch'].value, level)
    draw_text(x + 44, y, 'cc: ' .. column['cc'].value, level)
    draw_text(x + 76, y, 'value: ' .. column['value'].value, level)
end

---Draw UI
function redraw()
    local active_row_id = state.cursor.grid_position.value

    local row_id_for_scroll = 4
    local row_shift = (
        (active_row_id < row_id_for_scroll) and 0
            or (active_row_id >= (16 - row_id_for_scroll)) and 8
            or (active_row_id - row_id_for_scroll)
        )

    screen.clear()
    screen.aa(0)
    screen.blend_mode(2)

    for row_id, column in ipairs(state.grid_columns) do
        draw_row(4, (8 * (row_id - row_shift) - 2), row_id, column, row_id == active_row_id)
    end

    screen.update()
end

m = midi.connect()
---Send MIDI CC
function send_midi_cc()
    for _, column in ipairs(state.grid_columns) do
        m:cc(column.cc.value, column.value.value, column.ch.value)
    end
end

g = grid.connect()
---Norns grid key hook.
---@param x integer
---@param y integer
---@param z integer key press: 1 - pressed, 0 - unpressed.
function g.key(x, y, z)
    local pressed = not (z == 0)
    if pressed then
        value = (8 - y) * 18
        state.grid_columns[x].value:set(value)

        for i = 8, 1, -1 do
            --g:led(x, i, (i > y) and 4 or (i == y) and 15 or 0)
            g:led(x, i, math.min((i >= y) and x or 0, 15))
        end
    end
    g:refresh()
    send_midi_cc()
    redraw()
end

---Norns shield keys.
---@param n integer key number: 1, 2, 3.
---@param z integer key press: 1 - pressed, 0 - unpressed.
function key(n, z)
    local pressed = not (z == 0)
    local key1, key2, key3 = (n == 1), (n == 2), (n == 3)
    if key1 and pressed then state.cursor:round_context() end
    if key2 and pressed then state.cursor.grid_position:add(1) end
    if key3 and pressed then state.cursor.grid_position:add(-1) end
    send_midi_cc()
    redraw()
end

---Norns shield encoders.
---@param n integer encoder number: 1, 2, 3.
---@param delta delta encoder delta, clockwise is positive, counterclockwise is negative.
function enc(n, delta)
    local enc1, enc2, enc3 = (n == 1), (n == 2), (n == 3)
    local column = state:get_active_column()
    if enc1 then column.ch:add(delta) end
    if enc2 then column.cc:add(delta) end
    if enc3 then column.value:add(delta) end
    send_midi_cc()
    redraw()
end

---Clean up function.
function cleanup()
    state = nil
end
