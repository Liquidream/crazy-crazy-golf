require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)
require("common")
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
  cls()
  -- draw current course data
  spr_sheet("courseCanvas", 0, 0)
  -- draw "cursor"
  circfill(mx, my, brushSize, 8)
end


-- function saveCourse()
--   log("saveCourse()...")

--   local testTable = {}
--   testTable[1]="hello"
--   testTable[2]=1123

--   network.async(function()
--     -- local lastHighScore = castle.storage.getGlobal('highscore')
--     -- if not lastHighScore or lastHighScore < score then
--       castle.storage.set("pntest", "hello!")
--       castle.storage.set("testTable2", testTable)
--     --end
--   end)
-- end

-- function loadCourse()
--   log("loadCourse()...")

--   --local testTable = {}

--   network.async(function()    
--     test = castle.storage.get("pntest")
--     local testTable = castle.storage.get("testTable2")
--     log("test = "..tostring(test))
--     log("testTable = "..tostring(testTable[1]))
--   end)

-- end

function saveCourse()
  log("saveCourse()...")
  -- TODO: 
  --  > grab pixels for each layer
  --  > store them in tables of Castle user storage (for now)
  local coursePixels = {}

  -- refresh latest pixel data
  target("courseCanvas")
  scan_surface("courseCanvas")
  -- data stored as 1-index (so shift by 1 pixel)
  for x=1,GAME_WIDTH+1 do
    coursePixels[x] = {}    
    for y=1,GAME_HEIGHT+1 do
      coursePixels[x][y] = pget(x-1,y-2)
    end
  end
  target()

  -- now store it
  network.async(function()
      castle.storage.set("courseData", coursePixels)
  end)
end

function loadCourse()
  log("loadCourse()...")
  -- TODO: 
  --  > get data from tables of Castle user storage (for now)
  --  > draw pixels for each layer
  local coursePixels = {}
  local testTable = {}

  -- get saved pixel data
  network.async(function()

    local coursePixels = castle.storage.get("courseData")
    if coursePixels then
      -- switch to "paint" canvas
      target("courseCanvas")
      -- data stored as 1-index (so shift by 1 pixel)
      for x=1,GAME_WIDTH+1 do      
        for y=1,GAME_HEIGHT+1 do
          pset(x-1, y-1, coursePixels[x][y])
        end
      end
      target()
    end

  end)

end


function resetCourse()
  log("resetCourse()...")

  -- clear pixel data
  target("courseCanvas")
  cls()
  target()
end