require 'sounds'
require 'imgs'
require 'collision'
require 'SpriteSheet'

-- themes
local defaultTheme = require 'themes/default.lua'
local gameboyTheme = require 'themes/gameboy.lua'
local virtualBoyTheme = require 'themes/virtualboy.lua'
local sketchTheme = require 'themes/sketch.lua'
local cyberTheme = require 'themes/cyber.lua'
local retroTheme = require 'themes/retro.lua'
local lofiTheme = require 'themes/lofi.lua'

theme = defaultTheme

local soundFilenames = {}
local imgFilenames = {}

local user = {}
local startTime = nil

local gLoading = false
local gDrawing = false
local gUpdating = false

-- TODO: use castle's API to pre-fetch these assets? ... before load time?
-- TODO: allow user to specify file extensions, or not, and dynamically
-- figure out here what filetype they are in order to load that type
-- there's enough info in the method names "PLAYSND" and "IMG" to be able to 
-- disambiguate files with the same name that are of different media types
-- but if someone has a sound titled .mp3 and another .wav, there will need
-- to be an error thrown informing them to disambiguate
-- also, name the sounds with the full file path, or just the leaf name?
-- consider that trade-off
function preprocess(file)

  -- TODO: this method currently doesn't respect comments in orig code.
  -- It'll just load everything

  for line in love.filesystem.lines('main.lua') do
    -- TODO: make it so changing PLAYSND's method name changes gmatch string as well
    for soundFilename in string.gmatch(line, "PLAYSND%('([^']+)") do
      if soundFilenames[soundFilename] == nil then
        table.insert(soundFilenames, soundFilename)
      end
    end
    -- TODO: make it so changing IMG's method name changes gmatch string as well
    for imgFilename in string.gmatch(line, "IMG%('([^']+)") do
      if imgFilenames[imgFilename] == nil then
        table.insert(imgFilenames, imgFilename)
      end
    end
    -- TODO: make it so changing SPRITE's method name changes gmatch string as well
    for imgFilename in string.gmatch(line, "SPRITE%('([^']+)") do
      if imgFilenames[imgFilename] == nil then
        table.insert(imgFilenames, imgFilename)
      end
    end
  end
end

function loadAssets()
  -- sounds
  for k, v in pairs(soundFilenames) do
    -- TODO: dynamically size each sound's channel amount 
    -- as the sound is played many times. If they want the behavior
    -- they'd get with just one sound, they can call STOP immediately
    -- followed by PLAY to get that effect
    Sounds[v] = Sound:new(v, 3)
  end

  -- images
  for k, v in pairs(imgFilenames) do
    Imgs[v] = love.graphics.newImage(v)
  end
end

-- TODO: get and load all sounds (use pre-fetch API), load em into mem
-- TODO: get all images, pre-fetch 'em by default, load em into mem
function love.load()

  gLoading = true

  -- TODO: set a default theme to 'none' and make that one
  currTheme = gameboyTheme

  -- TODO: should instead get main entry point from .castle and preprocess 
  -- starting there. need to pre-process all .lua files
  preprocess('main.lua')
  loadAssets()

  Imgs['manual'] = love.graphics.newImage('manual.png')

  network.async(function()
    user.name = castle.user.getMe().username
    user.avatarImage = love.graphics.newImage(castle.user.getMe().photoUrl)
    Imgs['avatar'] = user.avatarImage
  end)

  love.graphics.setDefaultFilter('linear', 'linear', 1)

  startTime = love.timer.getTime()
  
  _LOAD()
end

local keysJustPressed = {}
local keysHeld = {}

-- TODO:
function love.update(dt)
  gLoading = false
  gDrawing = false
  gUpdating = true

  -- TODO: update sound engine and anything else per update call
  if currTheme.UPDATE then
    currTheme:UPDATE(_UPDATE, dt)
  else
    defaultTheme:UPDATE(_UPDATE, dt)
  end

  -- nil any keypresses
  for k, v in pairs(keysJustPressed) do
    keysJustPressed[k] = false
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

local filter_effect = nil

function love.draw()
  gLoading = false
  gUpdating = false
  gDrawing = true

  if currTheme.DRAW then
    currTheme:DRAW(_DRAW)
  else
    defaultTheme:DRAW(_DRAW)
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

function T()
  return love.timer.getTime() - startTime
end

