require 'sounds'
require 'collision'
require 'SpriteSheet'
local moonshine = require 'moonshine'


-- TODO: based upon pre-processing the file, figure out what input keys are used, 
-- and have this library flash an infographic of those controls at the start of the program
-- so that people know how to interact with it. 

-- TODO: pressing the 'c' key at any time shows a controls overlay? or 'h' for help?

local Imgs = {}

W = love.graphics.getWidth()

-- TODO: use castle's API to pre-fetch these assets ... before load time?
-- TODO: allow user to specify file extensions, or not, and dynamically
-- figure out here what filetype they are in order to load that type
-- there's enough info in the method names "PLAYSND" and "IMG" to be able to 
-- disambiguate files with the same name that are of different media types
-- but if someone has a sound titled .mp3 and another .wav, there will need
-- to be an error thrown informing them to disambiguate
-- also, name the sounds with the full file path, or just the leaf name?
-- consider that trade-off
local soundFilenames = {}
local imgFilenames = {}

function preprocess(fname)
  for line in love.filesystem.lines(fname) do
    -- TODO: make it so changing PLAYSND's method name changes gmatch string as well
    for soundFilename in string.gmatch(line, "PLAYSND%('([^']+)") do
      table.insert(soundFilenames, soundFilename)
    end
    for soundFilename in string.gmatch(line, "PL%('([^']+)") do
      table.insert(soundFilenames, soundFilename)
    end
    for soundFilename in string.gmatch(line, "LP%('([^']+)") do
      table.insert(soundFilenames, soundFilename)
    end
    -- TODO: make it so changing IMG's method name changes gmatch string as well
    for imgFilename in string.gmatch(line, "IMG%('([^']+)") do
      table.insert(imgFilenames, imgFilename)
    end
    for imgFilename in string.gmatch(line, "I%('([^']+)") do
      table.insert(imgFilenames, imgFilename)
    end
  end
end

local user = {}

local basicTimer = nil
local startTime = nil

--TODO:
--preprocess 
--S()

--end

--U()

--end

-- D()

--end

-- into "function _START()", "function _UPDATE()", "function _DRAW()"

-- reduce method names for everything else

-- make a color palette per theme

-- make themes loadable over the network


local function loadAssets()
  for k, v in pairs(soundFilenames) do
    print(v)
    Sounds[v] = Sound:new(v, 3) -- TODO: dynamically size the sound channel amount
  end

  for k, v in pairs(imgFilenames) do
    Imgs[v] = love.graphics.newImage(v)
  end
end

-- TODO: get and load all sounds (use pre-fetch API), load em into mem
-- TODO: get all images, pre-fetch 'em by default, load em into mem
function love.load()
  -- TODO: should instead get main entry point from .castle and preprocess 
  -- starting there. also need to pre-process recursively
  preprocess('main_tweet.lua')

  SR()

  Imgs['manual'] = love.graphics.newImage('manual.png')

  network.async(function()
    user.name = castle.user.getMe().username
    user.avatarImage = love.graphics.newImage(castle.user.getMe().photoUrl)
    Imgs['avatar'] = user.avatarImage
  end)

  love.graphics.setDefaultFilter('linear', 'linear', 1)

  startTime = love.timer.getTime()
  basicTimer = startTime

  table.insert(soundFilenames, 's.mp3')

  loadAssets()

  S('retro') 
  LP('s.mp3')

  if _L ~=nil then _L() end
end

local keysJustPressed = {}
local keysHeld = {}
local mouseJustClickedX = nil
local mouseJustClickedY = nil
local mouseHeld = false

-- TODO:
function love.update(dt)
  -- TODO: update sound engine and anything else per update call
  if _U ~=nil then _U(dt) end

  -- nil any input
  for k, v in pairs(keysJustPressed) do
    keysJustPressed[k] = false
  end
  mouseJustClicked = false
end

function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 then
    mouseJustClickedX = x
    mouseJustClickedY = y
    mouseButtonHeld = true
  end
end

function love.mousereleased( x, y, button, istouch, presses )
  if button == 1 then
    mouseJustClickedX = nil
    mouseJustClickedY = nil
    mouseButtonHeld = false
  end
end

local showingManual = false

function love.keypressed(key, scancode, isrepeat)
  if key == 'm' then
    showingManual = not showingManual
  else
    keysJustPressed[key] = true
    keysHeld[key] = true
  end
end

function love.keyreleased(key, scancode)
  if keysHeld[key] ~= nil then
    keysHeld[key] = false
  else
    -- TODO: ERROR: this case shouldn't happen
  end
end

