
function menuLoad()
	lMath.setRandomSeed(os.time())
	lw.setMode(400, 400, {resizable=false, centered=true})

	state = "menu"
	markedBombs = 0
	
	btnEasy = {}
	btnEasy.x =	100
	btnEasy.y = lg.getHeight()/2 - 50
	btnEasy.w = 200
	btnEasy.h = 50
	btnEasy.hover = false

	btnMed = {}
	btnMed.x = 100
	btnMed.y = lg.getHeight()/2 + 25
	btnMed.w = 200
	btnMed.h = 50
	btnMed.hover = false

	btnHard = {}
	btnHard.x = 100
	btnHard.y = lg.getHeight()/2 + 100
	btnHard.w = 200
	btnHard.h = 50
	btnHard.hover = false

	gTimer = {}
	gTimer.x = lg.getWidth()-60
	gTimer.y = lg.getHeight()-50
	gTimer.w = 50
	gTimer.h = 30
	gTimer.val = 0

	gBomb = {}
	gBomb.x = 10
	gBomb.y = lg.getHeight()-50
	gBomb.w = 50
	gBomb.h = 30
	gBomb.val = 0
	
end

function menuUpdate(dt)
	local mx, my = lm.getPosition()
	btnEasy.hover = false
	btnMed.hover = false
	btnHard.hover = false

	if mx < btnEasy.x + btnEasy.w and btnEasy.x < mx and my < btnEasy.y + btnEasy.h and btnEasy.y < my then
		btnEasy.hover = true
	elseif mx < btnMed.x + btnMed.w and btnMed.x < mx and my < btnMed.y + btnMed.h and btnMed.y < my then
		btnMed.hover = true
	elseif mx < btnHard.x + btnHard.w and btnHard.x < mx and my < btnHard.y + btnHard.h and btnHard.y < my then
		btnHard.hover = true
  	end

end

function menuDraw()
	lg.setColor(255, 255, 255)
	lg.rectangle("fill", btnEasy.x, btnEasy.y, btnEasy.w, btnEasy.h)
	lg.rectangle("fill", btnMed.x, btnMed.y, btnMed.w, btnMed.h)
	lg.rectangle("fill", btnHard.x, btnHard.y, btnHard.w, btnHard.h)

	lg.setColor(50, 255, 50, 180)
	if btnEasy.hover then
		lg.rectangle("fill", btnEasy.x, btnEasy.y, btnEasy.w, btnEasy.h)
	elseif btnMed.hover then
		lg.rectangle("fill", btnMed.x, btnMed.y, btnMed.w, btnMed.h)
	elseif btnHard.hover then
		lg.rectangle("fill", btnHard.x, btnHard.y, btnHard.w, btnHard.h)
	end

	lg.setFont(font36)
	lg.setColor(255, 255, 255)
	lg.printf("MINESWEEPER", 0, 75, lg.getWidth(), "center")

	lg.setFont(font20)
	lg.setColor(0, 0, 0)
	lg.printf("EASY", btnEasy.x, btnEasy.y+15, btnEasy.w, "center")
	lg.printf("MEDIUM", btnMed.x, btnMed.y+15, btnMed.w, "center")
	lg.printf("HARD", btnHard.x, btnHard.y+15, btnHard.w, "center")
end

function menuClick(mx, my, btn)
	if mx < btnEasy.x + btnEasy.w and btnEasy.x < mx and my < btnEasy.y + btnEasy.h and btnEasy.y < my then
		gameStart("easy")
	elseif mx < btnMed.x + btnMed.w and btnMed.x < mx and my < btnMed.y + btnMed.h and btnMed.y < my then
		gameStart("med")
	elseif mx < btnHard.x + btnHard.w and btnHard.x < mx and my < btnHard.y + btnHard.h and btnHard.y < my then
		gameStart("hard")
  	end
end


function gameStart(mode)
	numRows, numColumns, numBombs = nil, nil, nil
	state = mode
	gTimer.val = 0
	markedBombs = 0

	if state == "easy" then
		numRows = 10
		numColumns = 10
		numBombs = 10

	elseif state == "med" then
		numRows = 15
		numColumns = 15
		numBombs = 25

	elseif state == "hard" then
		numRows = 20
		numColumns = 30
		numBombs = 99
	end

	lw.setMode(numColumns*30 + 5, numRows*30 + 50, {resizable=false, centered=true})
	gTimer.x = lg.getWidth()-60
	gTimer.y = lg.getHeight()-40
	gBomb.x = 10
	gBomb.y = lg.getHeight()-40

	tiles = {}
	row = {}

	for x = 1, numRows+2 do
		row[x] = {}
		row[x].column = {}

		for y = 1, numColumns+2 do
			if x == 1 or x == numRows + 2 or y == 1 or y == numColumns + 2 then
				tiles[#tiles+1] = tile:new(x, y, "border")
			else
				tiles[#tiles+1] = tile:new(x, y)
			end
			row[x].column[y] = tiles[#tiles]
		end
	end

	b = 0
	while b ~= numBombs do
		local rnd = lMath.random(#tiles)
		if not tiles[rnd].isBomb and tiles[rnd].mode ~= "border" then
			tiles[rnd].isBomb = true
			b = b+1
		end
	end

	for x = 2, #row-1 do
		for y = 2, #row[x].column-1 do
			if row[x-1].column[y-1].isBomb then row[x].column[y].prox = row[x].column[y].prox + 1 end 	-- top		left
			if row[x-1].column[y].isBomb then row[x].column[y].prox = row[x].column[y].prox + 1 end 	-- top		mid
			if row[x-1].column[y+1].isBomb then row[x].column[y].prox = row[x].column[y].prox + 1 end 	-- top		right

			if row[x].column[y-1].isBomb then row[x].column[y].prox = row[x].column[y].prox + 1 end 	-- mid		left
			if row[x].column[y+1].isBomb then row[x].column[y].prox = row[x].column[y].prox + 1 end 	-- mid		right

			if row[x+1].column[y-1].isBomb then row[x].column[y].prox = row[x].column[y].prox + 1 end 	-- bottom	left
			if row[x+1].column[y].isBomb then row[x].column[y].prox = row[x].column[y].prox + 1 end 	-- bottom	mid
			if row[x+1].column[y+1].isBomb then row[x].column[y].prox = row[x].column[y].prox + 1 end 	-- bottom	right
		end
	end

end
