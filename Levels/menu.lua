local menu = {}
local UI = UIManager.new()

function menu.load()
  local windowWidth = love.window.getWidth()
  local windowHeight = love.window.getHeight()

  local windowMiddle = windowWidth / 2
  
  local largeFont = love.graphics.newFont("Assets/ASMAN.TTF", 60)
  local titleText = Text.new("Neon Mirror", 0, 100, windowWidth, "center", nil, largeFont)

  local mediumFont = love.graphics.newFont("Assets/ASMAN.TTF", 30)
  local buttonText = Text.new("Play", 0, 200, windowWidth, "center", nil, mediumFont)

  UI:addWidget(titleText)
  UI:addWidget(buttonText)
end

function menu.update(dt)
  UI:update(dt)
end

function menu.draw()
  love.graphics.setBackgroundColor(00, 200, 00)
  UI:draw()
end

return menu
