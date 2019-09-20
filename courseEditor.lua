
-- ---------------------------
-- editor vars
-- ---------------------------
terrainBrushSize = 10
currTool = 2
lastTool = currTool
  -- 1 = terrain painting
  -- 2 = terrain heightmap
  -- 3 = objects (placing/moving/properties)
currTerrainLayer = 2
  -- 0 = water (no terrain)
  -- 1 = rough
  -- 2 = fairway/green
  -- 3 = sand trap

local terrainLayerCols = {}


function initEditor()
  terrainLayerCols = {
    [3] = 45,
    [2] = 8,
    [1] = 7,
  }
  log("terrainLayerCols >> "..terrainLayerCols[3])
end

function updateEditor(dt)
  -- mouse moved?
  if btnv(6) or btnv(7) then
    mx, my = flr(btnv(6)), flr(btnv(7))
  end
  -- --------------------------------------
  -- mouse clicked/down/dragged states
  -- --------------------------------------
  lmbDown = false
  lmbClicked = false
  lmbDragging = false
  lmbReleased = false
  -- left clicked down since last frame?
  if btnv(8)>0 then    
    lmbDown = true
    if last_mDown~=true  then
      lmbClicked = true
    end
  end
  -- left released since last frame?
  if btnv(8)==0 then    
    lmbDown = false
    if last_mDown then
      lmbReleased = true
    end
  end
  -- mouse dragged (while holding down button)?
  if last_mDown and (mx~=last_mx or my~=last_my) then
    lmbDragging = true
  end


  -- ----------------------------------------
  -- terrain "paint" mode
  -- ----------------------------------------
  if currTool == 1 then
    -- mouse clicked? paint at current position
    if btnv(8) > 0 
     or btnv(9) > 0 then

      -- clear the temp canvas (once!)
      target("courseCanvasTemp")
      cls()

      -- go through each terrain layer,
      -- "drawing" each layer's content to a canvas
      -- (or erasing it from current one)
      -- building up each layer and finally,
      -- copying it back to the game's data canvas
      for l=1,3 do
        palt()
        -- switch to "layer paint" canvas
        target("courseCanvasLayerTemp")
        cls()

        -- rough layer = (make everything "rough")
        if l==1 then
          -- 
          pal(terrainLayerCols[3], terrainLayerCols[1])
          pal(terrainLayerCols[2], terrainLayerCols[1])
        else
          -- only draw the colours for THIS layer
          for i, col in ipairs(terrainLayerCols) do
            palt(terrainLayerCols[i], i~=l)
          end
        end
        
        spr_sheet("courseCanvas", 0, 0)
        -- paint "rough"?
        if currTerrainLayer == l then
          circfill(mx, my, terrainBrushSize,  btnv(8)>0 and terrainLayerCols[currTerrainLayer] or 37)
        end
        -- now commit layer to temp canvas
        pal()
        palt()
        target("courseCanvasTemp")
        palt(37, true) -- hide eraser "painting"
        spr_sheet("courseCanvasLayerTemp", 0, 0)
      end

      -- finally, commit temp canvas to real data canvas
      target("courseCanvas")
      cls()
      spr_sheet("courseCanvasTemp", 0, 0)

      -- reset to "screen" again
      target()
      pal()
      palt()
    end -- if clicked

    -- scroll wheel for brush size
    terrainBrushSize = mid(1, terrainBrushSize + btnv(10), 50)
  end -- if paint mode

  -- ----------------------------------------
  -- object/obstacle mode
  -- ----------------------------------------
  
  
  -- bail out now, if no hole data
  if hole == nil then
    return
  end
  
  -- update objects (Q: which needs to be called first?)
  hole.playerStart:update(dt)
  hole.pin:update(dt)

  -- update objects?
  for k,obj in pairs(hole.obstacles) do
    obj:update(dt)
  end

  if currTool == 2 then
    -- check for hover/selection
    hoverObj = nil

    -- v2
    -- https://love2d.org/wiki/Fixture:testPoint
    if player.collider.fixture:testPoint( mx, my ) then
      hoverObj = player
      player:hover()
    elseif hole.playerStart.collider.fixture:testPoint( mx, my ) then
      hoverObj = hole.playerStart
      hole.playerStart:hover()
    elseif hole.pin.collider.fixture:testPoint( mx, my ) then
      hoverObj = hole.pin
      hole.pin:hover()
    else
      -- check all objects for collisions
      for k,obj in pairs(hole.obstacles) do
        if obj.collider.fixture:testPoint( mx, my ) then
          hoverObj = obj
          obj:hover()
        end
      end
    end


    -- check for select
    if lmbClicked and hoverObj then
      -- update selected object (for UI)
      selectedObj = hoverObj
    end
    -- check for dragging
    if lmbDown 
     and hoverObj 
     and not draggingObj 
     and not lmbClicked
     and (mx~=last_mx or my~=last_my) then
      -- "move/dragging" mode
      draggingObj = hoverObj
    end
    if lmbDown and draggingObj then
      draggingObj:moveTo(mx,my)
    else
      draggingObj = nil
    end
  end -- object mode

  
  -- remember
  last_mDown = lmbDown
  last_mx = mx
  last_my = my
