
--
-- Constants
--

-- Andrew Kensler
-- https://lospec.com/palette-list/andrew-kensler-54
ak54 = {
    0x000000, 0x05fec1, 0x32af87, 0x387261,  
    0x1c332a, 0x2a5219, 0x2d8430, 0x00b716, 
    0x50fe34, 0xa2d18e, 0x84926c, 0xaabab3, 
    0xcdfff1, 0x05dcdd, 0x499faa, 0x2f6d82, 
    0x3894d7, 0x78cef8, 0xbbc6ec, 0x8e8cfd, 
    0x1f64f4, 0x25477e, 0x72629f, 0xa48db5, 
    0xf5b8f4, 0xdf6ff1, 0xa831ee, 0x3610e3, 
    0x241267, 0x7f2387, 0x471a3a, 0x93274e, 
    0x976877, 0xe57ea3, 0xd5309d, 0xdd385a, 
    0xf28071, 0xee2911, 0x9e281f, 0x4e211a, 
    0x5b5058, 0x5e4d28, 0x7e751a, 0xa2af22, 
    0xe0f53f, 0xfffbc6, 0xffffff, 0xdfb9ba, 
    0xab8c76, 0xeec191, 0xc19029, 0xf8cb1a, 
    0xea7924, 0xa15e30,
    0x10082e
    -- custom colours
}

fadeBlackTable={
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0},
    {2,2,2,2,2,2,1,1,1,0,0,0,0,0,0},
    {3,3,3,3,3,3,1,1,1,0,0,0,0,0,0},
    {4,4,4,2,2,2,2,2,1,1,0,0,0,0,0},
    {5,5,5,5,5,1,1,1,1,1,0,0,0,0,0},
    {6,6,13,13,13,13,5,5,5,5,1,1,1,0,0},
    {7,6,6,6,6,13,13,13,5,5,5,1,1,0,0},
    {8,8,8,8,2,2,2,2,2,2,0,0,0,0,0},
    {9,9,9,4,4,4,4,4,4,5,5,0,0,0,0},
    {10,10,9,9,9,4,4,4,5,5,5,5,0,0,0},
    {11,11,11,3,3,3,3,3,3,3,0,0,0,0,0},
    {12,12,12,12,12,3,3,1,1,1,1,1,1,0,0},
    {13,13,13,5,5,5,5,1,1,1,1,1,0,0,0},
    {14,14,14,13,4,4,2,2,2,2,2,1,1,0,0},
    {15,15,6,13,13,13,5,5,5,5,5,1,1,0,0}
}

--
-- Globals
--
DEBUG_MODE = false
GAME_WIDTH = 512  -- 16:9 aspect ratio that fits nicely
GAME_HEIGHT = 288 -- within the default Castle window size
GAME_SCALE = 3
GAME_STATE = { SPLASH=0, TITLE=1, INFO=2, LVL_INTRO=3, LVL_PLAY=4, LVL_END=5, LOSE_LIFE=6, GAME_OVER=7 }
GAME_MODE = { GAME=0, EDITOR=1 }
OBJ_TYPE = { PLAYER=10, PLAYER_START=11, HOLE=12, WALL=1, BRIDGE=2 }

PLAYER_MAX_SPEED = 100
PLAYER_STARTX,PLAYER_STARTY = 100,160

--
-- Global functions
--


--
-- Helper Functions
--

-- Re-seed the Random Number Generation
-- so that if called quickly (sub-seconds)
-- it'll still be random
_incSeed=0
function resetRNG()
    _incSeed = _incSeed + 1
    local seed=os.time() + _incSeed
    math.randomseed(seed)
end

-- https://helloacm.com/split-a-string-in-lua/
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- print centered
function pprintc(text, y, col)
  local letterWidth = (get_font()=="corefont") and 6 or 12
  pprint(text, GAME_WIDTH/2-(#text*letterWidth)/2, y, col)
end

-- draw centered sprite
function sprc(s, x, y, w, h, flip_x, flip_y)
  local gx,gy = get_spritesheet_grid()
  spr(s, 
    x - (gx*w)/2, 
    y - (gy*h)/2, 
    w, h, flip_x, flip_y)
end

-- https://stackoverflow.com/a/53038524
function ArrayRemove(t, fnKeep)
  local j, n = 1, #t;

  for i=1,n do
      if (fnKeep(t, i, j)) then
          -- Move i's kept value to j's position, if it's not already there.
          if (i ~= j) then
              t[j] = t[i];
              t[i] = nil;
          end
          j = j + 1; -- Increment position of where we'll place the next kept value.
      else
          t[i] = nil;
      end
  end

  return t;
end