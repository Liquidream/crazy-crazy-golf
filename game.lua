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

  -- capture course image data (cols for terrain types)

  player = Player:new(100,200)
end


function updateGame(dt)
  player:update(dt)
end

-- draw 
function drawGame()
  player:draw()
end