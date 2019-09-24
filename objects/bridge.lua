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
  
  -- "I am..."
  self.collider:setCategory(OBJ_TYPE.BRIDGE) 
  -- "I do not collide with..."
  self.collider:setMask(OBJ_TYPE.PLAYER, OBJ_TYPE.PLAYER_START, OBJ_TYPE.HOLE, OBJ_TYPE.WALL)

  self.collider.draw = function(alpha)
    -- do nothing (all done in draw method)
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

function Bridge:draw(layerNum)
  -- draw a specific layer of bridge
  -- 1 = shadow shape       (on water)
  -- 2 = terrain pixel data (smooth, like green - no drag)
  -- 3 = texture sprite     (actual bridge image)
  if layerNum == 1 then
    pal(53, 28)  -- draw shape as "green" pixel data
    pal(52, 28)  --
    aspr(6, self.x+6, self.y+6, self.r, 2, 4)
  elseif layerNum == 2 then
    pal(53, 8)  -- draw shape as "green" pixel data
    pal(52, 8)  --
    aspr(6, self.x, self.y, self.r, 2, 4)
  elseif layerNum == 3 then
   -- draw sprite
   pal()
   aspr(6, self.x, self.y, self.r, 2, 4)
  end
  pal()


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

    uiRow('position', function()  
      self.r = ui.slider('rot', self.r, 0, 1, { step=0.025 })
      self.collider:setAngle(self.r * (2*math.pi))
    end) --row
    uiRow('position', function()
      
    end) --row
  end
end