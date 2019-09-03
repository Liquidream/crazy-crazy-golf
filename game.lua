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
  block1:setPosition(150, 150)
  block1:setAngle(math.rad(-45))
  block1:setAngularVelocity(-2) -- Make it spin!
  block1:setLinearDamping(1000) -- Make it so it doesn't "move"
  -- block1.draw = function(alpha)
  --   -- do nothing - draw done elsewhere
  -- end                 
  -- ground = bf.Collider.new(world, "Polygon",
  --               {0, 150, 250, 150 , 250, 250, 0, 250})
  -- ground:setType("static")
end


function updateGame(dt)

  -- TEST: Make block spin!
  block1:setAngularVelocity(-2) 

  -- update physics objects
  world:update(dt)

  -- update player (controls, movement/pos, state, etc.)
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
  
  -- draw current course data
  spr_sheet("courseCanvas", 0, 0)

  -- draw all physics objects
  world:draw()

  -- draw player
  player:draw()
end


