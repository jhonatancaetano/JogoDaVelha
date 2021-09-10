require("util")
require("jododavelha")
require("botao")

function love.load()
    jdv = novoJogoDaVelha()
  	bReset = novoBotao()
end

--Função de atualização...
function love.update(dt)
  jdv:update(dt)
  bReset:update(dt, love.mouse.getX(), love.mouse.getY())
end

-- Função que determina o lugar marcado no jogo...
function love.mousepressed(x, y, botao, istouch, bt)
  --Determinar o clique através do botão 1 do mouse...
	if (botao == 1 or istouch == true) then
		jdv:BloqueioPorClique(x, y)
  if (bReset:clique(x, y)) then
    jdv:reset()
  end
end
end

--Função para reinicar o jogo...
function love.draw(dt)
	jdv:draw(dt)
  bReset:draw(dt)
end

