--Tamanho da tela...
WIDTH  = 800
HEIGHT = 600

--Função para centralizar a posição... 
function PosicaoCentral(winW, winH, objW, objH)
	pos = {}

	pos.x = (winW - objW) / 2
	pos.y = (winH - objH) / 2

	return pos
end

--Função de Verificação de Posição do Mouse...
function VerificaPosicaodoMouse(mouseX, mouseY, objX, objY, objW, objH)

	if (not (mouseY >= objY and mouseY <= objY + objH)) then
		return false
	end
	if (not (mouseX >= objX and mouseX <= objX + objW)) then
		return false
	end

	return true

end 

--Função de Criação do Mapa...
function criarMapa(x, y, incX, incY, dl, dc)

	local mapa = {}
	local curX = x
	local curY = y
	
	local a = 1

	for i = 1, dl do
		for j = 1, dc do
      -- Criação da tabela do mapa de jogo...
			table.insert(mapa, {})
			mapa[a].x = curX
			mapa[a].y = curY
      --Preenchimento do mapa tem que ser false, se for true não preenche...
			mapa[a].fill = false
			mapa[a].sybom = "a"
			curX = curX + incX
			a = a + 1
		end
		curX = x
		curY = curY + incY 
	end

	return mapa

end
