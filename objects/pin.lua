--
-- The player start position (tee-off point)
--

Pin = BaseObject:extend()

function Pin:new(x,y, data)
  -- initialise base class/values
  data = data or {} -- default to empty obj if no data passed
  Pin.super.new(self, x, y, 0,0,0, data)
  Pin.name = "Pin"

  -- which hole to go onto, after sinking the ball 
  -- (allows for multiple exit holes/paths)
  self.nextHoleId = nil 

   -- physics related
  self.collider = bf.Collider.new(world, "Circle", self.x, self.y, 2)
  self.collider.parent = self -- important for UI collisions  
  self.collider:setType("static")
  self.collider:setCategory(2)

  self.collider.draw = function(alpha)
    -- TODO: draw the tee "block" sprite(s)  
    aspr(2, 
    self.x+1, 
    self.y-13, 
    self.r,
    1, 2)

    -- draw collision bounds
    if uiEditorMode then
      local mode = 'line'
      if self.hovered then 
        love.graphics.setColor(1, 0, 0) 
      else
        love.graphics.setColor(0, 0, 0) 
      end
      love.graphics[self.collider.collider_type:lower()](mode, self.collider:getSpatialIdentity())
    end
  end   
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

-- serialise for storage
function Pin:getData()
  local data = Pin.super.getData(self)
  data.nextHoleId = self.nextHoleId
  return data
end

function Pin:update(dt)
  -- update base class/values
  Pin.super.update(self, dt)
  
  -- anything here?
end

-- function Pin:draw()
--   -- TODO: draw the tee "block" sprite(s)  
--   aspr(2, 
--     self.x+1, 
--     self.y-13, 
--     self.r,
--     1, 2)

--   --circfill(self.x, self.y, 3, 20)
-- end

--
-- render object's own properties
--
function Pin:uiProperties()
  -- Draw this object's property section
  uiRow('position', function()
      self.x = ui.numberInput('x', self.x)
    end, function()
      self.y = ui.numberInput('y', self.y)
    end) --row
end