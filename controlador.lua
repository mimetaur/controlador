-- controlador
-- manual midi controller

local note_num = 60
local note_vel = 100
local note_ch = 1

function init()
end

function enc(n, d)
    redraw()
end

function key(n, z)
    redraw()
end

function redraw()
    screen.clear()

    screen.move(16, 16)
    local note_text = "NOTE  " .. note_num
    screen.text(note_text)
    screen.move(60, 16)
    local vel_text = "VEL  " .. note_vel
    screen.text(vel_text)

    screen.move(16, 44)
    local cc_num_text = "CTRL  " .. cc_num
    screen.text(cc_num_text)
    screen.move(60, 44)
    local cc_val_text = "VAL  " .. cc_val
    screen.text(cc_val_text)

    screen.update()
end
