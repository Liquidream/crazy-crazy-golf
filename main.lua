require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)
require("common")
require("courseEditor")
require("ui_input")



-- UI-bound/global vars
brushSize = 10

-- local vars
local mx = 0
local my = 0
local courseCanvas


function love.load()
  init_sugar("Hello world!", GAME_WIDTH, GAME_HEIGHT, GAME_SCALE)
  
  use_palette(ak54)
  screen_render_stretch(false)
  screen_render_integer_scale(false)
  set_frame_waiting(60)
  
  -- course gfx setup
  courseCanvas = new_surface(GAME_WIDTH, GAME_HEIGHT, "courseCanvas")

  -- preload images
  preloadImages()

  -- control setup
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
  -- if btn(0) then x = x - 2 end
  -- if btn(1) then x = x + 2 end
  -- if btn(2) then y = y - 2 end
  -- if btn(3) then y = y + 2 end

  -- mouse moved?
  if btnv(6) or btnv(7) then
    mx, my = btnv(6), btnv(7)
  end
  -- mouse clicked? paint at current position
  if btnv(8) > 0 then
    -- switch to "paint" canvas
    target("courseCanvas")
    -- draw 
    circfill(mx, my, brushSize, 8)
    -- reset to "screen" again
    target()
  end
end

function love.draw()
  cls(27)
  -- draw current course data
  spr_sheet("courseCanvas", 0, 0)
  -- draw "cursor"
  circfill(mx, my, brushSize, 8)
end


function preloadImages()
  network.async(function()
    log("loading images...")        

    load_png("defaultCourse", "assets/course1.png")

  end)
end