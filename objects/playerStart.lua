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
  rectfill(self.x, self.y, self.x+self.w, self.y+self.h, 11)
end