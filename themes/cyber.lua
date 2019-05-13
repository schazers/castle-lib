local moonshine = require 'moonshine'

local filterEffect = nil

cyberTheme = {
  name = 'cyber',
  music = 'jamesshinra.mp3',
  colors = {
    black = {0, 0, 0},
    white = {1, 1, 1},
    gray = {.65, .65, .65},
    red = {249/255, 140/255, 182/255},
    green = {145/255, 210/255, 144/255},
    blue = {154/255, 206/255, 223/255},
    yellow = {255/255, 250/255, 129/255},
    orange = {252/255, 169/255, 133/255},
    purple = {165/255, 137/255, 193/255},
    cyan = {204/255, 236/255, 239/255},
  }
}

-- TODO: get and load all sounds (use pre-fetch API), load em into mem
-- TODO: get all images, pre-fetch 'em by default, load em into mem
function cyberTheme:INIT()
  Sounds['themes/'..self.music] = Sound:new('themes/'..self.music, 3)
  -- TODO: load or pre-process any existing images which are in 'Imgs'
  network.async(function()
    filterEffect = moonshine(moonshine.effects.fastgaussianblur)
    filterEffect.fastgaussianblur.taps = 3
  end)
end

function cyberTheme:DRAW(drawFunc)
  if filterEffect then
    filterEffect(drawFunc)
  end
end

-- TODO: need to call love's getColor and then setColor back to before after calling
-- each method. see IMG(...) below for code that does this

-- TODO: fixed pallette? rgb?
-- TODO: choose a set of pallete presets?
-- TODO: see ayla/paul's infra-code
function cyberTheme:setColor(color)
  if self.colors[color] then
    color = self.colors[color]
  end

  love.graphics.setColor(color[1], color[2], color[3], 1.0)
end

-- TODO: use size and font
-- TODO: pre-fetch font in load
function cyberTheme:TEXT(message, x, y, scale, color, font)
  if message ~= nil then
    self:setColor(color)
    love.graphics.print(message, x, y, 0, scale, scale)
  end
end

return cyberTheme
