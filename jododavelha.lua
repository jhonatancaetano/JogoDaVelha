require("util")
require("AnAL")

local JogoDaVelha = {}
JogoDaVelha.__index = JogoDaVelha


local JDV_IMG_WIDTH = 400
local JDV_IMG_HEIGHT = 400
local LINHA_WIDTH = 14
local LINHA_HEIGHT = 12

local IMG_WIDTH = 100
local IMG_HEIGHT = 50

local MINI_IMG_WIDTH = 40
local MINI_IMG_HEIGHT = 20

local A_WIDTH = JDV_IMG_WIDTH / 3
local B_HEIGHT = JDV_IMG_HEIGHT / 3

local symBolCtr = "x"

---Função para criação do jogo...
function novoJogoDaVelha()
	local jv= {}
	love.window.setMode(WIDTH, HEIGHT, {resizable=false})
	love.graphics.setBackgroundColor(255, 255, 255)
  
  --- Imagem de fundo a as imagens do X e O do jogo...
	jv.imgTtt = love.graphics.newImage("imgs/velha_.png")
	jv.imgX  = love.graphics.newImage("imgs/x_img.png")
	jv.imgO = love.graphics.newImage("imgs/circle_.png")
  
  --- Criando o x...
  --- Colocando o x na posição direita com a pontuação ao lado...
  jv.XPontos = {}
  jv.XPontos.pos = {}
  jv.XPontos.pos.x = WIDTH - MINI_IMG_WIDTH * 3
  jv.XPontos.pos.y = 200
  jv.XPontos.img = love.graphics.newImage("imgs/x_mini_img.png")
  jv.XPontos.num = 0

  --- Criano o O...
  --- Colocando o O na posição direita com a pontuação ao lado...
  jv.OPontos = {}
  jv.OPontos.pos = {}
  jv.OPontos.pos.x = WIDTH - MINI_IMG_WIDTH * 3
  jv.OPontos.pos.y = 200 + MINI_IMG_HEIGHT*2
  jv.OPontos.img = love.graphics.newImage("imgs/circle_mini_img.png") 
  jv.OPontos.num = 0
  
  --- Colocando a posição do jogo da tela...
	jv.jdvPos = PosicaoCentral(WIDTH, HEIGHT, JDV_IMG_WIDTH, JDV_IMG_HEIGHT)
  jv.jdvPos.x = jv.jdvPos.x - 50
	jv.jdvMapa = {}
	jv.jdvMapa = criarMapa(jv.jdvPos.x, jv.jdvPos.y, A_WIDTH + LINHA_WIDTH, B_HEIGHT + LINHA_HEIGHT, 3, 3)
  
  jv.aparecer = {}

  --A linha não pode ser nula... 
  jv.linha = nil
  jv.FimdeJogo = false
  
  ---Dando o título para tela...
  love.window.setTitle("Jogo da Velha")

	return setmetatable(jv, JogoDaVelha)
	
end

--Função para reiniciar o jogo...  
function JogoDaVelha:reset()
  self.jdvMapa = {}
	self.jdvMapa = criarMapa(self.jdvPos.x, self.jdvPos.y, A_WIDTH + LINHA_WIDTH, B_HEIGHT + LINHA_HEIGHT, 3, 3)
  self.FimdeJogo = false
  self.aparecer = {}
  self.linha = nil
end

--Função 
function JogoDaVelha:criarLinha(pos1, pos2, incX1, incY1, incX2, incY2)
  self.linha = {}

  local p1 = {}
  local p2 = {}  
  
  p1.x = self.jdvMapa[pos1].x + incX1
  p1.y = self.jdvMapa[pos1].y + incY1
  p2.x = self.jdvMapa[pos2].x + incX2
  p2.y = self.jdvMapa[pos2].y + incY2

  table.insert(self.linha, p1)
  table.insert(self.linha, p2)
  
end
-- Função para fazer a linha preta em cima da linha vencedora...
function JogoDaVelha:Linhas()
  local a = 1
  local cntX = 0
  local cntO = 0
  --Criando as 3 linhas
  for i = 1, 3 do  
		for j = 1, 3 do    
			if (self.jdvMapa[a].sybom == "x") then
				cntX = cntX + 1
			elseif (self.jdvMapa[a].sybom == "c") then
				cntO = cntO + 1
			end
    
			a = a + 1
    end
    --Calculo da pontuação...
    if (cntX == 3 or cntO == 3) then
      self.criarLinha(self, a-3, a-1, 0, B_HEIGHT / 2, A_WIDTH / 2, B_HEIGHT / 2)
      if (cntX == 3) then
        self.XPontos.num = self.XPontos.num + 1
      else
        self.OPontos.num = self.OPontos.num + 1
      end

      return true
    end
    
    cntX = 0
    cntO = 0
  end
  
  return false
end
--Função para fazer a linha preta em cima da coluna vencedora...
function JogoDaVelha:Colunas()
  local a = nil
  local cntX = 0
  local cntO = 0
  
  for i = 1, 3 do
    a = i
		for j = 1, 3 do
      if (a <= 9) then 
        if (self.jdvMapa[a].sybom == "x") then
          cntX = cntX + 1
        elseif (self.jdvMapa[a].sybom == "c") then
          cntO = cntO + 1
        end
        a = a + 3
      end
    end
    --Calculo da pontuação...
    if (cntX == 3 or cntO == 3) then      
      self.criarLinha(self, a-9, a-3, A_WIDTH / 3 + 5, B_HEIGHT / 2 - 20, 
        A_WIDTH / 3 + 5, B_HEIGHT / 2 + 20)
      if (cntX == 3) then
        self.XPontos.num = self.XPontos.num + 1
      else
        self.OPontos.num = self.OPontos.num + 1
      end
      return true
    end
    cntX = 0
    cntO = 0
  end
  return false  