end --update


function drawEditor()
  
  -- draw current course data
  spr_sheet("courseCanvas", 0, 0)

  -- draw brush outline (cursor)
  if currTool==1 then
    circ(mx, my, terrainBrushSize, 46)
  end

  -- -------------------------------
  -- draw objects, etc
  -- -------------------------------  
  -- draw all physics objects
  world:draw()
  -- draw player
  player:draw(true)
end


--[[

  Data structure:

  holeData = 
  {
    title="",
    description="",
    par=1-5,
    difficulty=1-3,
    tags={"beginner","premium"},
    coursePixelData={},
    playerStartData={},
    pinData={},
    obstacles={
      obstacleData={},
      obstacleData={},
      ...
    },
    dataVersion=1
  }

]]


function clearHoleData()
  -- destroy all collider objects
  hole.playerStart.collider:destroy()
  hole.pin.collider:destroy()
  for k,obj in pairs(hole.obstacles) do
    if obj.collider then
      obj.collider:destroy()
    end
  end
  -- now remove main table
  hole = nil
  selectedObj = nil
end


function createHoleFromData(holeData)
  local hole = 
  {
    title="",
    description="",
    par=0,
    difficulty=0,
    tags={},
    coursePixels={},
    playerStart={},
    pin={},
    obstacles={}
  }
  
  -- TODO: construct level objects from data passed
  if holeData then
    -- ------------------------------------------
    -- TODO: restore the hole from data passed
    -- ------------------------------------------
    hole.title = holeData.title
    hole.description = holeData.description
    hole.par = holeData.par
    --holeData.difficulty = hole.difficulty
    hole.coursePixelData = hole.coursePixelData
    --holeData.tags = {}
    
    hole.coursePixels = holeData.coursePixelData
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
    hole.playerStart = PlayerStart(nil, nil, holeData.playerStartData)
    hole.pin =  Pin(nil, nil, holeData.pinData)
    for k,objData in pairs(holeData.obstacles) do
      -- TODO: handle different object "types"
      local wall = Wall(nil, nil, objData)
      table.insert(hole.obstacles, wall)
    end

  else
    -- ------------------------------------
    -- load the default hole data?
    -- ------------------------------------
    hole.playerStart = PlayerStart(PLAYER_STARTX, PLAYER_STARTY)
    hole.pin = Pin(445,55)
    local wall = Wall(304,164)
    wall.spin = -2
    table.insert(hole.obstacles, wall)
  end

  return hole
end

function createHoleData(hole)
  local holeData = 
  {
    title="",
    description="",
    par=0,
    difficulty=0,
    tags={},
    coursePixelData={},
    playerStartData={},
    pinData={},
    obstacles={},
    dataVersion=1
  }

  -- create data structure for storage
  holeData.title = hole.title
  holeData.description = hole.description
  holeData.par = hole.par
  --holeData.difficulty = hole.difficulty
  holeData.coursePixelData = getCoursePixelData()
  --holeData.tags = {}
  holeData.coursePixels = getCoursePixelData()
  holeData.playerStartData = hole.playerStart:getData()
  log("holeData.playerStartData.x = "..tostring(holeData.playerStartData.x))
  holeData.pinData = hole.pin:getData()
  for k,obj in pairs(hole.obstacles) do
    table.insert(holeData.obstacles, obj:getData())
  end

  return holeData
end

-- save course to user's castle storage
function saveCourse()
  log("saveCourse()...")  
  
  -- create data structure for storage
  local holeData = createHoleData(hole)

  --  > grab pixels for each layer
  --  > store them in tables of Castle user storage (for now)
  --local coursePixels = getCoursePixelData()
  
  -- now store it
  network.async(function()
    log("before storage set")
    
    --castle.storage.set("courseData", coursePixels)
    --castle.storage.set("courseDataTest", wall:getData())
    castle.storage.set("holeData", holeData)
    log("after storage set")
  end)
