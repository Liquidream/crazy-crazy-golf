
local ui = castle.ui


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
      
      ui.section("Terrain Landscape", { defaultOpen = true }, function()
        ui.markdown([[Choose Terrain to paint:]])
        
        if ui.button('Fairway/Green', { icon = 'assets/ico-terrain-green.png', iconOnly = false }) then
          log('set tool to grass')
        end
        
        if ui.button('Rough', { icon = 'assets/ico-terrain-rough.png', iconOnly = false }) then
          log('set tool to rough')
        end
        
        if ui.button('Sand Trap', { icon = 'assets/ico-terrain-sand.png', iconOnly = false }) then
          log('set tool to sand')
        end
      end) -- terrain painter section


      ui.section("Obstacles", { defaultOpen = true }, function()
        ui.markdown([[Select obstacles to create:]])
        
        if ui.button('Wall', { icon = 'assets/ico-wall.png', iconOnly = false }) then
          log('set tool to WALL')
        end
        
        if ui.button('Bridge', { icon = 'assets/ico-bridge.png', iconOnly = false }) then
          log('set tool to WALL')
        end

      end) -- obstacles/objects section


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

    end)  -- editor tab
  end) -- tab control



uiEditorMode = ui.toggle("Editor OFF", "Editor ON", uiEditorMode, {onToggle = function(value)
  log("uiEditorMode = "..tostring(value))
  if value then
    -- todo: init editor?
  else
    -- TODO: refresh game data?
    scan_surface("courseCanvas")
  end
end})
gameMode = uiEditorMode and GAME_MODE.EDITOR or GAME_MODE.GAME


end
