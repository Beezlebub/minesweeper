-- Configuration
function love.conf(t)
	t.title = "Minesweeper" -- The title of the window the game is in (string)
	t.version = "0.9.1"         -- The LÖVE version this game was made for (string)
	t.window.width = 400        -- we want our game to be long and thin.
	t.window.height = 400
	-- For Windows debugging
	t.console = false
end
