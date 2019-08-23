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

  -- physics related
  o.collider = bf.Collider.new(world, "Circle", x, y, 20)
  o.collider.draw = function(alpha)
    -- do nothing - draw done elsewhere
  end
  o.collider:setRestitution(0.8) -- make bounce? (any function of shape/body/fixture works)

  -- object related
  self.__index = self;
  setmetatable(o, self);
  return o;
end


function Player:update(dt)
  self.x = self.collider:getX()
  self.y = self.collider:getY()
  -- ---------------------------------------
  -- Input handling
  -- ---------------------------------------
  -- aiming
  local rotateSpeed = 0.01
  if btn(0) then self.aim = self.aim - rotateSpeed end
  if btn(1) then self.aim = self.aim + rotateSpeed end

  -- taking a shot
  if btnp(4) then 
    local speed = 300
    self.collider:applyLinearImpulse(
      cos(self.aim) * speed,
      sin(self.aim) * speed)     
    -- self.dx = cos(self.aim) * speed
    -- self.dy = sin(self.aim) * speed
  end

  -- ---------------------------------------
  -- Physics updates
  -- ---------------------------------------
  -- Move ball based on current inertia
  -- self.x = self.x + self.dx
  -- self.y = self.y + self.dy
  
  -- apply drag
  local drag = 2
  -- (check terrain)
  local col = sget(self.x,self.y,"courseCanvas")
  
  if col == 7 then 
    -- rough
    drag = 5
  elseif col == 45 then 
    -- sand
    drag = 10
  end

  -- TODO: Use applyForce here (apply drag / to adjust direction)

  local sx, sy = self.collider:getLinearVelocity()  
  local dx = -sx * drag
  local dy = -sy * drag
  --local fx = -sx * self.collider.worldAirResistance -- the drag *force* is opposite and proportional to the velocity
  self.collider:applyForce(dx, dy)

  -- self.dx = self.dx * drag
  -- if abs(self.dx)<0.001 then self.dx = 0 end
  -- self.dy = self.dy * drag
  -- if abs(self.dy)<0.001 then self.dy = 0 end

  -- check for water
  if col == 0 then
    -- restart level
    self:setPos(PLAYER_STARTX, PLAYER_STARTY)
    --self.x, self.y = PLAYER_STARTX, PLAYER_STARTY
    --self.dx, self.dy = 0,0
  end
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
  -- circfill(self.x, self.y+1,2, 0)
  -- circfill(self.x, self.y,2, 46)
  
end


function Player:setPos(x,y)
  self.collider:setPosition(PLAYER_STARTX, PLAYER_STARTY)
  self.collider:setLinearVelocity(0,0)
end

return Player