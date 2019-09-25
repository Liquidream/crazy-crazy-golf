--
-- CRAZY CRAZY GOLF
--

-- IDEAS:
--  - "Invisible walls - is fun... especially rotating ones!"

-- Credits:
--  "Awesome" font (@somepx)


if CASTLE_PREFETCH then
  CASTLE_PREFETCH({
    "assets/Awesome.ttf",
    -- "assets/course1.png",
    -- "assets/exported_course.png",
    "assets/ico-start.png",
    "assets/ico-hole.png",
    "assets/ico-wall.png",
    "assets/ico-bridge.png",
  })
end

require("common")

-- global vars
gameMode = GAME_MODE.GAME

require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)
Object = require("objects/classic")
require("objects/baseObject")
require("objects/playerStart")
require("objects/pin")
require("objects/wall")
require("objects/bridge")
require("game")
require("courseEditor")
require("ui_input")
bf = require("breezefield")


function love.load()
  -- init Sugarcoat engine
  initSugarcoat()
  
  -- course gfx setup
  new_surface(GAME_WIDTH, GAME_HEIGHT, "courseCanvas")          -- just terrain data  (for saving/loading)
  new_surface(GAME_WIDTH, GAME_HEIGHT, "courseCanvasAllData")   -- terrain + obj data (for actual collisions)
  new_surface(GAME_WIDTH, GAME_HEIGHT, "courseCanvasTemp")      
  new_surface(GAME_WIDTH, GAME_HEIGHT, "courseCanvasLayerTemp")

  -- preload images
  preloadImages()




  -- (TEMP - just import first hole)  
  --importHole()

  -- init game
  initialPost = castle.post.getInitialPost()
  if initialPost then 
    initGame(initialPost.data)
  else
    initGame()
  end


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
  
  -- Been a while and STILL no data loaded?
  --if t()>2 and hole==nil then

  -- initialPost = castle.post.getInitialPost()
  -- if initialPost then 
  --   initGame(initialPost.data)
  -- else
  --   initGame()
  -- end
  --end

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
    print('FPS: ' .. love.timer.getFPS(), 4, GAME_HEIGHT-24, 16)
  end
end

-- function castle.postopened(inPost)
--   -- restore the post data
--   log("in castle.postopened(post)...")
  
--   -- keep post around
--   post = inPost

--   -- re-init game
--   initGame(post.data)  
  
--   -- log("post.data.xpos = "..post.data.xpos)
--   -- log("post.data.ypos = "..post.data.ypos)
--   -- log("post.data.spread = "..post.data.spread)
--   --systems[1] = Sprinklez:createSystem(post.data.xpos, post.data.ypos, post.data)
-- end



function initSugarcoat()
  init_sugar("Crazy Crazy Golf!", GAME_WIDTH, GAME_HEIGHT, GAME_SCALE)
  
  use_palette(ak54)
  screen_render_stretch(false)
  screen_render_integer_scale(false)
  set_frame_waiting(60)

  -- new font!
  load_font('assets/Awesome.ttf', 36, 'corefont-big', true)
  load_font('assets/Awesome.ttf', 18, 'corefont', true)

  -- init sprites
  spritesheet_grid(16, 16)
  load_png ("spritesheet", "assets/spritesheet.png", nil, true)


  -- control setup
  player_assign_ctrlr(0, 0)

  register_btn(0, 0, input_id("keyboard", "left"))
  register_btn(1, 0, input_id("keyboard", "right"))
  register_btn(2, 0, input_id("keyboard", "up"))
  register_btn(3, 0, input_id("keyboard", "down"))
  register_btn(4, 0, input_id("keyboard", "space"))

  -- mouse input
  register_btn(6,  0, input_id("mouse_position", "x"))
  register_btn(7,  0, input_id("mouse_position", "y"))
  register_btn(8,  0, input_id("mouse_button", "lb"))
  register_btn(9,  0, input_id("mouse_button", "rb"))
  register_btn(10, 0, input_id("mouse_button", "scroll_y"))

  -- re-show the mouse cursor
  love.mouse.setVisible(true)
end


function preloadImages()
  --network.async(function()
    log("loading images...")    
    
    --TODO: Finish this

    load_png("defaultCourse", "assets/course1.png")

  --end)
end