require("util")

local Botao = {}
Botao.__index = Botao

--Função de criação do Botão de Atualização...
function novoBotao()
  local nb = {}
  --Imagens do Botão quando o mouse estiver sobre ele...
  nb.botaoDesligado = love.graphics.newImage("imgs/button_off.png")
  nb.botaoLigado =  love.graphics.newImage("imgs/button_on.png")
  
  nb.pos = {}
  --Posição do Botão na janela...
  nb.width = 100
  nb.height = 32
  --Defini a posição do botão na tela...
  nb.pos.x = WIDTH - nb.width
  nb.pos.y = HEIGHT - nb.height
  --Começar como botão desligado...
  nb.curImg = nb.botaoDesligado
  --Definir meta-tabela...
  return setmetatable(nb, Botao)
  
end

--Função para quando o botão for clicado...
function Botao:clique(mouseX, mouseY)
  if (VerificaPosicaodoMouse(mouseX, mouseY, self.pos.x, self.pos.y, self.width, self.height)) then
      return true
  end
  return false
end

--Função para atualizar, após o click do botão...
function Botao:update(dt, mouseX, mouseY)
  if (self.clique(self, mouseX, mouseY)) then
    self.curImg = self.botaoLigado
else
    self.curImg = self.botaoDesligado
  end
end

--Funçao pra desenhar, após a atualização...
function Botao:draw(dt)
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.curImg, self.pos.x, self.pos.y)
end
  
