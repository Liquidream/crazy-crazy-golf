require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)
require("common")
require("game")
require("courseEditor")
require("ui_input")

-- global vars
gameMode = GAME_MODE.GAME

-- UI-bound/global vars
uiEditorMode = false
brushSize = 10


-- local vars
local mx = 0
local my = 0
local courseCanvas


function love.load()
  init_sugar("Crazy Crazy Golf!", GAME_WIDTH, GAME_HEIGHT, GAME_SCALE)
  
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


  -- todo: load course data
  -- (TEMP - just import first level)  
  importCourse()

  -- init game
  initGame()
end

function love.update()
  
  -- are we in editor mode?
  if gameMode == GAME_MODE.GAME then
    -- update game elements
    updateGame(dt)
  else
    -- update game editor
    updateEditor(dt)
  end
  -- 
end

function love.draw()
  cls(27)
  -- draw current course data
  spr_sheet("courseCanvas", 0, 0)

  -- are we in editor mode?
  if gameMode == GAME_MODE.GAME then
    -- draw game elements
    drawGame()
  else
    -- draw game editor
    drawEditor()
  end
end


function preloadImages()
  network.async(function()
    log("loading images...")    
    
    --TODO: Finish this

    load_png("defaultCourse", "assets/course1.png")

  end)
end