function BTN(key)
  if key == 'm' then
    -- TODO: throw warning about 'm' being a reserved key
  elseif keysHeld[key] ~= nil then
    --print(key)
    return keysHeld[key]
  end
end

function BTNP(key)
  if key == 'm' then
    --TODO: throw warning about 'm' being a reserved key
  elseif keysJustPressed[key] ~= nil then
    val = keysJustPressed[key]
    keysJustPressed[key] = false
    return val
  end
end

function MOUSE()
  return mouseHeld
end

function MOUSEP()
  if mouseJustClickedX then
    xToReturn = mouseJustClickedX
    yToReturn = mouseJustClickedY
    mouseJustClickedX = nil
    mouseJustClickedY = nil
    return xToReturn, yToReturn
  else
    return nil, nil
  end
end

local filter_effect = nil

function love.draw()
  w,h,hw,hh=W(),H(),HW(),HH()
  if filter_effect then
    filter_effect(function()
      if _D ~=nil then _D() end
    end)
  else
    if _D ~=nil then _D() end
  end
  if showingManual then
    IMG('manual', 20, 20, W() - 20, H() - 20, 'aspect_fill')
  end
end

function W()
  return love.graphics.getWidth()
end

function H()
  return love.graphics.getHeight()
end

function HW() return 0.5 * W() end
function HH() return 0.5 * H() end

-- reset simple timer
function rt()
  basicTimer = love.timer.getTime()
end

function T()
  return love.timer.getTime() - startTime
end

-- t() offers contains a simple timer which can be reset whenever 
function tm()
  result = love.timer.getTime() - basicTimer
  return result
end

-- TODO: make this do the thing. make something similarly architected to moonshine,
-- but with more meaningful filters and proper performance across machines

-- TODO: make a simple grayscale filter as a starting example
-- TODO: allow filters per object
-- TODO: assign a filterId to each filter
function ADD_FILTER(type)
  filter_effect = moonshine(moonshine.effects.dmg)
  filter_effect.dmg.palette = 'greyscale'
end

function REMOVE_FILTER(filterId)
  filter_effect = nil -- TODO: remove by filterId
end

function THEME(type)
  theme = type
  if type == 'none' or type == nil then
    filter_effect = nil
  elseif type == 'retro' then
    filter_effect = moonshine(moonshine.effects.glow)
    .chain(moonshine.effects.pixelate)
    .chain(moonshine.effects.crt)
    .chain(moonshine.effects.scanlines)
    --.chain(moonshine.effects.dmg)
    filter_effect.glow.strength = 10.0
    filter_effect.glow.min_luma = 0.2
    filter_effect.pixelate.size = {8, 4}
    filter_effect.pixelate.feedback = 0.65
    filter_effect.crt.distortionFactor = {1.05, 1.06}
    filter_effect.scanlines.opacity = 1.0
    filter_effect.scanlines.thickness = 0.2
    -- filter_effect.dmg.palette = {
    --   {10/255, 0/255, 0/255},
    --   {142/255, 40/255, 60/255},
    --   {200/255, 100/255, 120/255},
    --   {255/255, 200/255, 210/255},
    -- }
  end
end

-- TODO: make 'type' param optional
function COLLIDED(a, b, type)
  if type == 'basic' then
    -- TODO: infer bounding types based upon object types
    -- circle/rect/line
  elseif type == 'perfect' then
  end
end

function PIC(px, py, cx, cy, r)
  local dx, dy = px - cx, py - cy
  return dx*dx + dy*dy <= r*r
end


-- TODO: need to call love's getColor and then setColor back to before after calling
-- each method. see IMG(...) below for code that does this

-- TODO: make these apply to each theme

local paletteColors = {
  {0, 0, 0},        -- black
  {0.1, 0.1, 0.1},  -- dark
  {1.0, 0.0, 1.0},  -- purple
  {0.0, 1.0, 1.0},  -- white
  {1, 1, 1},        -- gray
  {.5, .5, .5},     -- red
  {1, 0, 0},        -- green
  {0, 1, 0},        -- blue
  {0, 0, 1},        -- yellow
  {1.0, 1.0, 0.0},  -- orange
  {0.9, 0.3, 0}     -- cyan
}

-- TODO: fixed pallette? rgb?
-- TODO: choose a set of pallete presets?
-- TODO: see ayla/paul's infra-code
local function setColor(col, alpha)
  alpha = alpha or 1.0

  if col == nil then
    -- TODO: throw some error/warning
    col = {0,0,0}
  end

  if paletteColors[col] then
    col = paletteColors[col]
  else
    -- TODO: throw some error/warning
  end

  love.graphics.setColor(col[1], col[2], col[3], alpha)
