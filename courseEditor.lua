
-- local vars
local courseCanvas


function initEditor()
end

function updateEditor(dt)
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


function drawEditor()
  -- draw "cursor"
  circfill(mx, my, brushSize, 8)
end




-- save course to user's castle storage
function saveCourse()
  log("saveCourse()...")  
  --  > grab pixels for each layer
  --  > store them in tables of Castle user storage (for now)
  local coursePixels = getCourseDataTable()

  -- now store it
  network.async(function()
    log("before storage set")
    castle.storage.set("courseData", coursePixels)
    log("after storage set")
  end)
end

function loadCourse()
  log("loadCourse()...")
  -- TODO: get data from tables of Castle user storage (for now)
    
  -- get saved pixel data
  network.async(function()

    -- (Version 2 - Saved ok, but couldn't restore & took WAY more data!)
    -- local coursePixels = castle.storage.get("courseData-v2")
    -- log("#coursePixels = "..#coursePixels)
    -- local imgData = love.image.newImageData(GAME_WIDTH, GAME_HEIGHT, "rgba8", coursePixels)
    -- load_png("courseCanvas", imgData) -- palette, use_as_spritesheet)
    -- target()

    -- (Version 1)---------------------------
    -- read table of color info and draw a pixel at a time
    local coursePixels = {}
    local testTable = {}
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

-- restore pixel data to pre-made level
-- (e.g. default course)
function resetCourse()
  log("resetCourse()...")

  target("courseCanvas")
  cls()
  -- todo: draw default course here!
  spr_sheet("defaultCourse")

  target()

  -- clear pixel data
  -- target("courseCanvas")
  -- cls()
  -- target()
end


-- function copyCourse()
--   log("copyCourse()...")

--   local data = getCourseDataTable()

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

  network.async(function()
    log("loading images...")        

    load_png("importedCourse", "assets/exported_course.png")
    --load_png("importedCourse", "/"..love.filesystem.getUserDirectory().."\\exported_course.png")

    target("courseCanvas")
    cls()
    -- todo: draw default course here!
    spr_sheet("importedCourse")

    target()

  end)

end


-- helper function to convert course layered pixel data to table(s)
function getCourseDataTable()
  log("getCourseDataTable()...")
  
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
      coursePixels[x][y] = pget(x-2,y-2)
    end
  end
  target()

  --todo: return all layers as multiple values?
  return coursePixels
end