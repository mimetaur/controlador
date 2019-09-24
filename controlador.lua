-- controlador
-- manual midi controller

function init()
    params:add {
        type = "option",
        id = "note_key",
        name = "note key",
        options = {"KEY 2", "KEY 3"},
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
        type = "option",
        id = "ctrl_enc",
        name = "control enc",
        options = {"ENC 2", "ENC 3"},
        default = 1
    }
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
    local ctrl_enc_num = params:get("ctrl_enc") + 1
    if ctrl_enc_num == n then
        -- do some stuff
        print("Doing some stuff with encoder " .. n)
    end

    redraw()
end

function key(n, z)
    local note_key_num = params:get("note_key") + 1
    if note_key_num == n then
        print("Doing some stuff with key " .. n)
    end

    redraw()
end

function redraw()
    screen.clear()

    screen.move(4, 16)
    screen.text(params:string("note_key"))
    screen.move(4, 24)
    screen.text("NOTE  " .. params:get("note_number"))
    screen.move(48, 24)
    screen.text("VEL  " .. params:get("note_velocity"))
    screen.move(94, 24)
    screen.text("CH  " .. params:get("note_channel"))

    screen.move(4, 40)
    screen.text(params:string("ctrl_enc"))
    screen.move(4, 48)
    screen.text("CTRL  " .. params:get("ctrl_number"))
    screen.move(48, 48)
    screen.text("VAL  " .. params:get("ctrl_value"))
    screen.move(94, 48)
    screen.text("CH " .. params:get("ctrl_channel"))

    screen.update()
end
