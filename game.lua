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
  world = bf.newWorld(0, 0, true)
  --world = bf.newWorld(0, 90.81, true)
  -- bf.World:new also works
  -- any function of love.physics.world should work on World
  local gx,gy = world:getGravity()
  log("gravity = "..gx..","..gy)



  -- capture course image data (cols for terrain types)

  player = Player:new(PLAYER_STARTX, PLAYER_STARTY)

  -- add a temp physics obstacle
  block1 = bf.Collider.new(world, "Polygon", 
             {0, 100, 150, 100 , 150, 105, 0, 105})
  --block1:setType("static")
  block1:setPosition(50, 120)
  block1:setAngle(math.rad(-45))
  block1:setAngularVelocity(-2) -- Make it spin!
  block1:setLinearDamping(1000) -- Make it so it doesn't "move"
                 
  -- ground = bf.Collider.new(world, "Polygon",
  --               {0, 150, 250, 150 , 250, 250, 0, 250})
  -- ground:setType("static")
end


function updateGame(dt)

  block1:setAngularVelocity(-2) -- Make it spin!

  world:update(dt)
  player:update(dt)
end

-- draw 
function drawGame()
  world:draw()
  player:draw()
end


