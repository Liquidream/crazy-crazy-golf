require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)

local x = 64
local y = 64
local mx = 0
local my = 0


function love.load()
  init_sugar("Hello world!", 128, 128, 3)
  
  set_frame_waiting(60)
  
  player_assign_ctrlr(0, 0)

  register_btn(0, 0, input_id("keyboard", "left"))
  register_btn(1, 0, input_id("keyboard", "right"))
  register_btn(2, 0, input_id("keyboard", "up"))
  register_btn(3, 0, input_id("keyboard", "down"))

  -- mouse input
  register_btn(6, 0, input_id("mouse_position", "x"))
  register_btn(7, 0, input_id("mouse_position", "y"))
  register_btn(8, 0, input_id("mouse_button", "lb"))
end

function love.update()
  if btn(0) then x = x - 2 end
  if btn(1) then x = x + 2 end
  if btn(2) then y = y - 2 end
  if btn(3) then y = y + 2 end

  if btnv(6) then
    mx, my = btnv(6), btnv(7)
  end
end

function love.draw()
  cls()
  circfill(mx, my, 4 + 2 * cos(t()), 3)
  --circfill(x, y, 4 + 2 * cos(t()), 3)
end