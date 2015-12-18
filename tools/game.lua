
function gameLoad()
	menuLoad()
end

function gameUpdate(dt)
	if state == "menu" then
		menuUpdate(dt)
	else
		for i, tile in ipairs(tiles) do
			tile:update(dt)
		end

		-- Check Win
		local didWin = true

		for i, tile in ipairs(tiles) do 
			if tile.isBomb and tile.mode ~= "flagged" then
				didWin = false
			end
		end

		if didWin then
			state = "win"
		end
		
		if state == "easy" or state == "med" or state == "hard" then
			gTimer.val = gTimer.val + 1*dt
  			gBomb.val = numBombs - markedBombs
		end
	end
end

function gameDraw()
	lg.setColor(200, 50, 50)
	lg.rectangle("fill", 0, 0, lg.getWidth(), lg.getHeight())

	if state == "menu" then
		menuDraw()
	else
		for i, tile in ipairs(tiles) do
			tile:draw()
		end

		if state == "win" or state == "end" then
			lg.setColor(180, 20, 20)
			lg.rectangle("fill", lg.getWidth()/2-125, lg.getHeight()/2-100, 250, 200)
			lg.setColor(255, 255, 255)
			lg.rectangle("line", lg.getWidth()/2-120, lg.getHeight()/2-95, 240, 190)


			lg.setFont(font20)
			lg.setColor(255, 255, 255)
			lg.printf("PRESS F2 TO RESTART", 0, lg.getHeight()/2+5, lg.getWidth(), "center")

			lg.setFont(font36)
			if state == "win" then
				lg.printf("YOU WIN", 0, lg.getHeight()/2-30, lg.getWidth(), "center")
			else			
				lg.printf("GAME OVER", 0, lg.getHeight()/2-30, lg.getWidth(), "center")
			end
		end

		-- HUD

		lg.setColor(50, 50, 50)
		lg.rectangle("fill", gTimer.x, gTimer.y, gTimer.w, gTimer.h)
		lg.rectangle("fill", gBomb.x, gBomb.y, gBomb.w, gBomb.h)

		lg.setColor(200, 200, 200)
		lg.rectangle("line", gTimer.x, gTimer.y, gTimer.w, gTimer.h)
		lg.rectangle("line", gBomb.x, gBomb.y, gBomb.w, gBomb.h)

		lg.setFont(font20)
		lg.setColor(255, 255, 255)
		lg.printf(math.floor(gTimer.val), gTimer.x, gTimer.y+5, gTimer.w, "center")
		lg.printf(gBomb.val, gBomb.x, gBomb.y+5, gBomb.w, "center")

	end


end

function gameKey(key, unicode)
	if key == "escape" then love.event.quit() end
	if key == "f2" then
		if state ~= "menu" then
			state = "menu"
			lw.setMode(400, 400, {resizable=false, centered=true})
		end
	end
end

function openEmpty(x, y)
	if row[x-1].column[y-1].mode == "hidden" then
		row[x-1].column[y-1].mode = "open"
		if row[x-1].column[y-1].prox == 0 	then openEmpty(x-1, y-1) end	-- top	left	
	end
	
	if row[x-1].column[y].mode == "hidden" then
		row[x-1].column[y].mode = "open"
		if row[x-1].column[y].prox == 0 	then openEmpty(x-1, y) end  	-- top	mid
	end
	
	if row[x-1].column[y+1].mode == "hidden" then
		row[x-1].column[y+1].mode = "open"
		if row[x-1].column[y+1].prox == 0  	then openEmpty(x-1, y+1) end 	-- top	right			

	end

	
	if row[x].column[y-1].mode == "hidden" then
		row[x].column[y-1].mode = "open"
		if row[x].column[y-1].prox == 0 	then openEmpty(x, y-1) end 		-- mid	left
	end
	
	if row[x].column[y].mode == "hidden" then
		row[x].column[y].mode = "open"
		if row[x].column[y].prox == 0 	then openEmpty(x, y) end 		-- mid	mid
	end
	
	if row[x].column[y+1].mode == "hidden" then
		row[x].column[y+1].mode = "open"
		if row[x].column[y+1].prox == 0 	then openEmpty(x, y+1) end 		-- mid	right

	end
		
	
	if row[x+1].column[y-1].mode == "hidden" then
		row[x+1].column[y-1].mode = "open"
		if row[x+1].column[y-1].prox == 0 	then openEmpty(x+1, y-1) end 	-- bottom	left
	end
	
	if row[x+1].column[y].mode == "hidden" then
		row[x+1].column[y].mode = "open"
		if row[x+1].column[y].prox == 0 	then openEmpty(x+1, y) end 		-- bottom	mid
	end
	
	if row[x+1].column[y+1].mode == "hidden" then
		row[x+1].column[y+1].mode = "open"
		if row[x+1].column[y+1].prox == 0 	then openEmpty(x+1, y+1) end 	-- bottom	right
	end
end

function gameClick(mx, my, btn)
	if state ~= "menu" then
		if btn == "l" then
			for i, tile in ipairs(tiles) do 
				if mx < tile.x + tile.w and tile.x < mx and my < tile.y + tile.w and tile.y < my then
					if tile.mode == "hidden" then
						tile.mode = "open"
						if tile.prox == 0 then
							openEmpty(tile.tileX, tile.tileY)
						end
					end
				end
			end
		elseif btn == "r" then
			for i, tile in ipairs(tiles) do 
				if mx < tile.x + tile.w and tile.x < mx and my < tile.y + tile.w and tile.y < my then
					if tile.mode == "hidden" then
						tile.mode = "flagged"
						markedBombs = markedBombs + 1
					elseif tile.mode == "flagged" then
						tile.mode = "question"
						markedBombs = markedBombs - 1
					elseif tile.mode == "question" then
						tile.mode = "hidden"
					end
				end
			end
		end
	else
		menuClick(mx, my, btn)
	end
end


