--
-- The player (golf ball + aiming, controls, etc.)
--

Player = {}

function Player:new(x,y)
  -- todo: 
  local o = {};
  o.x = x;
  o.y = y;
  o.aim = 0; -- aim (in turns-based angles)
  o.dx = 0;
  o.dy = 0;

  -- object related
  self.__index = self;
  setmetatable(o, self);
  return o;
end


function Player:update(dt)
  -- ---------------------------------------
  -- Input handling
  -- ---------------------------------------
  -- aiming
  local rotateSpeed = 0.01
  if btn(0) then self.aim = self.aim - rotateSpeed end
  if btn(1) then self.aim = self.aim + rotateSpeed end

  -- taking a shot
  if btnp(4) then 
    local speed = 10
    self.dx = cos(self.aim) * speed
    self.dy = sin(self.aim) * speed

    log("self.dx = "..self.dx)
    log("self.dy = "..self.dy)
  end

  -- ---------------------------------------
  -- Physics updates
  -- ---------------------------------------
  -- Move ball based on current inertia
  self.x = self.x + self.dx
  self.y = self.y + self.dy
  
  -- apply drag
  self.dx = self.dx * 0.9
  if abs(self.dx)<0.001 then self.dx = 0 end
  self.dy = self.dy * 0.9
  if abs(self.dy)<0.001 then self.dy = 0 end
end

-- draw 
function Player:draw()
  local isMoving = abs(self.dx) > 0 or abs(self.dy) > 0
  
  if not isMoving then 
    -- draw aiming dir
    local length = 30
    local aim_dx = cos(self.aim) * length
    local aim_dy = sin(self.aim) * length
    line(self.x, self.y,
          self.x + aim_dx,
          self.y + aim_dy,
          37)
  end

  -- TODO: Needs to be a sprite!
  circfill(self.x, self.y+1,2, 0)
  circfill(self.x, self.y,2, 46)
  
end


return Player