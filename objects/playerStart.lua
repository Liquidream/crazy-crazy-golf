--
-- The player start position (tee-off point)
--

PlayerStart = BaseObject:extend()

function PlayerStart:new(x,y, data)
  -- initialise base class/values
  data = data or {} -- default to empty obj if no data passed
  PlayerStart.super.new(self, x, y, 0,0,0, data)
  self.name = "Player Start"

  -- define collision object(s)
  self.collider = bf.Collider.new(world, 
          "Rectangle", self.x, self.y, 16, 36 )
  self:setRotation(self.r)
  self.collider.parent = self -- important for UI collisions  

  self.collider:setCategory(OBJ_TYPE.PLAYER_START)  -- "I am..."
  self.collider:setMask()                           -- "I collide with..."
  --self.collider:setCategory(1)

  self.collider.draw = function(alpha)
    -- draw sprite
    if not uiEditorMode then
      pal(46,10)
    end
    -- draw the tee "block" sprite(s)
    aspr(0, 
      self.x, 
      self.y, 
      self.r,
      2, 3)
  
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
end

-- serialise for storage
-- function PlayerStart:getData()
--   ### uses baseObject implementation
-- end


function PlayerStart:update(dt)  
  -- update base class/values
  PlayerStart.super.update(self, dt)

  -- anything here?
end

-- rotate (using turn-based angles)
function PlayerStart:setRotation(angle)
  self.r = angle
  self.collider:setAngle(self.r * (2*math.pi))
end

--
-- render object's own properties
--
function PlayerStart:uiProperties()
  -- Draw this object's property section
  uiRow('position', function()
    self.x = ui.numberInput('x-pos', self.x)
  end, function()
    self.y = ui.numberInput('y-pos', self.y)
  end) --row
  uiRow('position', function()  
    self:setRotation(
      ui.slider('rot', self.r, 0, 1, { step=0.025 })
    )
  end) --row
end