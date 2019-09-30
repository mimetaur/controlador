-- controlador
-- manual midi controller
--
-- KEY2 toggles/holds a note
-- ENC2 controls a CC controller
--
-- KEY2 and KEY3 together
-- are ALL NOTES OFF
--
-- use params menu for:
-- note #
-- channel #
-- CC #
-- and so on

-- midi device
local midi_out = midi.connect()

-- global state
local is_note_on = false
local key2_held = false
local key3_held = false

-- local functions
local function midi_note_on(num, vel, chan)
    num = num or params:get("note_number")
    vel = vel or params:get("note_velocity")
    chan = chan or params:get("note_channel")
    midi_out:note_on(num, vel, chan)
    is_note_on = true
end

local function midi_note_off(num, chan)
    num = num or params:get("note_number")
    vel = 0 -- velocity is always 0 on note off
    chan = chan or params:get("note_channel")

    midi_out:note_off(num, vel, chan)
    is_note_on = false
end

local function all_notes_off()
    print("all notes off!")
    for note_num = 21, 80 do
        midi_note_off(note_num)
    end
end

local function send_midi_cc(value)
    midi_out:cc(params:get("cc_number"), value, params:get("cc_channel"))
end

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
        id = "cc_channel",
        name = "CC channel",
        min = 1,
        max = 16,
        default = 1
    }
    params:add {
        type = "number",
        id = "cc_number",
        name = "CC #",
        min = 0,
        max = 127,
        default = 2
    }
    params:add {
        type = "number",
        id = "cc_val",
        name = "CC value",
        min = 0,
        max = 127,
        default = 0,
        action = function(value)
            send_midi_cc(value)
        end
    }
    params:bang()
end

function enc(n, d)
    if n == 2 then
        params:delta("cc_val", d)
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
        screen.circle(2, 9, 2)
        screen.fill()
    else
        screen.level(5)
    end
    screen.move(6, 12)
    screen.text("NOTE  " .. params:get("note_number"))
    screen.move(50, 12)
    screen.text("VEL  " .. params:get("note_velocity"))
    screen.move(96, 12)
    screen.text("CH  " .. params:get("note_channel"))

    screen.level(8)
    screen.move(6, 38)
    screen.text("CTRL  " .. params:get("cc_number"))
    screen.move(50, 38)
    screen.text("VAL  " .. params:get("cc_val"))
    screen.move(96, 38)
    screen.text("CH  " .. params:get("cc_channel"))

    screen.update()
end
