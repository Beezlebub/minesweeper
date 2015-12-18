tile = class('tile')

function tile:initialize(x, y, mode)
	self.tileX = x
	self.tileY = y
	self.x = ((x-2) * 30)+5
	self.y = ((y-2) * 30)+5
	self.w = 25
	self.mode = mode or "hidden"
	self.isBomb = false
	self.hover = false
	self.prox = 0
end

function tile:update(dt)
	if self.mode ~= "open" then
		local mx, my = lm.getPosition()
		self.hover = false

		if mx < self.x + self.w and self.x < mx and my < self.y + self.w and self.y < my then
			self.hover = true
	  	end
	end
end

function tile:draw()
	if self.mode ~= "border" then
		if self.mode ~= "open" then
			lg.setColor(200, 200, 200)
		else
			if self.prox == 0 and not self.isBomb then
				lg.setColor(160, 160, 160)
			elseif self.prox == 1 and not self.isBomb then
				lg.setColor(80, 180, 80)
			elseif self.prox == 2 and not self.isBomb then
				lg.setColor(80, 180, 80)
			elseif self.prox == 3 and not self.isBomb then
				lg.setColor(80, 150, 80)
			elseif self.prox == 4 and not self.isBomb then
				lg.setColor(100, 130, 80)
			elseif self.prox == 5 and not self.isBomb then
				lg.setColor(130, 100, 80)
			elseif self.prox == 6 and not self.isBomb then
				lg.setColor(150, 80, 80)
			elseif self.prox == 7 and not self.isBomb then
				lg.setColor(180, 80, 80)
			elseif self.prox == 8 and not self.isBomb then
				lg.setColor(200, 80, 80)
			end
		end

		lg.rectangle("fill", self.x, self.y, self.w, self.w)

		if self.isBomb and self.mode == "open" then
			lg.setColor(150, 150, 150)
			lg.rectangle("fill", self.x, self.y, self.w, self.w)
			lg.setColor(0, 0, 0, 150)
			lg.circle("fill", self.x+self.w/2, self.y+self.w/2, self.w/2)
			lg.setColor(255, 50, 50, 150)
			lg.circle("fill", self.x+self.w/2, self.y+self.w/2, self.w/3)
			lg.setColor(255, 255, 255)
			lg.line(self.x, self.y, self.x + self.w, self.y + self.w)
			lg.line(self.x, self.y + self.w, self.x + self.w, self.y)
			state = "end"
		end

		if self.mode ~= "open" then
			if self.hover then
				lg.setColor(50, 180, 50, 120)
				lg.rectangle("fill", self.x+2, self.y+2, self.w-4, self.w-4)
			end

			if self.mode == "flagged" then
				lg.setColor(0, 0, 0, 150)
				lg.circle("fill", self.x+self.w/2, self.y+self.w/2, self.w/2)
				lg.setColor(255, 50, 50, 150)
				lg.circle("fill", self.x+self.w/2, self.y+self.w/2, self.w/3)
			elseif self.mode == "question" then
				lg.setFont(font20)
				lg.setColor(0, 0, 0)
				lg.printf("?", self.x, self.y+2, self.w, "center")
			end
		end
		
		if self.prox > 0 and not self.isBomb and self.mode == "open" then
			lg.setColor(0, 0, 0)
			lg.setFont(font20)
			lg.printf(self.prox, self.x, self.y+2, self.w, "center")
		end
	end
end
