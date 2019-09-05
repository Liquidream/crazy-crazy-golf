-- 
-- Core golf game class (movement, collision, etc.)
--

require "Player"


function initGame(levelData)  
  player={}
  hole={}
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
  player = Player(PLAYER_STARTX, PLAYER_STARTY)
  playerStart = PlayerStart(PLAYER_STARTX, PLAYER_STARTY)  
  playerStart.r = 0.125 -- TODO: set angle from properties
  
  -- Hole related
  hole = Hole(445,55)

  -- add a temp physics obstacle
  block1 = bf.Collider.new(world, "Polygon", 
             {0, 100, 150, 100 , 150, 105, 0, 105})
  --block1:setType("static")
  block1:setPosition(150, 150)
  block1:setAngle(math.rad(-45))
  block1:setAngularVelocity(-2) -- Make it spin!
  block1:setLinearDamping(1000) -- Make it so it doesn't "move"
  table.insert(obstacles, block1)
  
  -- block1.draw = function(alpha)
  --   -- do nothing - draw done elsewhere
  -- end                 
  -- ground = bf.Collider.new(world, "Polygon",
  --               {0, 150, 250, 150 , 250, 250, 0, 250})
  -- ground:setType("static")

  -- DEBUG: Test!!!
  selectedObj = playerStart
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
  -- draw player start tee
  playerStart:draw()
  -- draw the hole
  hole:draw()
  -- draw all physics objects
  world:draw()
  -- draw player
  player:draw()
end


