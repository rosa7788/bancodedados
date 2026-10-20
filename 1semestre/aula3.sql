CREATE DATABASE Vendas2026;

USE Vendas2026;

-- Criar tabela com chave primária:
CREATE TABLE Marca(
    idMarca INT PRIMARY KEY IDENTITY,
    -- este comando torna o campo como PK
    nome VARCHAR(80),
    situacao CHAR(1)
);

-- Cadastrar marcas uma de cada vez:
INSERT INTO Marca
VALUES(1, 'COCA-COCA', 'A');

INSERT INTO Marca
VALUES(2, 'PEPSI', 'A');

-- Cadastras várias marcas de uma vez
INSERT INTO Marca VALUES
    (3, 'ANTARTICA', 'I'),
    (4, 'FORS', 'A'),
    (5, 'SKOL', 'I');

-- Testando propriedade de 'NÃO NULO' da PK:
INSERT INTO Marca (nome, situacao)
VALUES ('TESTE', 'A');

-- Testando propriedade de 'VALOR ÚNICO' da PK
INSERT INTO Marca
VALUES (5, 'TESTE', 'A');

-- Cria a tabela Produto com PK com numeração automática e com FK para Marca
CREATE TABLE Produto(
    idProd INT PRIMARY KEY IDENTITY(1, 1), -- Começa no 1 e incrementa 1
    nome VARCHAR(100),
    preco MONEY,
    cor VARCHAR(40),
    idMarca INT FOREIGN KEY REFERENCES Marca(idMarca) -- Referencia a PK da tabela Marca
);

-- Cadastrar produtos para testar a autonumeração da PK:
INSERT INTO Produto (nome, preco)
VALUES ('COCA LATA 340 ml', 8.94);

-- Testtando Integridade Referencial da FK com update do registro:
UPDATE Produto SET idMarca = 1
WHERE idProd = 1;

-- Criar nova tabela para cadastro de Fornecedores:
CREATE TABLE Fornecedor(
    idFor INT PRIMARY KEY IDENTITY(1, 1),
    razaoSocial VARCHAR(50),
    cnpj VARCHAR(20)
);

-- Alterar a estrutura da tabela Produto para uma nova FK ligando ao Fornecedor:
ALTER TABLE Produto
ADD idFor INT FOREIGN KEY REFERENCES Fornecedor(idFor);

SELECT * FROM Marca;
SELECT * FROM Produto;
SELECT * FROM Fornecedor;