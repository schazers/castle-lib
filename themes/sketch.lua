local moonshine = require 'moonshine'

local filterEffect = nil

sketchTheme = {
  name = 'sketch',
  music = 'old_timey.mp3',
  colors = {
    black = {0, 0, 0},
    white = {1, 1, 1},
    gray = {.5, .5, .5},
    red = {0.75, 0.75, 0.75},
    green = {0.7, 0.7, 0.7},
    blue = {0.6, 0.6, 0.6},
    yellow = {0.95, 0.95, 0.95},
    orange = {0.8, 0.8, 0.8},
    purple = {0.85, 0.85, 0.85},
    cyan = {0.95, 0.95, 0.95},
  }
}

-- TODO: get and load all sounds (use pre-fetch API), load em into mem
-- TODO: get all images, pre-fetch 'em by default, load em into mem
function sketchTheme:INIT()
  Sounds['themes/'..self.music] = Sound:new('themes/'..self.music, 3)
  -- TODO: load or pre-process any existing images which are in 'Imgs'
  network.async(function()
    filterEffect = moonshine(moonshine.effects.sketch)
    .chain(moonshine.effects.fastgaussianblur)
    .chain(moonshine.effects.filmgrain)
    filterEffect.sketch.amp = 0.0007
    filterEffect.filmgrain.size = 4
    filterEffect.filmgrain.opacity = 0.7
    filterEffect.fastgaussianblur.taps = 5
  end)
end

function sketchTheme:DRAW(drawFunc)
  if filterEffect then
    filterEffect(drawFunc)
  end
end

return sketchTheme
