--
-- The player start position (tee-off point)
--

PlayerStart = BaseObject:extend()

function PlayerStart:new(x,y)
  -- initialise base class/values
  PlayerStart.super.new(self, x, y)
end


function PlayerStart:update(dt)
  -- anything here?
end

function PlayerStart:draw()
  -- TODO: draw the tee "block" sprite(s)
  aspr(0, 
    self.x, 
    self.y, 
    self.r,
    2, 3)
end