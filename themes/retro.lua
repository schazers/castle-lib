local moonshine = require 'moonshine'

local filterEffect = nil

retroTheme = {
  name = 'retro',
  music = 'retro_1.mp3',
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
function retroTheme:INIT()
  Sounds['themes/'..self.music] = Sound:new('themes/'..self.music, 3)
  -- TODO: load or pre-process any existing images which are in 'Imgs'
  network.async(function()
    filterEffect = moonshine(moonshine.effects.glow)
    --.chain(moonshine.effects.pixelate)
    .chain(moonshine.effects.crt)
    .chain(moonshine.effects.scanlines)
    filterEffect.glow.strength = 10.0
    filterEffect.glow.min_luma = 0.2
    --filter_effect.pixelate.size = {8, 4}
    --filter_effect.pixelate.feedback = 0.65
    filterEffect.crt.distortionFactor = {1.05, 1.06}
    filterEffect.scanlines.opacity = 1.0
    filterEffect.scanlines.thickness = 0.4
  end)
end

function retroTheme:DRAW(drawFunc)
  if filterEffect then
    filterEffect(drawFunc)
  end
end

function retroTheme:setColor(color)
  if self.colors[color] then
    color = self.colors[color]
  end

  love.graphics.setColor(color[1], color[2], color[3], 1.0)
end

function retroTheme:LINE(x1, y1, x2, y2, color)
  love.graphics.setLineWidth(3.0)
  self:setColor(color)
  love.graphics.line(x1, y1, x2, y2)
end

-- TODO: bugged. set exact point somehow
function retroTheme:PSET(x, y, color)
  love.graphics.setPointSize(3.0)
  self:setColor(color)
  love.graphics.points({x, y})
end

function retroTheme:PSETS(pts, color)
  love.graphics.setPointSize(3.0)
  self:setColor(color)
  love.graphics.points(pts)
end

return retroTheme