function THEME(newTheme)

  -- set Defaults before swapping theme
  love.graphics.setPointSize(1.0)
  love.graphics.setLineWidth(1.0)
  love.graphics.setColor(1,1,1,1)

  local loadThemeFunc = (function()
    STOPSND('themes/'..currTheme.music)

    -- TODO: need to make a themes/default.lua which just uses love2d's default
    if newTheme == 'default' or newTheme == nil then
      currTheme = defaultTheme
    elseif newTheme == 'gameboy' then
      currTheme = gameboyTheme
    elseif newTheme == 'virtualboy' then
      currTheme = virtualBoyTheme
    elseif newTheme == 'retro' then
      currTheme = retroTheme
    elseif newTheme == 'cyber' then
      currTheme = cyberTheme
    elseif newTheme == 'lofi' then
      currTheme = lofiTheme
    elseif newTheme == 'sketch' then
      currTheme = sketchTheme
    end

    currTheme:INIT()

    PLAYSND('themes/'..currTheme.music, 1.0, true)
  end)

  -- load synchronously if done at start of program
  -- otherwise need to load async
  if gLoading then
    loadThemeFunc()
  else
    network.async(function()
      loadThemeFunc()
    end)
  end
end

-- TODO: make 'type' param optional
function COLLIDED(a, b, type)
  if type == nil then
    type = 'basic'
  end

  if type == 'basic' then
    if a.type == 'rect' and b.type == 'rect' then
      -- TODO: do AABB collision
    end
    -- TODO: infer bounding types based upon object types
    -- circle/rect/line
  elseif type == 'box' then
    -- use AABB (or other type of?) bounding boxes
  elseif type == 'perfect' then

  end
end

-- TODO: need to call love's getColor and then setColor back to before after calling
-- each method. see IMG(...) below for code that does this

-- TODO: use size and font
-- TODO: pre-fetch font in load
-- TODO: add custom fonts per theme
function TEXT(message, x, y, scale, color, font)
  r, g, b, a = love.graphics.getColor()
  if message ~= nil then
    if currTheme.TEXT then
      currTheme:TEXT(message, x, y, scale, color, font)
    else
      if currTheme.colors[color] then
        color = currTheme.colors[color]
      end
      defaultTheme:TEXT(message, x, y, scale, color, font)
    end
  end
  -- TODO: throw error if no message provided
end

-- TODO: make all sorts of entity creation methods?
-- do I need these or can they be overloaded with regular 
-- drawing methods like RECTFILL, etc. ? return an ID or object
-- from those standard DRAW methods if they're called a non-DRAW
-- method.
-- IDEA: the library can maintain whether it's currently calling
-- LOAD, DRAW, OR UPDATE, and we can check that flag inside each of
-- the methods like RECTFILL. if RECTFILL is called from UPDATE then
-- it can return a value. if it is called from DRAW then it doesn't
-- return a value

local entities = {}

function MAKE_RECT(x1, y1, x2, y2)
  local xA, yA, xB, yB = x1, y1, x2, y2

  local objectID = #entities

  local newRect = {
    id = objectID,
    type = 'rect',
    x1 = xA,
    y1 = yA,
    x2 = xB,
    y2 = yB
  }

  entities[objectID] = newRect

  return newRect
end

function RECT(x1, y1, x2, y2, color)
  r, g, b, a = love.graphics.getColor()
  if currTheme.RECT then
    currTheme:RECT(x1, y1, x2, y2, color)
  else
    if currTheme.colors[color] then
      color = currTheme.colors[color]
    end
    defaultTheme:RECT(x1, y1, x2, y2, color)
  end
  love.graphics.setColor({r,g,b,a})
end

function RECTFILL(x1, y1, x2, y2, color)
  r, g, b, a = love.graphics.getColor()
  if currTheme.RECTFILL then
    currTheme:RECTFILL(x1, y1, x2, y2, color)
  else
    if currTheme.colors[color] then
      color = currTheme.colors[color]
    end
    defaultTheme:RECTFILL(x1, y1, x2, y2, color)
  end
  love.graphics.setColor({r,g,b,a})
end

function CIRC(x, y, r, color)
  red, green, blue, alpha = love.graphics.getColor()
  if currTheme.CIRC then
    currTheme:CIRC(x, y, r, color)
  else
    if currTheme.colors[color] then
      color = currTheme.colors[color]
    end
    defaultTheme:CIRC(x, y, r, color)
  end
  love.graphics.setColor({red,green,blue,alpha})
end

