-- controlador
-- manual midi controller

local options = {}
options.encoders = {"ENC 2", "ENC 3"}

local note = {}
note.key = "KEY2"
note.num = 60
note.vel = 100
note.ch = 1

local ctrl = {}
ctrl.enc = "ENC2"
ctrl.num = 1
ctrl.val = 0
ctrl.ch = 1

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
