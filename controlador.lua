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
    params:add_seperator()
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
    redraw()
end

function key(n, z)
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
    screen.text(ctrl.enc)
    screen.move(4, 48)
    screen.text("CTRL  " .. ctrl.num)
    screen.move(48, 48)
    screen.text("VAL  " .. ctrl.val)
    screen.move(94, 48)
    screen.text("CH " .. ctrl.ch)

    screen.update()
end
