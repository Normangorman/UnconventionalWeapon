local menu = LevelManager.levelTemplate()

function menu.load()
  menu.UI = UIManager.new()
  menu.UI:registerEvents()

  local windowWidth = love.window.getWidth()
  local windowHeight = love.window.getHeight()

  local windowMiddle = windowWidth / 2
  
  local largeFont = love.graphics.newFont("Assets/ASMAN.TTF", 60)
  local titleText = Text.new("Neon Mirror", 0, 100, windowWidth, "center", nil, largeFont)

  local mediumFont = love.graphics.newFont("Assets/ASMAN.TTF", 40)
  local buttonText = Text.new("Play", 0, 200, windowWidth, "center", nil, mediumFont)

  local playButton = Button.new(windowMiddle - 150, 200, 300, 100, {
      image = love.graphics.newImage("Assets/menu_button_unselected.png"),
      mouseoverImage = love.graphics.newImage("Assets/menu_button_selected.png"),
      text = "Play!",
      textFont = mediumFont,
      callback = function() LEVEL_MANAGER.changeLevel("level1") end
  })

  local settingsButton = Button.new(windowMiddle - 150, 320, 300, 100, {
      image = love.graphics.newImage("Assets/menu_button_unselected.png"),
      mouseoverImage = love.graphics.newImage("Assets/menu_button_selected.png"),
      text = "Settings",
      textFont = mediumFont
  })

  local aboutButton = Button.new(windowMiddle - 150, 440, 300, 100, {
      image = love.graphics.newImage("Assets/menu_button_unselected.png"),
      mouseoverImage = love.graphics.newImage("Assets/menu_button_selected.png"),
      text = "About",
      textFont = mediumFont
  })

  menu.UI:addWidget(titleText)
  menu.UI:addWidget(playButton)
  menu.UI:addWidget(settingsButton)
  menu.UI:addWidget(aboutButton)

  menu.backgroundImage = love.graphics.newImage("Assets/background_960x800.png")
end

function menu.update(dt)
  menu.UI:update(dt)
end

function menu.draw()
  love.graphics.draw(menu.backgroundImage, 0, 0)
  menu.UI:draw()
end

return menu
