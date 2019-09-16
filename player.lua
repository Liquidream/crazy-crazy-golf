--
-- The player (golf ball + aiming, controls, etc.)
--

Player = BaseObject:extend()
--Player = {}

function Player:new(x,y)
  Player.super.new(self, x, y)
  self.name = "Player"

  self.dx = 0
  self.dy = 0
  self:Reset()

  -- physics related
  self.collider = bf.Collider.new(world, "Circle", x, y, 2)
  self.collider.parent = self -- important for UI collisions  
  self.collider:setMask(1) -- don't collide with "non-colliding" objects
  self.collider.draw = function(alpha)
    -- do nothing - draw done elsewhere
  end
  self.collider:setRestitution(0.8) -- make bounce? (any function of shape/body/fixture works)
end


function Player:update(dt)
  -- update base class/values
  Player.super.update(self, dt)

  self.x = self.collider:getX()
  self.y = self.collider:getY()
  -- ---------------------------------------
  -- Input handling
  -- ---------------------------------------
  -- aiming
  local rotateSpeed = 0.005
  if btn(0) and not self.shooting then self.r = self.r - rotateSpeed end
  if btn(1) and not self.shooting then self.r = self.r + rotateSpeed end

  -- taking a shot
  local speed = 10
  local shootBtn = btn(4)
  if shootBtn
   and not self.isMoving then 
    -- swinging/shooting
    self.shooting = true
    self.power = min(self.power + (speed/50), speed)    

  elseif self.shooting 
   and not shootBtn then
    -- released button
    self.collider:applyLinearImpulse(
          cos(self.r) * self.power,
          sin(self.r) * self.power)
    self.shooting = false
    self.power = 0
  end

  lastShootBtn = shootBtn


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
      restartHole()
    end
  end
end

-- draw 
function Player:draw()
  
  if not self.isMoving then 
    -- draw aiming dir
    local length = self.shooting and self.power*3 or 30
    local aim_dx = cos(self.r) * length
    local aim_dy = sin(self.r) * length
    line(self.x, self.y,
          self.x + aim_dx,
          self.y + aim_dy,
          37)
  end

  -- draw shadow
  circfill(self.x, self.y+1, 2, 21)
  -- draw player (ball) sprite
  spr(3, self.x-2, self.y-2)
end

function Player:Reset()
  self.power = 0
  self.shooting = false
end

function Player:setPos(x,y)
  Player.super.moveTo(self, x, y)
  self.collider:setLinearVelocity(0,0)
end
