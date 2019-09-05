
ui = castle.ui

function uiRow(id, ...)
  local nArgs = select('#', ...)
  local args = { ... }
  ui.box(id, { flexDirection = 'row', alignItems = 'center' }, function()
      for i = 1, nArgs do
          ui.box(tostring(i), { flex = 1 }, args[i])
          if i < nArgs then
              ui.box('space', { width = 20 }, function() end)
          end
      end
  end)
end

function uiSpacer()
  ui.box('spacer', { height = 40 }, function() end)
end


-- All the UI-related code is just in this function. Everything below it is normal game code!

function castle.uiupdate()

  
  --ui.markdown('![](assets/title-text.png)')   
  ui.markdown([[
## CrAzY CrAzY Golf
The craziest crazy golf! 🤪
  ]])

  ui.tabs('main', { selected = 2 }, function()
    uiPlayMode = ui.tab('⛳ Play Mode', function()
      -- ================================================
      -- ==  PLAY MODE
      -- ================================================


    end)
    uiEditorMode = ui.tab('🎨 Editor Mode', function()
      -- ================================================
      -- ==  EDITOR MODE
      -- ================================================      
      ui.markdown([[### Course Editor]])
      currTool = 0
      currTool = (ui.section("Terrain Landscape", { defaultOpen = true }, function()
        ui.markdown([[Choose Terrain to paint:]])
        
        --ui.box("terrain2Box", { border=currTerrainLayer==3 and "5px solid #ff00fd" or "", flexGrow=1 }, function()
          if ui.button('Sand Trap', { icon = 'assets/ico-terrain-sand.png', iconOnly = false }) then
            log('set tool to sand')
            currTerrainLayer = 3
          end
        --end)
                
        --ui.box("terrain2Box", { border=currTerrainLayer==2 and "5px solid #ff00fd" or "", flexGrow=1 }, function()
          if ui.button('Fairway/Green', { icon = 'assets/ico-terrain-green.png', iconOnly = false }) then
            log('set tool to grass')
            currTerrainLayer = 2
          end
        --end)

        --ui.box("terrain2Box", { border=currTerrainLayer==1 and "5px solid #ff00fd" or "", flexGrow=1 }, function()
          if ui.button('Rough', { icon = 'assets/ico-terrain-rough.png', iconOnly = false }) then
            log('set tool to rough')
            currTerrainLayer = 1
          end
        --end)

        -- Size
        terrainBrushSize = ui.slider("Size", terrainBrushSize, 1, 50, { })

      end) and 1 or currTool) -- terrain painter section

      currTool = (ui.section("Objects / Obstacles", { defaultOpen = false }, function()
        ui.markdown([[Select objects/obstacles to create:]])
        
        if ui.button('Tee/Start', { icon = 'assets/ico-start.png', iconOnly = false }) then
          log('set tool to PLAYER START')
        end

        if ui.button('Hole', { icon = 'assets/ico-hole.png', iconOnly = false }) then
          log('set tool to HOLE')
        end

        if ui.button('Wall', { icon = 'assets/ico-wall.png', iconOnly = false }) then
          log('set tool to WALL')
        end
        
        if ui.button('Bridge', { icon = 'assets/ico-bridge.png', iconOnly = false }) then
          log('set tool to WALL')
        end

        
      -- 
      -- PROPERTIES?
      -- 
      if selectedObj then
        ui.section(selectedObj.name.." Properties", { defaultOpen = true }, function()          
            if selectedObj.uiProperties then
              -- draw this object's properties
              selectedObj:uiProperties()
            else
              ui.markdown([[#### No properties]])
            end
          end) 
      end

      end) and 3 or currTool) -- obstacles/objects section

      --log("currTool = "..currTool)

      ui.section("Main Menu", { defaultOpen = true }, function()

        if ui.button('Save Course') then
          -- TODO: save course to Castle storage
          saveCourse()
        end
        
        if DEBUG_MODE then
            if ui.button('Export Course') then
                -- TODO: export course to local storage (disk)
                exportCourse()
            end
            if ui.button('Import Course') then
                -- TODO: export course to local storage (disk)
                importCourse()
            end
        end
        
        if ui.button('Share Course') then
            -- TODO: share course to via Castle post
            --shareCourse()
        end
        
        if ui.button('Load Course') then
            -- TODO: load course to Castle storage
            loadCourse()
        end
        
        if ui.button('Reset Course') then
            -- TODO: reset current course data
            resetCourse()
        end
        
      end) -- obstacles/objects section


      lastTool = currTool
    end)  -- editor tab
  end) -- tab control



  -- uiEditorMode = ui.toggle("Editor OFF", "Editor ON", uiEditorMode, {onToggle = function(value)
  --   log("uiEditorMode = "..tostring(value))
  --   if value then
  --     -- todo: init editor?
  --   else
      
  --   end
  -- end})

  -- set the game mode
  gameMode = uiEditorMode and GAME_MODE.EDITOR or GAME_MODE.GAME

  -- changed since last frame
  if gameMode == GAME_MODE.GAME 
   and gameMode ~= lastGameMode
  then
    -- just switched to game, so refresh level data
    -- TODO: refresh game data?
    scan_surface("courseCanvas")
  end

  lastGameMode = gameMode
end
