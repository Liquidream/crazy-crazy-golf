require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)

local x = 64
local y = 64

function love.load()
  init_sugar("Hello world!", 128, 128, 3)
  
  set_frame_waiting(60)
  
  register_btn(0, 0, input_id("keyboard", "left"))
  register_btn(1, 0, input_id("keyboard", "right"))
  register_btn(2, 0, input_id("keyboard", "up"))
  register_btn(3, 0, input_id("keyboard", "down"))
end

function love.update()
  if btn(0) then x = x - 2 end
  if btn(1) then x = x + 2 end
  if btn(2) then y = y - 2 end
  if btn(3) then y = y + 2 end
end

function love.draw()
  cls()
  circfill(x, y, 4 + 2 * cos(t()), 3)
end