end

-- TODO: use size and font
-- TODO: pre-fetch font in load
function TEXT(message, x, y, scale, color, font)
  if message ~= nil then
    setColor(color)
    love.graphics.print(message, x, y, 0, scale, scale)
  end
end

local function drawRect(type, x1, y1, x2, y2, color, alpha)
  local x = x1
  local y = y1
  if x2 < x1 then x = x2 end
  if y2 < y1 then y = y2 end

  local w = math.abs(x1 - x2)
  local h = math.abs(y1 - y2)

  setColor(color, alpha)
  love.graphics.rectangle(type, x, y, w, h)
end

function RECT(x1, y1, x2, y2, color, alpha)
  drawRect('line', x1, y1, x2, y2, color, alpha)
end

function RECTFILL(x1, y1, x2, y2, color, alpha)
  drawRect('fill', x1, y1, x2, y2, color, alpha)
end

local function drawCircle(type, x, y, r, color)
  setColor(color)
  -- TODO: base number of segments on radius so it's always smooth,
  -- and also always as performant as possible
  love.graphics.circle(type, x, y, r, 128)
end

function CIRC(x, y, r, color)
  drawCircle('line', x, y, r, color)
end

function CIRCFILL(x, y, r, color)
  drawCircle('fill', x, y, r, color)
end

function LINE(x1, y1, x2, y2, color)
  local prevWidth = love.graphics.getLineWidth()
  if theme == 'retro' then
    love.graphics.setLineWidth(3.0)
  end
  setColor(color)
  love.graphics.line(x1, y1, x2, y2)
  love.graphics.setLineWidth(prevWidth)
end

-- TODO: bugged. set exact point somehow
function PSET(x, y, color)
  local prevSize = love.graphics.getPointSize()
  if theme == 'retro' then
    love.graphics.setPointSize(3.0)
  end
  setColor(color)
  love.graphics.points({x, y})
  love.graphics.setPointSize(prevSize)
end

function PSETS(pts, color)
  local prevSize = love.graphics.getPointSize()
  if theme == 'retro' then
    love.graphics.setPointSize(3.0)
  end
  setColor(color)
  love.graphics.points(pts)
  love.graphics.setPointSize(prevSize)
end

-- TODO: supplying filename needs to create image at load-time automatically
-- and this function needs to lookup that love2d image in a table
-- and then draw that image according to the below params
-- TODO: define + use types for 'aspect' param
function IMG(filename, x1, y1, x2, y2, aspect)
  aspect = aspect or 'aspect_fill'

  r,g,b,a = love.graphics.getColor()

  if Imgs[filename] then
    love.graphics.setColor(1,1,1,1)

    local actualWidth = Imgs[filename]:getWidth()
    local actualHeight = Imgs[filename]:getHeight()

    -- default aspect == 'stretch_to_fill'
    local targetWidth = ABS(x2 - x1)
    local targetHeight = ABS(y2 - y1)
    if aspect == 'stretch_fill' then

    elseif aspect == 'aspect_fill' then
      if actualWidth > targetWidth and actualHeight > targetHeight then
        if targetWidth/targetHeight > actualWidth/actualHeight then
          targetWidth = targetHeight * (actualWidth/actualHeight)
          x1 = x1 + ABS(x2 - x1) / 2 - targetWidth / 2
        else
          targetHeight = targetWidth * (actualHeight/actualWidth)
          y1 = y1 + ABS(y2 - y1) / 2 - targetHeight / 2
        end
      elseif actualWidth > targetWidth then
        targetHeight = targetWidth * (actualHeight/actualWidth)
        y1 = y1 + ABS(y2 - y1) / 2 - targetHeight / 2
      elseif actualHeight > targetHeight then
        targetWidth = targetHeight * (actualWidth/actualHeight)
        x1 = x1 + ABS(x2 - x1) / 2 - targetWidth / 2
      end
    end

    local xScaleFactor = targetWidth / actualWidth
    local yScaleFactor = targetHeight / actualHeight

    love.graphics.draw(Imgs[filename], x1, y1, 0, xScaleFactor, yScaleFactor, 0, 0)
  end

  love.graphics.setColor({r,g,b,a})
end

function AVATAR(x1, y1, x2, y2, aspect)
  aspect = aspect or 'aspect_fill'
  if user.avatarImage then
    IMG('avatar', x1, y1, x2, y2, aspect)
  else
    -- TODO: throw warning?
  end
end

function USERNAME()
  if user.name then 
    return user.name
  end
