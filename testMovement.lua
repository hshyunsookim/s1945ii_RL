scr = manager:machine().screens[":screen"]
mem = manager:machine().devices[":maincpu"].spaces["program"]
xadr = 0x060103a5
yadr = 0x060103a9
dir = 1

function getState()
  xloc = mem:read_u8(xadr)
  yloc = mem:read_u8(yadr)
end

function drawBox_1P()
  scr:draw_box(yloc-10, xloc-10, yloc+10, xloc+10,0, 0xff00ffff)
  scr:draw_line(yloc-10, xloc-10, yloc+10, xloc+10, 0xff00ffff)
end

function move(direction, incr)
  mem:write_u8(xadr, xloc+(direction*incr))
end

function moveLR()
  if xloc >= 213 then
    dir = -1
  elseif xloc <= 10 then
    dir = 1
  end
  move(dir,3)
end

function main()
  getState()
  moveLR()
  drawBox_1P()
end

emu.sethook(main, "frame")
