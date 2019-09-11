--
-- The player (golf ball + aiming, controls, etc.)
--

Player = BaseObject:extend()
--Player = {}

function Player:new(x,y)
  Player.super.new(self, x, y)
  self.name = "Player"

  self.r = 0; -- aim (in turns-based angles)
  self.dx = 0;
  self.dy = 0;

  -- physics related
  self.collider = bf.Collider.new(world, "Circle", x, y, 2)
  self.collider.parent = self -- important for UI collisions
  self.collider.draw = function(alpha)
    -- do nothing - draw done elsewhere
  end
  self.collider:setRestitution(0.8) -- make bounce? (any function of shape/body/fixture works)

  -- local o = {};
  -- o.x = x;
  -- o.y = y;
  -- o.aim = 0; -- aim (in turns-based angles)
  -- o.dx = 0;
  -- o.dy = 0;

  -- -- physics related
  -- o.collider = bf.Collider.new(world, "Circle", x, y, 2)
  -- o.collider.draw = function(alpha)
  --   -- do nothing - draw done elsewhere
  -- end
  -- o.collider:setRestitution(0.8) -- make bounce? (any function of shape/body/fixture works)

  -- -- object related
  -- self.__index = self;
  -- setmetatable(o, self);
  -- return o;
end


function Player:update(dt)
  self.x = self.collider:getX()
  self.y = self.collider:getY()
  -- ---------------------------------------
  -- Input handling
  -- ---------------------------------------
  -- aiming
  local rotateSpeed = 0.01
  if btn(0) then self.r = self.r - rotateSpeed end
  if btn(1) then self.r = self.r + rotateSpeed end

  -- taking a shot
  local speed = 5
  if btnp(4) and not self.isMoving then 
    self.collider:applyLinearImpulse(
      cos(self.r) * speed,
      sin(self.r) * speed)     
    -- self.dx = cos(self.aim) * speed
    -- self.dy = sin(self.aim) * speed
  end

  -- ---------------------------------------
  -- Physics updates
  -- ---------------------------------------
  
  -- determine drag surface
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

  
  local sx, sy = self.collider:getLinearVelocity()  
  self.isMoving = abs(sx) > 0 or abs(sy) > 0

  -- if moving...
  if self.isMoving then
    -- apply drag (based on course surface)
    local dx = -sx * (drag/100)
    local dy = -sy * (drag/100)  
   
    -- Come to complete stop
    if abs(dx)<0.01 and abs(dy)<0.01 then 
      self.collider:setLinearVelocity(0, 0)
    end

    -- check for water
    if col ~= 0 then
      self.collider:applyForce(dx, dy)
    else
      -- restart level
      self:setPos(PLAYER_STARTX, PLAYER_STARTY)
    end
  end
end

-- draw 
function Player:draw()
  
  if not self.isMoving then 
    -- draw aiming dir
    local length = 30
    local aim_dx = cos(self.r) * length
    local aim_dy = sin(self.r) * length
    line(self.x, self.y,
          self.x + aim_dx,
          self.y + aim_dy,
          37)
  end

  -- TODO: Needs to be a sprite!
  circfill(self.x, self.y+1, 2, 21)
  --circfill(self.x, self.y,   2, 46)
  spr(3, self.x-2, self.y-2)
end


function Player:setPos(x,y)
  self.collider:setPosition(PLAYER_STARTX, PLAYER_STARTY)
  self.collider:setLinearVelocity(0,0)
end
