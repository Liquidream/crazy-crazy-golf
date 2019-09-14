--
-- Base object properties, shared by all obstacles, etc.
--
BaseObject = Object:extend()

function BaseObject:new(x, y,   
                        r, w, h)
    self.x = x        -- x position in the game
    self.y = y        -- y pos    
    self.r = r or 0   -- rotation angle (turn-based, 0=right, 0.25=top, etc.)
    self.w = w or 20  -- width
    self.h = h or 20  -- height
    self.name = ""
    self.collider = nil
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

-- draw?