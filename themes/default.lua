defaultTheme = {
  music = 'none.mp3',
  colors = {
    black = {0, 0, 0},
    white = {1, 1, 1},
    gray = {.5, .5, .5},
    red = {1, 0, 0},
    green = {0, 1, 0},
    blue = {0, 0, 1},
    yellow = {1.0, 1.0, 0.0},
    orange = {0.9, 0.3, 0},
    purple = {1.0, 0.0, 1.0},
    cyan = {0.0, 1.0, 1.0},
  }
}

-- TODO: get and load all sounds (use pre-fetch API), load em into mem
-- TODO: get all images, pre-fetch 'em by default, load em into mem
function defaultTheme:INIT()
  Sounds['themes/'..self.music] = Sound:new('themes/'..self.music, 3)
  -- TODO: load or pre-process any existing images which are in 'Imgs'
end

function defaultTheme:DRAW(drawFunc)
  drawFunc()
end

function defaultTheme:UPDATE(updateFunc, dt)
  updateFunc(dt)
end

-- TODO: need to call love's getColor and then setColor back to before after calling
-- each method. see IMG(...) below for code that does this

-- TODO: fixed pallette? rgb?
-- TODO: choose a set of pallete presets?
-- TODO: see ayla/paul's infra-code
function defaultTheme:setColor(color)
  if self.colors[color] then
    color = self.colors[color]
  end

  love.graphics.setColor(color[1], color[2], color[3], 1.0)
end

-- TODO: use size and font
-- TODO: pre-fetch font in load
function defaultTheme:TEXT(message, x, y, scale, color, font)
  if message ~= nil then
    self:setColor(color)
    love.graphics.print(message, x, y, 0, scale, scale)
  end
end

function defaultTheme:drawRect(type, x1, y1, x2, y2, color)
  local x = x1
  local y = y1
  if x2 < x1 then x = x2 end
  if y2 < y1 then y = y2 end

  local w = math.abs(x1 - x2)
  local h = math.abs(y1 - y2)

  self:setColor(color)
  love.graphics.rectangle(type, x, y, w, h)
end

function defaultTheme:RECT(x1, y1, x2, y2, color)
  self:drawRect('line', x1, y1, x2, y2, color)
end

function defaultTheme:RECTFILL(x1, y1, x2, y2, color)
  self:drawRect('fill', x1, y1, x2, y2, color)
end

function defaultTheme:drawCircle(type, x, y, r, color)
  self:setColor(color)
  -- TODO: maybe draw the circle out of many rectangles for gameboy look'n'feel?
  love.graphics.circle(type, x, y, r, 128)
end

function defaultTheme:CIRC(x, y, r, color)
  self:drawCircle('line', x, y, r, color)
end

function defaultTheme:CIRCFILL(x, y, r, color)
  self:drawCircle('fill', x, y, r, color)
end

function defaultTheme:LINE(x1, y1, x2, y2, color)
  self:setColor(color)
  love.graphics.line(x1, y1, x2, y2)
end

-- TODO: bugged. set exact point somehow
function defaultTheme:PSET(x, y, color)
  self:setColor(color)
  love.graphics.points({x, y})
end

function defaultTheme:PSETS(pts, color)
  self:setColor(color)
  love.graphics.points(pts)
end

function defaultTheme:PGET(x, y) 
  -- TODO(jason): this one is important
end

-- TODO: supplying filename needs to create image at load-time automatically
-- and this function needs to lookup that love2d image in a table
-- and then draw that image according to the below params
-- TODO: define + use types for 'aspect' param
function defaultTheme:IMG(image, x, y, xScaleFactor, yScaleFactor)
  -- TODO: make the image look gameboy colors and resolution
  love.graphics.draw(image, x, y, 0, xScaleFactor, yScaleFactor, 0, 0)
end

return defaultTheme
