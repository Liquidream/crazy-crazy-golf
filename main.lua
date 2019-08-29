-- Welcome to your new Castle project!
-- https://castle.games/get-started
-- Castle uses Love2D 11.1 for rendering and input: https://love2d.org/
-- See here for some useful Love2D documentation:
-- https://love2d-community.github.io/love-api/

if CASTLE_PREFETCH then
  CASTLE_PREFETCH({
    "assets/ico-wall.png",
    "assets/ico-bridge.png",
    -- "assets/level-1-bg.png",
    -- "assets/level-1-data.png",
  })
end


require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)
require("common")
require("game")
require("courseEditor")
require("ui_input")

bf = require("breezefield")

-- global vars
gameMode = GAME_MODE.GAME

-- UI-bound/global vars
uiEditorMode = false
brushSize = 10


-- local vars
local mx = 0
local my = 0
local courseCanvas
local courseCanvasTemp


function love.load()
  -- init Sugarcoat engine
  initSugarcoat()
  
  -- course gfx setup
  courseCanvas = new_surface(GAME_WIDTH, GAME_HEIGHT, "courseCanvas")
  courseCanvasTemp = new_surface(GAME_WIDTH, GAME_HEIGHT, "courseCanvasTemp")

  -- preload images
  preloadImages()



  -- todo: load course data
  -- (TEMP - just import first level)  
  importCourse()

  -- init game
  initGame()

  -- init editor
  initEditor()
end

function love.update(dt)
  
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

  -- are we in editor mode?
  if gameMode == GAME_MODE.GAME then
    -- draw game elements
    drawGame()
  else
    -- draw game editor
    drawEditor()
  end

  if DEBUG_MODE then
    print('FPS: ' .. love.timer.getFPS(), 85, GAME_HEIGHT-36, 49)
  end
end



function initSugarcoat()
  init_sugar("Crazy Crazy Golf!", GAME_WIDTH, GAME_HEIGHT, GAME_SCALE)
  
  use_palette(ak54)
  screen_render_stretch(false)
  screen_render_integer_scale(false)
  set_frame_waiting(60)


  -- control setup
  player_assign_ctrlr(0, 0)

  register_btn(0, 0, input_id("keyboard", "left"))
  register_btn(1, 0, input_id("keyboard", "right"))
  register_btn(2, 0, input_id("keyboard", "up"))
  register_btn(3, 0, input_id("keyboard", "down"))
  register_btn(4, 0, input_id("keyboard", "space"))

  -- mouse input
  register_btn(6, 0, input_id("mouse_position", "x"))
  register_btn(7, 0, input_id("mouse_position", "y"))
  register_btn(8, 0, input_id("mouse_button", "lb"))
end


function preloadImages()
  network.async(function()
    log("loading images...")    
    
    --TODO: Finish this

    load_png("defaultCourse", "assets/course1.png")

  end)
end