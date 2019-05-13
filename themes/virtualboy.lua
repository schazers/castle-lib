local moonshine = require 'moonshine'

local filterEffect = nil

virtualBoyTheme = {
  name = 'virtualboy',
  music = 'virtualboy.mp3',
  colors = {
    black = {0, 0, 0},
    white = {1, .08, .08},
    gray = {1, .08, .08},
    red = {1, .08, .08},
    green = {1, .08, .08},
    blue = {1, .08, .08},
    yellow = {1, .08, .08},
    orange = {1, .08, .08},
    purple = {1, .08, .08},
    cyan = {1, .08, .08},
  }
}

-- TODO: get and load all sounds (use pre-fetch API), load em into mem
-- TODO: get all images, pre-fetch 'em by default, load em into mem
function virtualBoyTheme:INIT()
  Sounds['themes/'..self.music] = Sound:new('themes/'..self.music, 3)
  -- TODO: load or pre-process any existing images which are in 'Imgs'
  network.async(function()
    filterEffect = moonshine(moonshine.effects.glow)
      .chain(moonshine.effects.pixelate)
      .chain(moonshine.effects.scanlines)
      filterEffect.pixelate.size = {2, 2}
      filterEffect.scanlines.opacity = 0.7
      filterEffect.scanlines.width = 1.0
      filterEffect.glow.strength = 10.0
      filterEffect.glow.min_luma = 0.2
  end)
end

function virtualBoyTheme:DRAW(drawFunc)
  if filterEffect then
    filterEffect(drawFunc)
  end
end

-- TODO: need to call love's getColor and then setColor back to before after calling
-- each method. see IMG(...) below for code that does this

-- TODO: fixed pallette? rgb?
-- TODO: choose a set of pallete presets?
-- TODO: see ayla/paul's infra-code
function virtualBoyTheme:setColor(color)
  if self.colors[color] then
    color = self.colors[color]
  end

  love.graphics.setColor(color[1], color[2], color[3], 1.0)
end

function virtualBoyTheme:LINE(x1, y1, x2, y2, color)
  love.graphics.setLineWidth(4.0)
  self:setColor(color)
  love.graphics.line(x1, y1, x2, y2)
end

-- TODO: bugged. set exact point somehow
function virtualBoyTheme:PSET(x, y, color)
  love.graphics.setPointSize(3.0)
  self:setColor(color)
  love.graphics.points({x, y})
end

function virtualBoyTheme:PSETS(pts, color)
  love.graphics.setPointSize(3.0)
  self:setColor(color)
  love.graphics.points(pts)
end

return virtualBoyTheme
