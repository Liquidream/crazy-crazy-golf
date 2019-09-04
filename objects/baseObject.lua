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
end

function BaseObject:update(dt)
    --self.x = self.x + self.speed * dt
end


-- draw?