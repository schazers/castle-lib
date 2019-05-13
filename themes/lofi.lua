local moonshine = require 'moonshine'

local filterEffect = nil

lofiTheme = {
  name = 'lofi',
  music = 'lofi_1.mp3',
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
function lofiTheme:INIT()
  Sounds['themes/'..self.music] = Sound:new('themes/'..self.music, 3)
  -- TODO: load or pre-process any existing images which are in 'Imgs'
  network.async(function()
    filterEffect = moonshine(moonshine.effects.glow)
    .chain(moonshine.effects.fastgaussianblur)
    .chain(moonshine.effects.godsray)
    filterEffect.fastgaussianblur.taps = 3
    filterEffect.glow.strength = 1.0
    filterEffect.glow.min_luma = 0.4
  end)
  
end

function lofiTheme:DRAW(drawFunc)
  if filterEffect then
    filterEffect(drawFunc)
  end
end

return lofiTheme
