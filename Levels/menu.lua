local menu = LevelManager.levelTemplate()

function menu.load()
  menu.UI = UIManager.new()

  local windowWidth = love.window.getWidth()
  local windowHeight = love.window.getHeight()

  local windowMiddle = windowWidth / 2
  
  local largeFont = love.graphics.newFont("Assets/ASMAN.TTF", 80)
  local titleText = Text.new("Neon Mirror", 0, 100, windowWidth, "center", nil, largeFont)

  local mediumFont = love.graphics.newFont("Assets/ASMAN.TTF", 40)
  local buttonText = Text.new("Play", 0, 200, windowWidth, "center", nil, mediumFont)

  if HIGH_SCORE ~= nil then
      local highScoreText = Text.new("High score: "..tostring(HIGH_SCORE), 0, 650, windowWidth, "center", nil, largeFont)
      menu.UI:addWidget(highScoreText)
  end


  local playButton = Button.new(windowMiddle - 150, 300, 300, 100, {
      image = love.graphics.newImage("Assets/menu_button_unselected.png"),
      mouseoverImage = love.graphics.newImage("Assets/menu_button_selected.png"),
      text = "Play!",
      textFont = mediumFont,
      callback = function() LEVEL_MANAGER:changeLevel("level1") end
  })

  local instructionsButton = Button.new(windowMiddle - 150, 440, 300, 100, {
      image = love.graphics.newImage("Assets/menu_button_unselected.png"),
      mouseoverImage = love.graphics.newImage("Assets/menu_button_selected.png"),
      text = "Instructions",
      textFont = mediumFont,
      callback = function() LEVEL_MANAGER:changeLevel("instructions") end
  })

  menu.UI:addWidget(titleText)
  menu.UI:addWidget(playButton)
  menu.UI:addWidget(instructionsButton)

  menu.backgroundImage = love.graphics.newImage("Assets/background_960x800.png")
end

function menu.update(dt)
  menu.UI:update(dt)
  local mx, my = love.mouse:getPosition()
end

function menu.draw()
  love.graphics.draw(menu.backgroundImage, 0, 0)
  menu.UI:draw()
end

function menu.mousepressed(mx,my,button)
    menu.UI:mousepressed(mx, my, button)
end

return menu
