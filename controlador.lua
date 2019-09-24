-- controlador
-- manual midi controller

-- KEY2 holds down a note
-- ENC2 controls a CC controller

-- set up velocity, channels, etc
-- in the params menu

local is_note_on = false
local midi_out

function init()
    midi_out = midi.connect()
    params:add {
        type = "number",
        id = "note_channel",
        name = "note channel",
        min = 1,
        max = 16,
        default = 1
    }
    params:add {
        type = "number",
        id = "note_number",
        name = "note number",
        min = 21,
        max = 108,
        default = 60
    }
    params:add {
        type = "number",
        id = "note_velocity",
        name = "note velocity",
        min = 0,
        max = 127,
        default = 100
    }

    params:add_separator()

    params:add {
        type = "number",
        id = "ctrl_channel",
        name = "controller ch",
        min = 1,
        max = 16,
        default = 1
    }
    params:add {
        type = "number",
        id = "ctrl_number",
        name = "controller #",
        min = 0,
        max = 127,
        default = 0
    }
    params:add {
        type = "number",
        id = "ctrl_value",
        name = "controller value",
        min = 0,
        max = 127,
        default = 0
    }
end

function enc(n, d)
    if ctrl_enc_num == 2 then
        -- do some stuff
        print("Doing some stuff with encoder " .. n)
    end

    redraw()
end

function key(n, z)
    if n == 2 then
        if (z == 1) then
            midi_out:note_on(params:get("note_number"), params:get("note_velocity"), params:get("note_channel"))
            is_note_on = true
        else
            midi_out:note_off(params:get("note_number"), 0, params:get("note_channel"))
            is_note_on = false
        end
    end

    redraw()
end

function redraw()
    screen.clear()

    screen.move(4, 8)
    if is_note_on then
        screen.text("NOTE ON")
    else
        screen.text("NOTE OFF")
    end
    screen.move(4, 16)
    screen.text("NOTE  " .. params:get("note_number"))
    screen.move(48, 16)
    screen.text("VEL  " .. params:get("note_velocity"))
    screen.move(94, 16)
    screen.text("CH  " .. params:get("note_channel"))

    screen.move(4, 40)
    screen.text("CTRL  " .. params:get("ctrl_number"))
    screen.move(48, 40)
    screen.text("VAL  " .. params:get("ctrl_value"))
    screen.move(94, 40)
    screen.text("CH " .. params:get("ctrl_channel"))

    screen.update()
end
