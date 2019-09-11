--
-- The player start position (tee-off point)
--

Wall = BaseObject:extend()

function Wall:new(x,y)
  -- initialise base class/values
  Wall.super.new(self, x, y)
  self.name = "Wall"

  -- define collision object(s)
  self.collider = bf.Collider.new(world, "Polygon", 
             {-50, -2.5, 
               50, -2.5,
               50,  2.5, 
              -50,  2.5})
  self.collider.parent = self -- important for UI collisions
  self.collider:setPosition(self.x, self.y)
  self.collider:setLinearDamping(1000) -- Make it so it doesn't "move" from spot
  --self.collider:setAngle(math.rad(-45))
  
  -- define collision callbacks
  function self.collider:enter(other)
    log("enter!!!! "..tostring(other == cursorCollider))
    return
  end
  function self.collider:exit(other)
    log("exit!!!!"..tostring(other == cursorCollider))
    return
  end

end


function Wall:update(dt)
  -- reset states for this frame
  self.hovered = false

  -- anything here?
  self.collider:setPosition(self.x, self.y)

  -- TEST: Make block spin!
  self.collider:setAngularVelocity(-2) 
end

function Wall:draw(inEditMode)
  -- todo: overwrite default physics draw code

  
  -- block1.draw = function(alpha)
  --   -- do nothing - draw done elsewhere
  -- end  
end

-- function Wall:hover()
--   log("WALL hover!")
-- end

--
-- render object's own properties
--
function Wall:uiProperties()
  -- TODO: Draw this object's property section
  uiRow('position', function()
    self.x = ui.numberInput('x-pos', self.x)
  end, function()
    self.y = ui.numberInput('y-pos', self.y)
  end) --row
  uiRow('position', function()  
    self.r = ui.slider('rot', self.r, 0, 1, { step=0.025 })
  end) --row
end