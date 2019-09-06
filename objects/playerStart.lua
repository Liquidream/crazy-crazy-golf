--
-- The player start position (tee-off point)
--

PlayerStart = BaseObject:extend()

function PlayerStart:new(x,y)
  -- initialise base class/values
  PlayerStart.super.new(self, x, y)
  self.name = "Player Start"
end


function PlayerStart:update(dt)
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
    self.r = ui.numberInput('rot', self.r, 
      { min=0, max=1, step=0.025 })
  end) --row
end