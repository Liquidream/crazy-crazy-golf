-- 
-- Core golf game class (movement, collision, etc.)
--

require "Player"


function initGame(levelData)  
  --player={}
  --hole={}
  obstacles={}    -- walls, bumpers, etc.
  coursePixels={} -- used to determine greens, rough, water, etc.
  terrain={}      -- slopes?
  
  
  -- todo: construct level objects from data passed



  -- -------------------------------------------------------
  -- init physics
  -- -------------------------------------------------------
  world = bf.newWorld(0, 0, true)
  -- bf.World:new also works
  -- any function of love.physics.world should work on World
  local gx,gy = world:getGravity()
  log("gravity = "..gx..","..gy)


  -- capture course image data (cols for terrain types)
  
  -- Player related
  --player = Player(PLAYER_STARTX, PLAYER_STARTY)
  playerStart = PlayerStart(PLAYER_STARTX, PLAYER_STARTY)
  
  -- Hole related
  hole = Hole(445,55)
  --hole = Hole(PLAYER_STARTX+50,PLAYER_STARTY)

  -- Wall temporary test
  --wall = Wall(304,164)
  --wall.spin = -2
  --table.insert(obstacles, wall)

  -- Wall serialization test
  network.async(function()
    log("before storage get")
    local data = castle.storage.get("courseDataTest")
    log("after storage get")
    wall = Wall(nil,nil,data)
    table.insert(obstacles, wall)
  end)  
                 
  -- ground = bf.Collider.new(world, "Polygon",
  --               {0, 150, 250, 150 , 250, 250, 0, 250})
  -- ground:setType("static")

  -- Now reset all the states + player pos
  restartHole()

  -- DEBUG: Test!!!  
  --selectedObj = wall

end

function restartHole()
  if player then
    player:setPos(playerStart.x, playerStart.y)
    player:Reset()
  else
    player =  Player(playerStart.x, playerStart.y)
  end
  player.r = playerStart.r
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
  for k,obj in pairs(obstacles) do
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
    -- draw the hole
    hole:draw()
    -- draw all physics objects
    world:draw()
    -- draw player
    player:draw()

  else
    log("loading...")
    pprintc("Loading...", GAME_HEIGHT/2, 8)
  end
end


