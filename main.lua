class = require 'tools.middleclass'
require 'tools.game'
require 'tools.tiles'
require 'tools.menu'

lg = love.graphics
lm = love.mouse
lMath = love.math
lw = love.window

font20 = love.graphics.newFont("tools/tahoma.ttf", 20)
font36 = love.graphics.newFont("tools/tahoma.ttf", 36)

function love.load()
	gameLoad()
end

function love.update(dt)
	gameUpdate(dt)
end

function love.draw()
	gameDraw()
end

function love.keypressed(key, i)
    gameKey(key, i)
end

function love.mousepressed(mx, my, btn)
    gameClick(mx, my, btn)
end

