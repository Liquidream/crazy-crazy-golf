-- 
-- Core golf game class (movement, collision, etc.)
--

require "player"


function initGame(holeData)
  -- -------------------------------------------------------
  -- init physics
  -- -------------------------------------------------------
  world = bf.newWorld(0, 0, true)
  -- bf.World:new also works
  -- any function of love.physics.world should work on World
  local gx,gy = world:getGravity()

  -- -------------------------------------------------------
  -- init hole
  -- -------------------------------------------------------
  -- create base hole structure
  -- (will populate from "data" later)
  hole = createHoleFromData(holeData)




  


  -- capture course image data (cols for terrain types)
    

  -- Wall serialization test
  -- network.async(function()
  --   log("before storage get")
  --   local data = castle.storage.get("courseDataTest")
  --   log("after storage get")
  --   wall = Wall(nil,nil,data)
  --   table.insert(obstacles, wall)
  -- end)

  -- Now reset all the states + player pos
  restartHole()
end


function restartHole()
  if player then
    player:setPos(hole.playerStart.x, hole.playerStart.y)
    player:Reset()
  else
    player =  Player(hole.playerStart.x, hole.playerStart.y)
  end
  player.r = hole.playerStart.r
  -- player = Player(playerStart.x, playerStart.y)
  -- player.r = playerStart.r
end

function winHole()
  -- TODO: Set gameState to "win", display message, score, etc.
end


function updateGame(dt)
  
  -- update physics objects
  world:update(dt)
  
  -- update objects (which needs to be called first?)
  -- TODO: review this!!!
  for k,obj in pairs(hole.obstacles) do
    obj:update(dt)
  end
  
  player:update(dt)
end

-- draw game/current hole
function drawGame()
  -- Make text more "readable"
  printp(0x2222, 
         0x2122, 
         0x2222, 
         0x0)
  printp_color(0, 0, 0)
  
  if not loadingProgress then
    -- draw current course data
    spr_sheet("courseCanvas", 0, 0)
    -- draw all physics objects
    world:draw()
    -- draw player
    player:draw()

  else
    pprintc("Loading...", GAME_HEIGHT/2, 8)
  end
end


