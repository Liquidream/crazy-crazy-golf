--
-- The player start position (tee-off point)
--

Hole = BaseObject:extend()

function Hole:new(x,y)
  -- initialise base class/values
  PlayerStart.super.new(self, x, y)

   -- physics related
  self.collider = bf.Collider.new(world, "Circle", x, y, 2)
  self.collider.parent = self -- important for UI collisions  
  self.collider:setType("static")
  self.collider:setCategory(2)
  -- self.collider.draw = function(alpha)
  --   -- do nothing - draw done elsewhere
  -- end   
  -- define collision callbacks
  function self.collider:preSolve(other)
    log("preSolve hole!!!! "..tostring(other == cursorCollider))
    -- TODO: Need to find a way to detect collision WITHOUT it colliding (bouncing)
    -- (Prob something to do with setContact, but can't figure out how to do that with breezefield yet)    
    return restartHole
  end
  function self.collider:postSolve(other)
    log("preSolve hole!!!! "..tostring(other == cursorCollider))
    return
  end
  -- function self.collider:enter(other)
  --   log("enter hole!!!! "..tostring(other == cursorCollider))
  --   --restartHole()
  --   return restartHole
  -- end
  -- function self.collider:exit(other)
  --   log("exit hole!!!!"..tostring(other == cursorCollider))
  --   return
  
end


function Hole:update(dt)
  -- anything here?
end

function Hole:draw()
  -- TODO: draw the tee "block" sprite(s)  
  aspr(2, 
    self.x+1, 
    self.y-12, 
    self.r,
    1, 2)

  --circfill(self.x, self.y, 3, 20)
end

--
-- render object's own properties
--
function Hole:uiProperties()
  -- TODO: Draw this object's property section
  uiRow('position', function()
      self.x = ui.numberInput('x', self.x)
    end, function()
      self.y = ui.numberInput('y', self.y)
    end) --row
end