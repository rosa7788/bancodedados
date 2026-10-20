USE Revisao1Sem;

SELECT SUM(precoUnit) AS precoTotal
FROM produtos

SELECT descricao, estoque, precoUnit, estoque * precoUnit AS valorEstoque
FROM produtos

--AVG = calcula media

SELECT  AVG(preco) as PrecoMedio
FROM produto

--Round = função para arrrendondamentos
SELECT ROUND(12345,6789,2) AS PrecoMedio
FROM produto

--count = conta o numero de ocorrencias
SELECT COUNT(descricao)
FROM produto

