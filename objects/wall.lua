--
-- The player start position (tee-off point)
--

Wall = BaseObject:extend()

function Wall:new(x, y, data)
  -- initialise base class/values
  data = data or {} -- default to empty obj if no data passed
  Wall.super.new(self, x, y, 7, 100, 0, data)
  self.name = "Wall"
  self.spin = data.spin or 0

  -- define collision object(s)
  self:rebuildCollisions()
end

-- serialise for storage
function Wall:getData()
  local data = Wall.super.getData(self)
  data.spin = self.spin
  return data
end

function Wall:rebuildCollisions()
  -- define collision object(s)
  local half_w = self.w/2
  local half_h = self.h/2

  if self.collider then
    --world:remove(self.collider)
    self.collider:destroy()
  end

  --if self.collider == nil then
    self.collider = bf.Collider.new(world, "Polygon", 
              {-half_h, -half_w, 
                half_h, -half_w,
                half_h,  half_w, 
                -half_h,  half_w})
    self.collider.parent = self -- important for UI collisions
    self.collider:setPosition(self.x, self.y)
    self.collider:setLinearDamping(1000) -- Make it so it doesn't "move" from spot
    self.collider:setCategory(2)

    self.collider.draw = function(alpha)
        -- draw shadow
        aspr(5, 
          self.x, 
          self.y+2, 
          self.r-0.25,
          1, 3,
          0.5,0.5,
          self.w/16, self.h/48)      
        --pal()
        aspr(4, 
          self.x, 
          self.y, 
          self.r-0.25,
          1, 3,
          0.5,0.5,
          self.w/16, self.h/48)

      -- draw collision bounds    
      if uiEditorMode then      
        local mode = 'line'
        -- if self == selectedObj then
        --   love.graphics.setColor(1, 1, 1) 
        -- elseif self.hovered then 
      if self.hovered then 
          love.graphics.setColor(1, 0, 0) 
        else
          love.graphics.setColor(0, 0, 0) 
        end
        love.graphics[self.collider.collider_type:lower()](mode, self.collider:getSpatialIdentity())
      end
    end
    -- define collision callbacks
    -- function self.collider:enter(other)
    --   log("enter!!!! "..tostring(other == cursorCollider))
    --   return
    -- end
    -- function self.collider:exit(other)
    --   log("exit!!!!"..tostring(other == cursorCollider))
    --   return
    -- end

  -- else
  --   -- just refresh dimensions
  --   self.collider
  -- end
end


function Wall:update(dt)
  -- update base class/values
  Wall.super.update(self, dt)

  -- Keep block spinning (or not)  
  self.collider:setAngularVelocity(self.spin)
  if self.spin == 0 then
    self.collider:setType("static")
  else
    self.collider:setType("dynamic")
  end
  -- sync rotation
  self.r = self.collider:getAngle()/(2*math.pi)

end


--
-- render object's own properties
--
function Wall:uiProperties()
  if uiEditorMode then
    -- Draw this object's property section
    uiRow('position', function()
      self.x = ui.numberInput('x-pos', self.x)
    end, function()
      self.y = ui.numberInput('y-pos', self.y)
    end) --row

    uiRow('position', function()
      self.w = ui.numberInput('width', self.w, { onChange=function(value)
        -- rebuild collision object(s)
        self:rebuildCollisions()
      end })
    end, function()
      self.h = ui.numberInput('height', self.h, { onChange=function(value)
        -- rebuild collision object(s)
        self:rebuildCollisions()
      end })
    end) --row

    uiRow('position', function()  
      self.r = ui.slider('rot', self.r, 0, 1, { step=0.025 })
      self.collider:setAngle(self.r * (2*math.pi))
    end) --row
    uiRow('position', function()
      self.spin = ui.slider('spin', self.spin, -3, 3, { step=0.25 })
    end) --row
  end
end