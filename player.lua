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
  -- TODO: Needs to be a sprite!
  circfill(self.x, self.y,2, 46)
  --circ(self.x+20, self.y, 2, 46) --11
end


return Player