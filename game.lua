-- 
-- Core golf game class (movement, collision, etc.)
--

Player = require "Player"


local player={}
local hole={}
local obstacles={}    -- walls, bumpers, etc.
local coursePixels={} -- used to determine greens, rough, water, etc.
local terrain={}      -- slopes?


function initGame(levelData)  
  -- todo: construct level objects from data passed


  
  -- -------------------------------------------------------
  -- init physics
  -- -------------------------------------------------------
  world = bf.newWorld(0, 9.81, true)
  --world = bf.newWorld(0, 90.81, true)
  -- bf.World:new also works
  -- any function of love.physics.world should work on World
  local gx,gy = world:getGravity()
  log("gravity = "..gx..","..gy)



  -- capture course image data (cols for terrain types)

  player = Player:new(PLAYER_STARTX, PLAYER_STARTY)

  -- add a temp physics obstacle
  block1 = bf.Collider.new(world, "Polygon", 
                {150, 375, 250, 375,
					       250, 425, 150, 425})
end


function updateGame(dt)
  world:update(dt)
  player:update(dt)
end

-- draw 
function drawGame()
  world:draw()
  player:draw()
end