function CIRCFILL(x, y, r, color)
  red, green, blue, alpha = love.graphics.getColor()
  if currTheme.CIRCFILL then
    currTheme:CIRCFILL(x, y, r, color)
  else
    if currTheme.colors[color] then
      color = currTheme.colors[color]
    end
    defaultTheme:CIRCFILL(x, y, r, color)
  end
  love.graphics.setColor({red,green,blue,alpha})
end

function LINE(x1, y1, x2, y2, color)
  r, g, b, a = love.graphics.getColor()
  local prevWidth = love.graphics.getLineWidth()
  if currTheme.LINE then
    currTheme:LINE(x1, y1, x2, y2, color)
  else
    if currTheme.colors[color] then
      color = currTheme.colors[color]
    end
    defaultTheme:LINE(x1, y1, x2, y2, color)
  end
  love.graphics.setLineWidth(prevWidth)
  love.graphics.setColor({r,g,b,a})
end

-- TODO: bugged. set exact point somehow
function PSET(x, y, color)
  r, g, b, a = love.graphics.getColor()
  local prevSize = love.graphics.getPointSize()
  if currTheme.PSET then
    currTheme:PSET(x, y, color)
  else
    if currTheme.colors[color] then
      color = currTheme.colors[color]
    end
    defaultTheme:PSET(x, y, color)
  end
  love.graphics.setPointSize(prevSize)
  love.graphics.setColor({r,g,b,a})
end

function PSETS(pts, color)
  r, g, b, a = love.graphics.getColor()
  local prevSize = love.graphics.getPointSize()
  if currTheme.PSET then
    currTheme:PSETS(pts, color)
  else
    if currTheme.colors[color] then
      color = currTheme.colors[color]
    end
    defaultTheme:PSETS(pts, color)
  end
  love.graphics.setPointSize(prevSize)
  love.graphics.setColor({r,g,b,a})
end

function PGET(x, y) 
  -- TODO(jason): this one is important
end

-- TODO: supplying filename needs to create image at load-time automatically
-- and this function needs to lookup that love2d image in a table
-- and then draw that image according to the below params
-- TODO: define + use types for 'aspect' param
function IMG(filename, x1, y1, x2, y2, aspect)
  r,g,b,a = love.graphics.getColor()

  if Imgs[filename] then
    love.graphics.setColor(1,1,1,1)

    local actualWidth = Imgs[filename]:getWidth()
    local actualHeight = Imgs[filename]:getHeight()

    -- default aspect == stretch_to_fill
    local targetWidth = ABS(x2 - x1)
    local targetHeight = ABS(y2 - y1)

    if aspect == 'aspect_fill' then
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

    if currTheme.IMG then
      currTheme:IMG(Imgs[filename], x1, y1, xScaleFactor, yScaleFactor)
    else
      defaultTheme:IMG(Imgs[filename], x1, y1, xScaleFactor, yScaleFactor)
    end
  end

  love.graphics.setColor({r,g,b,a})
end

function AVATAR(x1, y1, x2, y2, aspect)
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
  -- TODO: throw an actual warning.
  -- TODO: if person has no internet connection, it 
  -- won't be able to have a username, so handle that case
  return ' '
end


-- TODO(use ayla's sprite sheets loaders?)
function SPRITE(filename, index, x, y, numberOfSprites, flipHorizontal, flipVertical)

end

-- TODO: pre-fetch all sounds ever played, load them into sound engine
-- with a default volume and other params. if sound is larger than a
-- certain filesize... maybe set it to stream, rather than static?
-- can we intuit this somehow?

-- TODO: volume prob not need to be passed every time...
-- TODO: make volume+looping optional params
-- TODO: allow an onFinishFunc per sound
-- TODO: dig deep inside love, NEED to make looping seamless
-- TODO: need to allow filtering and some other things OpenAL provides
-- TODO: prob need additional C-level DSP stuff
function PLAYSND(filename, volume, shouldLoop)
  if Sounds[filename] then
    Sounds[filename]:setVolume(volume)
    Sounds[filename]:setLooping(shouldLoop)
    Sounds[filename]:play()
  end
end

function VOLUME(filename, volume)
  -- TODO: throw warning if volume outside of range?
  -- silently clamping for now
  if filename == 'theme' then
    filename = 'themes/'..currTheme.music
  end

  volume = CLAMP(0.0, volume, 1.0)
  if Sounds[filename] then
    Sounds[filename]:setVolume(volume)
  end
end

-- TODO: pause actual sound passed in
function PAUSESND(filename)
  if Sounds[filename] then
    Sounds[filename]:pause()
  end
end

-- TODO: stop actual sound passed in
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
function POW(x) return math.pow(x) end
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

