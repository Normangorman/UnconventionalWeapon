local level = LevelManager.levelTemplate()

function level.load()
  level.UI = UIManager.new()
  level.UI:registerEvents()

  local windowWidth = love.window.getWidth()
  local windowHeight = love.window.getHeight()

  local windowMiddle = windowWidth / 2
  
  local largeFont = love.graphics.newFont("Assets/ASMAN.TTF", 80)
  local mediumFont = love.graphics.newFont("Assets/ASMAN.TTF", 40)
  local smallFont = love.graphics.newFont("Assets/ASMAN.TTF", 20)

  local title = Text.new("Instructions", 0, 100, windowWidth, "center", nil, largeFont)

  local instructions = [[
    Your weapon is your mirror.

    Don't get hit by the laser beams!

    Use the mouse to rotate the mirror about yourself and reflect the beams back at the enemies.

    Kill as many enemies as possible to get the highest score.
  ]]

  local instructionText = Text.new(instructions, 0, 300, windowWidth, "center", nil, smallFont)

  local backButton = Button.new(windowMiddle - 150, windowHeight - 150, 300, 100, {
      image = love.graphics.newImage("Assets/menu_button_unselected.png"),
      mouseoverImage = love.graphics.newImage("Assets/menu_button_selected.png"),
      text = "Back",
      textFont = mediumFont,
      callback = function() LEVEL_MANAGER:changeLevel("menu") end
  })

  level.UI:addWidget(title)
  level.UI:addWidget(instructionText)
  level.UI:addWidget(backButton)

  level.backgroundImage = love.graphics.newImage("Assets/background_960x800.png")
end

function level.update(dt)
  level.UI:update(dt)
end

function level.draw()
  love.graphics.draw(level.backgroundImage, 0, 0)
  level.UI:draw()
end

return level
