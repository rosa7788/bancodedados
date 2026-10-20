--CRIAR UM NOVO BD:
-- =========================================================
-- CRIAÇÃO DO BANCO
-- =========================================================
CREATE DATABASE REVISAO2026
GO

USE REVISAO2026
GO

-- =========================================================
-- CRIAÇÃO DAS TABELAS
-- =========================================================
CREATE TABLE categoria(
    codCat INT PRIMARY KEY IDENTITY(1,1),
    nomeCat varchar(50)
)
GO

CREATE TABLE produto(
    codPro INT PRIMARY KEY IDENTITY(1,1),
    descricao varchar(100) NOT NULL,
    codBarras varchar(30) NULL,  -- alterado para NULL (ou usar DEFAULT), pois nem todo INSERT informa esse campo
    estoque INT NULL,
    codCat INT FOREIGN KEY REFERENCES categoria(codCat)  -- corrigido: era "PRIMARY FOREIGN KEY"
)
GO

-- =========================================================
-- INSERÇÃO DE DADOS
-- =========================================================
INSERT INTO categoria (nomeCat)
VALUES ('BEBIDAS'),
       ('ALIMENTOS'),
       ('HIGIENE'),
       ('LIMPEZA'),
       ('ELETRONICOS')
GO

INSERT INTO produto (descricao, codBarras, estoque, codCat)
VALUES ('COCA COLA',    '08787373', 400, 1),
       ('PEPSI',        '78786767', 300, 1),
       ('ARROZ',        '3488493',  220, 2),
       ('SABÃO EM PÓ',  '544656',   90,  4),
       ('SHAMPOO',      '6598498',  100, 3),
       ('NOTEBOOK',     '9873487',  180, 5)
GO

-- =========================================================
-- ATUALIZAÇÃO DE ESTOQUE
-- =========================================================
UPDATE produto SET estoque = 350
WHERE codPro = 4
GO

-- =========================================================
-- CONSULTA - produtos com estoque acima de 500
-- (nenhum produto atende a essa condição no momento, mas a sintaxe está correta)
-- =========================================================
SELECT descricao, codBarras, estoque
FROM produto
WHERE estoque > 500
GO

-- =========================================================
-- EXCLUSÃO DE PRODUTOS DA CATEGORIA 3
-- =========================================================
DELETE FROM produto
WHERE codCat = 3
GO

-- =========================================================
-- INSERÇÃO DE NOVO PRODUTO (sem código de barras)
-- =========================================================
INSERT INTO produto (descricao, estoque, codCat)
VALUES ('CELULAR', 850, 5)
GO

-- =========================================================
-- REMOÇÃO DA COLUNA codBarras
-- =========================================================
ALTER TABLE produto
DROP COLUMN codBarras
GO

-- =========================================================
-- CONSULTA ORDENADA POR ESTOQUE
-- =========================================================
SELECT descricao, estoque
FROM produto
ORDER BY estoque DESC  -- corrigido: era "estoqye"
GO

-- =========================================================
-- ADIÇÃO DA COLUNA PREÇO
-- =========================================================
ALTER TABLE produto
ADD preco MONEY
GO

-- =========================================================
-- EXCLUSÃO DE PRODUTOS



    