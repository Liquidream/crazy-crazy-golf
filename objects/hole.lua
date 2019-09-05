--
-- The player start position (tee-off point)
--

Hole = BaseObject:extend()

function Hole:new(x,y)
  -- initialise base class/values
  PlayerStart.super.new(self, x, y)
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