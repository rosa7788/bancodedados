--CRIAR UM NOVO BD:
CREATE DATABASE REVISAO2026
GO
USE REVISAO2026

--CRIAÇÃO DAS TABELAS:
CREATE TABLE categoria(
    codCat INT PRIMARY KEY IDENTITY(1,1),
    nomeCat varchar(50)
)
CREATE TABLE produto(
    codPro INT PRIMARY KEY IDENTITY(1,1),
    descricao varchar(100),
    codBarras varchar(30),
    estoque int,
        codCat INT PRIMARY FOREIGN KEY
        REFERENCES categoria(codCat)
)

INSERT INTO categoria
VALUES ('BEBIDAS'),
('ALIMENTOS'),
('HIGIENE'),
('LIMPEZA'),
('ELETRONICOS')

INSERT INTO produto
VALUES ('COCA COLA', '08787373', 400, 1),
('PEPSI', '78786767', 300, 1),
('ARROZ', '3488493', 220, 2),
('SABÃO EM PÓ', '544656', 90, 4),
('SHAMPOO', '6598498', 100, 3),
('NOTEBOOK', '9873487', 180, 5)

UPDATE produto SET estoque = 350
WHERE codPro = 4

SELECT descricao, codBarras, estoque
FROM produto
WHERE estoque > 500

DELETE 
WHERE codCat = 3

INSERT INTO produto(descricao,estoque, codCat)
VALUES ('CELULAR', 850, 5)

ALTER TABLE produto
DROP COLUMN codBarras

SELECT descricao, estoque
FROM produto
ORDER BY estoqye DESC

ALTER TABLE produto
ADD preco MONEY

DELETE produto
WHERE codCat IN(1,3,5)

UPDATE produto SET preco = 1.99
WHERE codPro = 1

SELECT P.descricao, C.nomeCat
FROM produto AS P LEFT JOIN categoria AS C
                ON P.codCat = C.codCat
WHERE P.codCat IS NULL

UPDATE produto SET preco = preco * 1.05
WHERE estoque < 400



    