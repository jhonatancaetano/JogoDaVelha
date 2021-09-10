local animacao = {}
animacao.__index = animacao

--Função de animação pra aparecer o clique do mouse
function novaAnimacao(imagem, fw, fh, d, f)
	local a = {}
	a.img = imagem
	a.fs = {}
	a.ds = {}
	a.tempo = 0
	a.posicao = 1
	a.fw = fw
	a.fh = fh
	a.jogo = true
	a.vel = 1
	a.modo = 1
	a.direcao = 1
	local imgw = imagem:getWidth()
	local imgh = imagem:getHeight()
	if f == 0 then
		f = imgw / fw * imgh / fh
	end
	local tlinha = imgw/fw
	for i = 1, f do
		local linha = math.floor((i-1)/tlinha)
		local coluna = (i-1)%tlinha
		local fm = love.graphics.newQuad(coluna*fw, linha*fh, fw, fh, imgw, imgh)
		table.insert(a.fs, fm)
		table.insert(a.ds, d)
	end
	return setmetatable(a, animacao)
end

function animacao:update(dt)
	if not self.jogo then return end
	self.tempo = self.tempo + dt * self.vel
	if self.tempo > self.ds[self.posicao] then
		self.tempo = self.tempo - self.ds[self.posicao]
		self.posicao = self.posicao + 1 * self.direcao
		if self.posicao > #self.fs then
			if self.modo == 1 then
				self.posicao = 1
			elseif self.modo == 2 then
				self.posicao = self.posicao - 1
				self:Fim()
			elseif self.modo == 3 then
				self.direcao = -1
				self.posicao = self.posicao - 1
			end
		elseif self.posicao < 1 and self.modo == 3 then
			self.direcao = 1
			self.posicao = self.posicao + 1
		end
	end
end
--Função de animação da draw
function animacao:draw(x, y, angulo, sx, sy, ox, oy)
	love.graphics.draw(self.img, self.fs[self.posicao], x, y, angulo, sx, sy, ox, oy)
end

function animacao:Fim()
	self.jogo = false
end

function animacao:Modo(modo)
	if modo == "loop" then
		self.modo = 1
	elseif modo == "once" then
		self.modo = 2
	elseif modo == "bounce" then
		self.modo = 3
	end
end
