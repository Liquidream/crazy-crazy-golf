
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

-- UI-bound/global vars
uiEditorMode = false


function castle.uiupdate()

  
  --ui.markdown('![](assets/title-text.png)')   
  ui.markdown([[
## CrAzY CrAzY Golf
The craziest crazy golf! 🤪
  ]])


  --log("in gameMode = "..gameMode)

  ui.tabs('main', { selected = gameMode }, function()
    uiPlayMode = ui.tab('⛳ Play Mode', function()
      -- ================================================
      -- ==  PLAY MODE
      -- ================================================

      if post then
        ui.markdown("##Hole #"..post.postId.."")

        ui.markdown("###\""..post.data.name.."\"")

        ui.markdown("**Par "..post.data.par.."**")

        if player then
          ui.markdown("Shots "..player.shots)
        end

        ui.markdown("![]("..post.mediaUrl..")")
      end

      if ui.button('Restart Hole', {  }) then
          -- reset/restart hole 
          -- TODO: Disable in multiplayer?          
          restartHole()
      end

    end)
    uiEditorMode = ui.tab('🎨 Editor Mode', function()
      -- ================================================
      -- ==  EDITOR MODE
      -- ================================================
      ui.markdown([[### Hole Editor]])
    
      -- bail out now, if no hole data
      if hole == nil then
        return
      end

      -- ---------------------------------
      -- General Options
      -- ---------------------------------
      local inOpen = 3 == currTool
      local outOpen = ui.section("⚙ Hole Settings", { open = inOpen  }, function()
        ui.markdown([[General settings]])
        
        hole.name = ui.textInput("Hole Name", hole.name, {})
        hole.description = ui.textArea("Description", hole.description, {})
        uiRow('position', function()
          hole.par = ui.numberInput("Par", hole.par, { min = 1, max = 5 })
        end, function()
          --
        end) --row
      end) -- general options section      
      if outOpen and not inOpen then
        currTool = 3  -- General Options mode?
      end

      -- ---------------------------------
      -- Terrain / Landscape
      -- ---------------------------------
      local inOpen = 1 == currTool
      local outOpen = ui.section("🌄 Terrain Landscape", { open = inOpen  }, function()
        ui.markdown([[Choose Terrain to paint:]])
        
        local label = 'Sand Trap'
        if currTerrainLayer==3 then label = "▶ "..label end          
        if ui.button(label, { icon = 'assets/ico-terrain-sand.png', iconOnly = false, kind=(currTerrainLayer==3 and 'primary' or 'secondary') }) then
          log('set tool to sand')
          currTerrainLayer = 3
        end
          
        local label = 'Fairway/Green'
        if currTerrainLayer==2 then label = "▶ "..label end          
        if ui.button(label, { icon = 'assets/ico-terrain-green.png', iconOnly = false, kind=(currTerrainLayer==2 and 'primary' or 'secondary')}) then
          log('set tool to grass')
          currTerrainLayer = 2
        end

        local label = 'Rough'
        if currTerrainLayer==1 then label = "▶ "..label end        
        if ui.button(label, { icon = 'assets/ico-terrain-rough.png', iconOnly = false, kind=(currTerrainLayer==1 and 'primary' or 'secondary') }) then
          log('set tool to rough')
          currTerrainLayer = 1
        end
        
        -- Size
        terrainBrushSize = ui.slider("Size", terrainBrushSize, 1, 50, { })
        
      end) -- terrain painter section
      if outOpen and not inOpen then
        currTool = 1  -- Terrain "painting" mode
      end
        

      -- ---------------------------------
      -- Objects / Obstacles
      -- ---------------------------------
      local inOpen = 2 == currTool
      local outOpen = ui.section("🧱 Objects / Obstacles", {open = inOpen }, function()
        ui.markdown([[Select objects to create:]])
        
        uiRow('position', function()
          if ui.button('Wall', { icon = 'assets/ico-wall.png', iconOnly = false }) then
            log('create new WALL')
            local wall = Wall(GAME_WIDTH/2, GAME_HEIGHT/2)
            table.insert(hole.obstacles, wall)
            selectedObj = wall
          end

        end, function()
          if ui.button('Bridge', { icon = 'assets/ico-bridge.png', iconOnly = false }) then
            log('create new BRIDGE')
            local bridge = Bridge(GAME_WIDTH/2, GAME_HEIGHT/2)
            table.insert(hole.obstacles, bridge)
            selectedObj = bridge
          end
        end) --row

          
        -- 
        -- PROPERTIES?
        -- 
        if selectedObj then
          ui.section((selectedObj.name and (selectedObj.name.." ") or "").."Properties", { defaultOpen = true }, function()          
            if selectedObj.uiProperties then
              -- draw this object's properties
              selectedObj:uiProperties()
              -- other actions
              uiRow('position', function()
                -- --------------- 
                -- copy?
                -- ---------------
                if selectedObj.can_copy then
                  if ui.button('Duplicate', { kind='primary'} ) then
                    dupeObj = createObjFromData(selectedObj:getData())
                    -- -- which object type??
                    -- local dupeObj
                    -- if selectedObj.type == OBJ_TYPE.WALL then 
                    --   dupeObj = Wall(nil, nil, selectedObj:getData()) 
                    -- elseif selectedObj.type == OBJ_TYPE.BRIDGE then 
                    --   dupeObj = Bridge(nil, nil, selectedObj:getData()) 
                    -- end
                    dupeObj.x = dupeObj.x + 25
                    dupeObj.y = dupeObj.y + 25
                    table.insert(hole.obstacles, dupeObj)
                    selectedObj = dupeObj
                  end
                end

              end, function()

                 -- --------------- 
                -- deleteable?
                -- ---------------
                if selectedObj.can_delete then
                  if ui.button('Delete', { kind='danger'} ) then
                    -- delete obj
                    selectedObj.collider:destroy()
                    ArrayRemove(hole.obstacles, function(t, i, j)
                        -- Return true to keep the value, or false to discard it.
                        return (t[i] ~= selectedObj)
                    end)
                    --table.remove(hole.obstacles, selectedObj)
                    selectedObj = nil
                  end
                end
                
              end) --row
              
             
            else
              ui.markdown([[#### No properties]])
            end
          end) 
        end
        
      end) -- obstacles/objects section
      if outOpen and not inOpen then
        currTool = 2 -- Object mode (cursor/select objects)
      end


      
      ui.section("📚 Main Menu", { defaultOpen = true }, function()
          
        if ui.button('💾 Save Hole') then
        -- TODO: save hole to Castle storage
          saveHole()
        end
        
        if ui.button('📂 Load Hole') then
          -- TODO: load hole to Castle storage
          loadHole()
        end
        
        -- if DEBUG_MODE then
        --   if ui.button('Export Hole') then
        --     -- export course to local storage (disk)
        --     exportHole()
        --   end
        --   if ui.button('Import Hole') then
        --     -- export course to local storage (disk)
        --     importHole()
        --   end
        -- end
          
        if ui.button('📤 Share Hole') then
          -- share course to via Castle post
          shareHole()
        end
        
        if ui.button('❌ Clear Hole') then
            -- reset current course data
            clearHole()
        end
        
      end) -- obstacles/objects section
        

        lastTool = currTool

    end)  -- editor tab
    
  end) -- tab control


  -- set the game mode
  gameMode = uiEditorMode and GAME_MODE.EDITOR or GAME_MODE.GAME

  -- changed since last frame
  if gameMode == GAME_MODE.GAME 
   and gameMode ~= lastGameMode
   and hole
  then
    -- just switched to game, so refresh level data
    -- TODO: refresh game data?
    -- refresh the obj collisions
    refreshPixelCollisions(hole)
    --scan_surface("courseCanvas")
  end

  lastGameMode = gameMode
end
