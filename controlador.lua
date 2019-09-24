-- controlador
-- manual midi controller

-- KEY2 toggles/holds a note
-- ENC2 controls a CC controller

-- set up velocity, channels, etc
-- in the params menu

local midi_out = midi.connect()
local is_note_on = false

function init()
    params:add {
        type = "option",
        id = "key_mode",
        name = "key mode",
        options = {"TOGGLE", "HOLD"},
        default = 1
    }
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

local function midi_note_on()
    midi_out:note_on(params:get("note_number"), params:get("note_velocity"), params:get("note_channel"))
    is_note_on = true
end

local function midi_note_off()
    midi_out:note_off(params:get("note_number"), 0, params:get("note_channel"))
    is_note_on = false
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
        if (params:get("key_mode") == 1) then
            if (z == 1) then
                if (is_note_on) then
                    midi_note_off()
                else
                    midi_note_on()
                end
            end
        else
            if (z == 1) then
                midi_note_on()
            else
                midi_note_off()
            end
        end
    end
    redraw()
end

function redraw()
    screen.clear()

    if is_note_on then
        screen.level(12)
        screen.circle(2, 5, 2)
        screen.fill()
    else
        screen.level(6)
    end
    screen.move(6, 8)
    screen.text("NOTE  " .. params:get("note_number"))
    screen.move(50, 8)
    screen.text("VEL  " .. params:get("note_velocity"))
    screen.move(96, 8)
    screen.text("CH  " .. params:get("note_channel"))

    screen.level(10)
    screen.move(6, 34)
    screen.text("CTRL  " .. params:get("ctrl_number"))
    screen.move(50, 34)
    screen.text("VAL  " .. params:get("ctrl_value"))
    screen.move(96, 34)
    screen.text("CH  " .. params:get("ctrl_channel"))

    screen.update()
end