end

--Função para conferir as diagonais 
function JogoDaVelha:checarDiagonal(initPos, difPos, sybom)
  if (self.jdvMapa[initPos].sybom == sybom and self.jdvMapa[initPos+difPos].sybom == sybom and
  self.jdvMapa[initPos + difPos + difPos].sybom == sybom) then  
     --Calculo da pontuação...
    if (sybom == "x") then
      self.XPontos.num = self.XPontos.num + 1
    else
      self.OPontos.num = self.OPontos.num + 1
    end
    return true
  end
  return false
end


--Função para fazer a linha preta nas diagonais vencedoras...
function JogoDaVelha:Diagonal()
  -- checar diagonal com os mesmos números (1,1) (2,2) (3,3)...
  if (self.checarDiagonal(self, 1, 4, "x") or self.checarDiagonal(self, 1, 4, "c")) then
      self.criarLinha(self, 1, 9, A_WIDTH / 3, B_HEIGHT / 2, 
      A_WIDTH / 3, B_HEIGHT / 2)  
      return true
  end
  
    -- checar diagonal com os numeros diferentes (1,3) (2,2) (3,1) com 'x'...
  if (self.checarDiagonal(self, 3, 2, "x") or self.checarDiagonal(self, 3, 2, "c")) then
      self.criarLinha(self, 3, 7, A_WIDTH / 3, B_HEIGHT / 2, 
      A_WIDTH / 3, B_HEIGHT / 2)  
      return true
  end
  
  return false

end

--Função para encerrar o jogo, caso tenha, uma linha, coluna ou diagonal completa...
function JogoDaVelha:Fim()
  
  if (self.FimdeJogo == true) then
    return true
  end
  
  if (self.Linhas(self) or self.Colunas(self) or self.Diagonal(self)) then
    self.FimdeJogo = true
    return true
  end
  
  return false
end

---Criação da função de empate...
function JogoDaVelha:Empate()
  if (self.FimdeJogo == true) then
    return true
  end
  
  for i = 1, #self.jdvMapa do
		if(self.jdvMapa[i].fill == false) then
        return false
    end
	end
  
  if (self.Fim(self) == true) then
    return false
  end
  
  self.FimdeJogo = true
  
  return true
end

function JogoDaVelha:printtttMap()
	
	for i = 1, #self.jdvMapa do
		print(self.jdvMapa[i].x .. " " .. self.jdvMapa[i].y)
	end
end

function JogoDaVelha:update(dt)
	for i = 1, #self.aparecer do
		self.aparecer[i].aparece:update(dt)
	end
end

--Função de desenho do jogo...
function JogoDaVelha:draw(dt)
   love.graphics.setColor(255, 255, 255)
  --Posição e imagem do jogo...
	love.graphics.draw(self.imgTtt, self.jdvPos.x, self.jdvPos.y)
  
  -- Desenhar o xis e o círculo na posição clicada
  for i = 1, #self.aparecer do
		self.aparecer[i].aparece:draw(self.aparecer[i].pos.x, self.aparecer[i].pos.y)
	end
  
  --Cor, grossura e posição da linha preta do vencedor...
  if (self.linha ~= nil) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(4)
    love.graphics.setLineStyle("smooth")
    love.graphics.line(self.linha[1].x, self.linha[1].y, self.linha[2].x, self.linha[2].y)
  end
  -- Manter a cor do xis e do circulo e colocar eles no conto direito da tela ao lado da pontuação...
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.XPontos.img, self.XPontos.pos.x, self.XPontos.pos.y)
  love.graphics.draw(self.OPontos.img, self.OPontos.pos.x, self.OPontos.pos.y)
  
  -- Cor e possição da pontuação do xis e do cícrculo...
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(self.XPontos.num, self.XPontos.pos.x + MINI_IMG_WIDTH + 10, 
    self.XPontos.pos.y)
  love.graphics.print(self.OPontos.num, self.OPontos.pos.x + MINI_IMG_WIDTH + 10, 
    self.OPontos.pos.y)
end

--Função de captura do clique do mouse
function JogoDaVelha:BloqueioPorClique(x, y)
	for i = 1, #self.jdvMapa do
		if (VerificaPosicaodoMouse(x, y, self.jdvMapa[i].x, self.jdvMapa[i].y, 
		A_WIDTH, B_HEIGHT) and self.jdvMapa[i].fill == false and self.Fim(self) == false
    and self.Empate(self) == false) then

			local pos = {}
			pos.x = self.jdvMapa[i].x
			pos.y = self.jdvMapa[i].y + B_HEIGHT / 3    
      
      local aparece = nil

			if (symBolCtr == "x") then  
        aparece = novaAnimacao(self.imgX, IMG_WIDTH, IMG_HEIGHT, 0.1, 0)
				self.jdvMapa[i].sybom = "x"
				symBolCtr = "c"
			else    
        aparece = novaAnimacao(self.imgO, IMG_WIDTH, IMG_HEIGHT, 0.1, 0)
				symBolCtr = "x"
				self.jdvMapa[i].sybom = "c"
			end
      
			self.jdvMapa[i].fill = true
      
      aparece:Modo("once")

			self.aparecer[#self.aparecer + 1] = {}
			
			self.aparecer[#self.aparecer].aparece = aparece
			self.aparecer[#self.aparecer].pos = pos

      break
		end
	end
  self.Fim(self)
  self.Empate(self)
end

