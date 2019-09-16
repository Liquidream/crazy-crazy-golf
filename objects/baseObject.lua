--
-- Base object properties, shared by all obstacles, etc.
--
BaseObject = Object:extend()

function BaseObject:new(x, y,   
                        w, h, r, data)
    data = data or {}           -- default to empty obj if no data passed
    self.x = data.x or x        -- x position in the game
    self.y = data.y or y        -- y pos    
    self.w = data.w or w        -- width
    self.h = data.h or h        -- height
    self.r = data.r or r or 0   -- rotation angle (turn-based, 0=right, 0.25=top, etc.)
    self.collider = nil
end

-- serialise for storage
function BaseObject:getData()
  local data = {}
  data.x = self.x
  data.y = self.y
  data.r = self.r
  data.w = self.w
  data.h = self.h
  return data
end

function BaseObject:update(dt)
  -- reset states for this frame
  self.hovered = false
  -- update position based on collisions
  if self.collider then
   if not uiEditorMode then
    self.x, self.y = self.collider:getPosition()
   else
    self.collider:setPosition(self.x, self.y)
   end
  end
end

function BaseObject:hover()
  self.hovered = true
  if DEBUG_MODE then
    --log(self.name.." hovered!")
  end
end

function BaseObject:moveTo(x, y)
  -- move object  
  self.x = x
  self.y = y
  -- move collision obj (if present)
  if self.collider then
    self.collider:setPosition(self.x, self.y)
  end
end
