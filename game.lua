-- 
-- Core golf game class (movement, collision, etc.)
--

require "objects/player"


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
  -- todo: load hole data
  loadHole(holeData)

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

  if hole == nil then
    -- abort now, as nothing to update!
    --log("hole = nil, abort updateGame()")
    return
  end
  
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

    if hole == nil then
      -- abort now, as nothing to draw!
      log("hole = nil, abort drawGame()")
      return
    end

    -- draw all bridge "shadows"
    for k,obj in pairs(hole.obstacles) do
      if obj.type == OBJ_TYPE.BRIDGE then obj:draw(1) end
    end    
    -- draw current course data
    spr_sheet("courseCanvasAllData", 0, 0)

    -- draw all bridges "sprites"
    for k,obj in pairs(hole.obstacles) do
      if obj.type == OBJ_TYPE.BRIDGE then obj:draw(3) end
    end
    
    -- draw all physics objects
    world:draw()
    -- draw player
    if player then 
      player:draw()
    end

  else
    pprintc("Loading...", GAME_HEIGHT/2, 8)
  end
end


function drawWater()
  cls(27)

  -- seed random number generation
  -- (so that subsequent random numbers are consistent, every frame)
  srand()

  -- draw ripples
  for i=1,50 do
    -- random x pos
    local x=rnd(GAME_WIDTH)
    -- random y pos (+ some oscilation)
    local y=rnd(GAME_HEIGHT) + sin(t()+10*i)/2
    -- random width
    local w=rnd(10)+5
    -- draw ripple (with a random highlight)
    line(x, y, x+w, y, ((rnd(10)<3) and 12 or 20))
  end

  -- "shimmer" movement
  -- draw a lot of circles, same as water colour
  -- and scroll them across (and down) the screen
  -- to give the illusion of movement
  for i=1,750 do
    local shift=t()*20
    local x=(rnd(GAME_WIDTH)+shift*2)%GAME_WIDTH
    local y=(rnd(GAME_HEIGHT)+shift)%GAME_HEIGHT
    circfill(x, y, rnd(20)+2, 27)
  end
end