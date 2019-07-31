--
-- The player (golf ball + aiming, controls, etc.)
--

Player = {}

function Player:new(x,y)
  -- todo: 
  local o = {};
  o.x = x;
  o.y = y;
  -- o.cacheSize = cacheSize or 2;
  
  -- object related
  self.__index = self;
  setmetatable(o, self);
  return o;
end


function Player:update(dt)
end

-- draw 
function Player:draw()
  circfill(self.x, self.y, 5, 1)
end


return Player