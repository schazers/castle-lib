-- TODO: use custom font for text
-- TODO: (maybe draw circles as lots of rectangles?)
-- TODO: make images have gameboy-style color and resolution

gameboyTheme = {
  name = 'gameboy',
  music = 'gameboy.mp3',
  colors = {
    black = {156/255, 186/255, 41/255},
    white = {140/255, 170/255, 38/255},
    gray = {140/255, 170/255, 38/255},
    red = {49/255, 97/255, 50/255},
    green = {49/255, 97/255, 50/255},
    blue = {49/255, 97/255, 50/255},
    yellow = {17/255, 55/255, 17/255},
    orange = {49/255, 97/255, 50/255},
    purple = {17/255, 55/255, 17/255},
    cyan = {17/255, 55/255, 17/255},
  }
}

-- TODO: get and load all sounds (use pre-fetch API), load em into mem
-- TODO: get all images, pre-fetch 'em by default, load em into mem
function gameboyTheme:INIT()
  Sounds['themes/'..self.music] = Sound:new('themes/'..self.music, 3)
  -- TODO: load or pre-process any existing images which are in 'Imgs'
end

-- TODO: need to call love's getColor and then setColor back to before after calling
-- each method. see IMG(...) below for code that does this

-- TODO: fixed pallette? rgb?
-- TODO: choose a set of pallete presets?
-- TODO: see ayla/paul's infra-code
function gameboyTheme:setColor(color)
  if self.colors[color] then
    color = self.colors[color]
  end

  love.graphics.setColor(color[1], color[2], color[3], 1.0)
end

function gameboyTheme:drawRect(type, x1, y1, x2, y2, color)
  local x = x1
  local y = y1
  if x2 < x1 then x = x2 end
  if y2 < y1 then y = y2 end

  local w = math.abs(x1 - x2)
  local h = math.abs(y1 - y2)

  self:setColor(color)
  love.graphics.rectangle(type, x, y, w, h)
end

function gameboyTheme:LINE(x1, y1, x2, y2, color)
  love.graphics.setLineWidth(4.0)
  self:setColor(color)
  love.graphics.line(x1, y1, x2, y2)
end

function gameboyTheme:PSET(x, y, color)
  love.graphics.setPointSize(6.0)
  self:setColor(color)
  love.graphics.points({x, y})
end

function gameboyTheme:PSETS(pts, color)
  love.graphics.setPointSize(6.0)
  self:setColor(color)
  love.graphics.points(pts)
end

-- function gameboyTheme:IMG(image, x, y, xScaleFactor, yScaleFactor)
--   -- TODO: make the image look gameboy colors and resolution
--   love.graphics.draw(image, x, y, 0, xScaleFactor, yScaleFactor, 0, 0)
-- end

return gameboyTheme