end

function loadCourse()
  log("loadCourse()...")
  -- TODO: get data from tables of Castle user storage (for now)
  
  -- destroy/release any current hole data (collisions, etc.)
  if hole then
    clearHoleData()
  end

  -- get saved pixel data
  network.async(function()

    holeData = castle.storage.get("holeData")
    --coursePixels = castle.storage.get("courseData")
    --log("holeData.playerStartData.x = "..tostring(holeData.playerStartData.x))
  
    hole = createHoleFromData(holeData)
  
    -- (Version 1)---------------------------
    -- read table of color info and draw a pixel at a time
    -- local coursePixels = {}
    -- local testTable = {}
    -- local coursePixels = castle.storage.get("courseData")
    -- if coursePixels then
    --   -- switch to "paint" canvas
    --   target("courseCanvas")
    --   -- data stored as 1-index (so shift by 1 pixel)
    --   for x=1,GAME_WIDTH+1 do      
    --     for y=1,GAME_HEIGHT+1 do
    --       pset(x-1, y-1, coursePixels[x][y])
    --     end
    --   end
    --   target()
    -- end
    
    -- (Version 2 - Saved ok, but couldn't restore & took WAY more data!)
    -- local coursePixels = castle.storage.get("courseData-v2")
    -- log("#coursePixels = "..#coursePixels)
    -- local imgData = love.image.newImageData(GAME_WIDTH, GAME_HEIGHT, "rgba8", coursePixels)
    -- load_png("courseCanvas", imgData) -- palette, use_as_spritesheet)
    -- target()

  end)

end

-- clear all pixel + course data and start from scratch
function clearCourse()
  log("clearCourse()...")

  -- clear pixel data
  target("courseCanvas")
  cls()
  target()
  -- update latest course data
  scan_surface("courseCanvas")

  -- clear objects and reset defaults
  for k,obj in pairs(hole.obstacles) do
    obj.collider:destroy()
  end
  hole.obstacles={} 
  --wall=nil
  -- reset player start
  hole.playerStart:moveTo(GAME_WIDTH/3, GAME_HEIGHT/2)
  hole.playerStart.r=0
  -- reset player
  restartHole()
  -- reset pin
  hole.pin:moveTo((GAME_WIDTH/3)*2, GAME_HEIGHT/2)

end


-- function copyCourse()
--   log("copyCourse()...")

--   local data = getCoursePixelData()

--   -- todo: dump course data to clipboard 
--   -- (so can be hard-coded as default course to play/edit)
--   local text = "defaultCourse = {\n"
--   for k, col in pairs(data) do
--     text = text + "  {"
--   end
--   text = text + "}"

--   love.system.setClipboardText( text )
--end

-- export current course to local image file
function exportCourse()
  log("exportCourse()...")

  --target("courseCanvas")
  surfshot("courseCanvas", 1, "exported_course.png")
  --surfshot("courseCanvas", 1, "exported_course_"..love.timer.getTime()..".png")

end

-- export current course to local image file
function importCourse()
  log("importCourse()...")

  loadingProgress = true

  network.async(function()

    log("loading images...")        

    load_png("importedCourse", "assets/exported_course.png")
    --load_png("importedCourse", "/"..love.filesystem.getUserDirectory().."\\exported_course.png")

    target("courseCanvas")
    cls()
    -- draw default course here!
    spr_sheet("importedCourse")    
    
    -- Update pixel data?
    target("courseCanvas")
    scan_surface("courseCanvas")

    target()

    loadingProgress = false
  end)

end


-- helper function to convert course layered pixel data to table(s)
function getCoursePixelData()
  log("getCoursePixelData()...")
  
  -- (Version 2 - Saved ok, but couldn't restore & took WAY more data!)
  -- local holeData = surfshot_data("courseCanvas", 1)
  -- log("img format = "..holeData:getFormat())
  -- log("img width = "..holeData:getWidth())
  -- log("img height = "..holeData:getHeight())
  -- log("game width = "..GAME_WIDTH)
  -- log("game height = "..GAME_HEIGHT)
  -- local strData = holeData:getString()

  -- log("#strData = "..#strData)
  -- return strData

  -- (Version 1) ----------------------------
  -- grab pixels as table of colour values
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

  --todo: return all layers as multiple values?
  return coursePixels
end