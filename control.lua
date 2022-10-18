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
local success, UI = pcall(require, 'ui')
if not success then
    UI = require 'mock.ui'
    screen = require 'mock.screen'
end

---Init function
function init()
    state = State:new()
end


function draw_column(x, y, row_num, column, active)
    local level = active and 15 or 7
    screen.level(level)
    screen.move(x, y)
    screen.text(row_num)
    draw_line(x + 8, y-8, x + 8, y, level)
    screen.move(x + 12, y)
    screen.text("ch: " .. column["ch"].value)
    screen.move(x + 37, y)
    screen.text("cc: " .. column["cc"].value)
    screen.move(x + 62, y)
    screen.text("value: " .. column["value"].value)
    screen.level(15)
end

function draw_line(x1, y1, x2, y2, level)
    screen.level(level)
    screen.line_width(1)
    screen.move(x1, y1)
    screen.line(x2, y2)
    screen.close()
    screen.stroke()
end

---Draw UI
function redraw()
    local active_row_id = state.cursor.grid_position.value
    screen.clear()
    screen.aa(0)
    screen.blend_mode(2)
    --draw_line(13, 0, 13, 64, 7)
    for row_id, column in ipairs(state.grid_columns) do
      draw_column(5, (8*row_id - 2), row_id, column, row_id == active_row_id)
      
    end
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
