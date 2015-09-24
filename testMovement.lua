scr = manager:machine().screens[":screen"]
mem = manager:machine().devices[":maincpu"].spaces["program"]
xlocadr = 0x060103a5
ylocadr = 0x060103a9
xveladr = 0x060103ad

keyboardadr = 0x060103F5

objadr = 0x06015f6a
missileadr = 0x06016f78
dir = 1

ms_old_list = {}

function cheat()
-- set P1 invincible
    mem:write_u8(0x060103FA, 1);
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
  --print(keypress)
end

function getObject()
  adr = objadr
  objid = mem:read_u16(adr)
  objid_old_list = {}
  while (objid ~= 0) and (objid_old_list[objid]~=true) do
    objxloc = mem:read_u8(adr+0x00000003)
    objyloc = mem:read_u16(adr+0x00000004)
    objw = mem:read_u16(adr+0x00000006)
    objh = mem:read_u16(adr+0x00000008)

    scr:draw_box(objyloc, objxloc, objyloc+objh, objxloc+objw,0, 0xff00ffff)
    adr = adr + 0x00000010

    objid_old_list[objid] = true
    objid = mem:read_u16(adr)
  end
end

function getMissile()
  adr = missileadr
  msdata = mem:read_u64(adr)

  while (msid ~= 0) and (ms_old_list[msdata]~=true) do
  --while (msid ~= 0) do

    msxloc = mem:read_u8(adr+0x00000005)
    msyloc = mem:read_u16(adr+0x00000006)

    --print(msdata)
    --print(msxloc, " ", msyloc, " ", msxloc+5, " ", msyloc+5)

    scr:draw_box(msyloc, msxloc, msyloc+5, msxloc+5, 0, 0xff223300)
    adr = adr + 0x00000010

    ms_old_list[msdata] = true
    msdata = mem:read_u64(adr)
  end
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

function main()
  cheat()
  getState()
  getObject()
  getMissile()
  moveLR()
  drawBox_1P()
end

emu.sethook(main, "frame")
