--
-- The player start position (tee-off point)
--

PlayerStart = BaseObject:extend()

function PlayerStart:new(x,y)
  -- initialise base class/values
  PlayerStart.super.new(self, x, y)
  self.name = "Player Start"


  -- define collision object(s)
  self.collider = bf.Collider.new(world, 
          "Rectangle", self.x,self.y, 16, 36  )
  self.collider.parent = self -- important for UI collisions  
  self.collider:setCategory(1)
  self.collider.draw = function(alpha)
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


function PlayerStart:update(dt)  
  -- update base class/values
  PlayerStart.super.update(self, dt)

  -- anything here?
end

function PlayerStart:draw(inEditMode)
  if not inEditMode then
    pal(46,10)
  end
  -- TODO: draw the tee "block" sprite(s)
  aspr(0, 
    self.x, 
    self.y, 
    self.r,
    2, 3)

    pal()
end

--
-- render object's own properties
--
function PlayerStart:uiProperties()
  -- TODO: Draw this object's property section
  uiRow('position', function()
    self.x = ui.numberInput('x-pos', self.x)
  end, function()
    self.y = ui.numberInput('y-pos', self.y)
  end) --row
  uiRow('position', function()  
    self.r = ui.slider('rot', self.r, 0, 1, { step=0.025 })
    self.collider:setAngle(self.r * (2*math.pi))
  end) --row
end