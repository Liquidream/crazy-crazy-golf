
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
  -- TODO: 
  --  > grab pixels for each layer
  --  > store them in tables of Castle user storage (for now)
  local coursePixels = getCourseDataTable()

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
  -- TODO: 
  --  > grab pixels for each layer
  --  > return them as multiple table values
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

  -- todo: return all layers as multiple values
  return coursePixels
end