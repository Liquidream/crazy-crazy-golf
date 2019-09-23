--
-- Bridges can be putted across to join land masses together
--

Bridge = BaseObject:extend()

function Bridge:new(x, y, data)
  -- initialise base class/values
  data = data or {} -- default to empty obj if no data passed
  Bridge.super.new(self, x, y, 7, 100, 0.25, data)  
  self.name = "Bridge"
  self.type = OBJ_TYPE.BRIDGE
  self.can_delete = true
  self.can_copy = true

  -- define collision object(s)
  self.collider = bf.Collider.new(world, 
          "Rectangle", self.x, self.y, 32, 64 )
  self:setRotation(self.r)
  self.collider.parent = self -- important for UI collisions  
  self.collider:setCategory(1)

  self.collider.draw = function(alpha)
    -- draw sprite
    aspr(6, 
    self.x, 
    self.y, 
    self.r,
    2, 4)

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
end

-- serialise for storage
function Bridge:getData()
  local data = Bridge.super.getData(self)
  data.type = self.type
  return data
end


function Bridge:update(dt)
  -- update base class/values
  Bridge.super.update(self, dt)

end

-- rotate (using turn-based angles)
function Bridge:setRotation(angle)
  self.r = angle
  self.collider:setAngle(self.r * (2*math.pi))
end



--
-- render object's own properties
--
function Bridge:uiProperties()
  if uiEditorMode then
    -- Draw this object's property section
    uiRow('position', function()
      self.x = ui.numberInput('x-pos', self.x)
    end, function()
      self.y = ui.numberInput('y-pos', self.y)
    end) --row

    -- uiRow('position', function()
    --   self.w = ui.numberInput('width', self.w, { onChange=function(value)
    --     -- rebuild collision object(s)
    --     self:rebuildCollisions()
    --   end })
    -- end, function()
    --   self.h = ui.numberInput('height', self.h, { onChange=function(value)
    --     -- rebuild collision object(s)
    --     self:rebuildCollisions()
    --   end })
    -- end) --row

    uiRow('position', function()  
      self.r = ui.slider('rot', self.r, 0, 1, { step=0.025 })
      self.collider:setAngle(self.r * (2*math.pi))
    end) --row
    uiRow('position', function()
      
    end) --row
  end
end