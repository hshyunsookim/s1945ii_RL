scr = manager:machine().screens[":screen"]
mem = manager:machine().devices[":maincpu"].spaces["program"]
xlocadr = 0x060103a5
ylocadr = 0x060103a9
xveladr = 0x060103ad

keyboardadr = 0x060103F5
dir = 1
keydir = "left"


function cheat()
-- set P1 invincible
    mem:write_u8(0x60103FA, 1);
end

function update_p1()
    p1_x = (mem:read_u32(0x60103a3) & 0xFFFF0) >> 8
    p1_y = (mem:read_u32(0x60103a7) & 0xFFFF0) >> 8
end

function getState()
  xloc = mem:read_u8(xlocadr)
  yloc = mem:read_u8(ylocadr)
  xvel = mem:read_u8(xveladr)
  -- yvel = 
  keypress = mem:read_u8(keyboardadr)
  --print(keypress)
end

function drawBox_1P()
  scr:draw_box(yloc-10, xloc-10, yloc+10, xloc+10,0, 0xff00ffff)
  scr:draw_line(yloc-10, xloc-10, yloc+10, xloc+10, 0xff00ffff)
end

function move(direction, incr)
  mem:write_u8(xlocadr, xloc+(direction*incr))
end

function moveLR()
  if xloc >= 213 then
    dir = -1
  elseif xloc <= 10 then
    dir = 1
  end
  move(dir,3)
end

function keyPress(key)
  if key == "left" then
    val = 16
  elseif key == "right" then
    val = 32
  elseif key == "down" then
    val = 64
  elseif key == "up" then
    val = 128
  end
  mem:write_u8(keyboardadr, val)
end

function moveKeyPress()
  if xloc >= 213 then
    keydir = "left"
  elseif xloc <= 10 then
    keydir = "right"
  end
  keyPress(keydir)  
end


function testKeyboard()
  keypress(0x26)
end


function main()
  cheat()
  getState()


  --moveLR()
  --moveKeyPress()
  drawBox_1P()

  --testKeyboard()
end

emu.sethook(main, "frame")