end

-- TODO: pre-fetch all sounds ever played, load them into sound engine
-- with a default volume and other params. if sound is larger than a
-- certain filesize... maybe set it to stream, rather than static?
-- can we intuit this somehow?

-- TODO: play actual sound passed in
-- TODO: volume prob not need to be passed every time...
-- TODO: make volume+looping optional params
-- TODO: allow an onFinishFunc per sound
function PLAYSND(filename, volume, shouldLoop)
  if Sounds[filename] then
    Sounds[filename]:setVolume(volume)
    Sounds[filename]:setLooping(shouldLoop)
    Sounds[filename]:play()
  end
end

function VOLUME(filename, volume)
  -- TODO: throw warning if volume outside of range?
  -- silently just clamp for now
  volume = CLAMP(0.0, volume, 1.0)
  if Sounds[filename] then
    Sounds[filename]:setVolume(volume)
  end
end

function PAUSESND(filename)
  if Sounds[filename] then
    Sounds[filename]:pause()
  end
end

function STOPSND(filename)
  if Sounds[filename] then
    Sounds[filename]:stop()
  end
end

-- TODO: combine two below SRAND funcs via optional param?

-- Allow specific seeds
function SRAND(x) math.randomseed(x) end
-- Seeds randomly
function SRAND()
  -- bit-level trick from: http://lua-users.org/wiki/MathLibraryTutorial
  math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
end

function CLAMP(min, val, max)
  if min > max then 
    min, max = max, min 
  end
  return math.max(min, math.min(max, val))
end

function FLR(a) return math.floor(a) end
function DEG(a) return math.deg(a) end
function RAD(a) return math.rad(a) end
function CEIL(a) return math.ceil(a) end
-- TODO: can condense below two RAND funcs
function RAND() return math.random() end
function RAND(a, b) return math.random(a, b) end
function ABS(a, b) return math.abs(a, b) end
function SQRT(a) return math.sqrt(a) end
function LOG(x) return math.log(x) end
function EXP(x) return math.exp(x) end
function POW(x,y) return math.pow(x,y) end
function SIN(x) return math.sin(x) end
function COS(x) return math.cos(x) end
function TAN(x) return math.tan(x) end
function ASIN(x) return math.asin(x) end
function ACOS(x) return math.acos(x) end
function ATAN(x) return math.atan(x) end
function ATAN2(x, y) return math.atan2(y, x) end
function PI() return math.pi end

-- TODO: make MIN take variable-length list of args
-- see how math.min works - it already does that
function MIN(nums)
  return math.min(nums)
end

-- TODO: make work with variable-length list of args
function AVG(nums)
end

-- shortname aliases -- 

-- BUTTONS
function UP() return BTN('up') end
function DN() return BTN('down') end
function LT() 
  if BTN('left') then return 1 else return 0 end
end
function RT() 
  if BTN('right') then return 1 else return 0 end
end

function Z() return BTN('z') end
function X() return BTN('x') end
function M() return MOUSE() end

function UPP() return BTNP('up') end
function DNP() return BTNP('down') end
function LTP() return BTNP('left') end
function RTP() return BTNP('right') end
function ZP() return BTNP('z') end
function XP() return BTNP('x') end

function MP() return MOUSEP() end

-- MATH
function RN() return RAND() end
function RN(a, b) return RAND(a,b) end

-- GFX
function TX(msg,x,y,scale,color,font) TEXT(msg,x,y,scale,color,font) end
function R(x1,y1,x2,y2,color,alpha) RECT(x1,y1,x2,y2,color,alpha) end
function RF(x1,y1,x2,y2,color,alpha) RECTFILL(x1,y1,x2,y2,color,alpha) end
function C(x,y,r,color) CIRC(x,y,r,color) end
function CF(x,y,r,color) CIRCFILL(x,y,r,color) end
function L(x1,y1,x2,y2,color) LINE(x1,y1,x2,y2,color) end
function P(x,y,color) PSET(x,y,color) end
function PS(pts, color) PSETS(pts,color) end
function I(fname,x1,y1,x2,y2,aspect) IMG(fname,x1,y1,x2,y2,aspect) end
function A(x1,y1,x2,y2,aspect) AVATAR(x1,y1,x2,y2,aspect) end
function UN() return USERNAME() end

function SR() SRAND() end

-- SOUND
function PL(fname) PLAYSND(fname,1.0,false) end
function LP(fname) PLAYSND(fname,1.0,true) end
function V(fname,vol) VOLUME(fname, vol) end

-- MISC
function S(type) THEME(type) end -- S for 'Style'
