-- controlador
-- manual midi controller

-- KEY2 toggles/holds a note
-- ENC2 controls a CC controller
-- KEY2 and KEY3 trigger ALL NOTES OFF

-- set up velocity, channels, etc
-- in the params menu

local midi_out = midi.connect()
local is_note_on = false

local key2_held = false
local key3_held = false

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

local function midi_note_on(note_num, note_vel, note_chan)
    note_num = note_num or params:get("note_number")
    note_vel = note_vel or params:get("note_velocity")
    note_chan = note_chan or params:get("note_channel")
    midi_out:note_on(note_num, note_vel, note_chan)
    is_note_on = true
end

local function midi_note_off(note_num, note_chan)
    note_num = note_num or params:get("note_number")
    note_chan = note_chan or params:get("note_channel")
    midi_out:note_off(note_num, note_vel, note_chan)
    is_note_on = false
end

local function all_notes_off()
    print("all notes off!")
    for note_num = 21, 80 do
        midi_note_off(note_num)
    end
end

function enc(n, d)
    if ctrl_enc_num == 2 then
        -- do some stuff
        print("Doing some stuff with encoder " .. n)
    end

    redraw()
end

function key(n, z)
    local is_toggle_mode = (params:get("key_mode") == 1)
    local is_button_down = (z == 1)
    local is_key2 = (n == 2)
    local is_key3 = (n == 3)

    if is_key2 then
        if (is_button_down) then
            key2_held = true
        else
            key2_held = false
        end
        if (is_toggle_mode) then
            if (is_button_down) then
                if (is_note_on) then
                    midi_note_off()
                else
                    if (not key3_held) then
                        midi_note_on()
                    end
                end
            end
        else
            if (is_button_down and not key3_held) then
                midi_note_on()
            else
                midi_note_off()
            end
        end
    end
    if is_key3 then
        if (is_button_down) then
            key3_held = true
        else
            key3_held = false
        end
    end
    if (key2_held and key3_held) then
        all_notes_off()
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
