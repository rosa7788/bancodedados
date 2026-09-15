--1 Banco de dados
CREATE DATABASE LojaDB;
GO
USE LojaDB;
GO

-- Fabricante
CREATE TABLE Fabricante (
    CodFabr     INT IDENTITY(1,1) PRIMARY KEY,
    RazaoSocial VARCHAR(100) NOT NULL,                          -- (b)
    Cidade      VARCHAR(50)  NOT NULL DEFAULT 'FRANCA',          -- (a)
    UF          CHAR(2)      NOT NULL CHECK (UF IN ('SP','MG','RJ')) -- (c)
);

-- Categoria
CREATE TABLE Categoria (
    CodCat    INT CHECK (CodCat BETWEEN 100 AND 999) PRIMARY KEY, -- (i) 3 dígitos
    Descricao VARCHAR(100),
    Status    VARCHAR(7) CHECK (Status IN ('ATIVO','INATIVO'))    -- (e)
);

-- Produto
CREATE TABLE Produto (
    CodPro      INT IDENTITY(1,1) PRIMARY KEY,
    Descricao   VARCHAR(100) NOT NULL,                 -- (d)
    Preco       DECIMAL(10,2) NOT NULL CHECK (Preco > 0), -- (g)
    Estoque     INT NOT NULL CHECK (Estoque >= 0),      -- (f)
    CodFabr     INT NOT NULL                            -- (h) (1,1) do lado Fabricante
                FOREIGN KEY REFERENCES Fabricante(CodFabr),
    CodCat      INT NOT NULL                            -- (h) (1,1) do lado Categoria
                FOREIGN KEY REFERENCES Categoria(CodCat)
);
GO
--2 VIEW

-- a) código, descrição, preço, categoria, nome e cidade do fabricante
CREATE VIEW vw_ProdutosCompleto AS
SELECT p.CodPro, p.Descricao, p.Preco,
       c.Descricao AS Categoria,
       f.RazaoSocial AS Fabricante, f.Cidade
FROM Produto p
JOIN Categoria c ON p.CodCat = c.CodCat
JOIN Fabricante f ON p.CodFabr = f.CodFabr;
GO

-- b) produtos de fabricantes do RJ
CREATE VIEW vw_ProdutosRJ AS
SELECT p.*
FROM Produto p
JOIN Fabricante f ON p.CodFabr = f.CodFabr
WHERE f.UF = 'RJ';
GO

-- c) categorias inativas que possuem produtos de fabricantes de SP
CREATE VIEW vw_CategoriasSPInativas AS
SELECT c.CodCat, c.Descricao
FROM Categoria c
WHERE c.Status = 'INATIVO'
INTERSECT
SELECT c.CodCat, c.Descricao
FROM Categoria c
JOIN Produto p    ON p.CodCat  = c.CodCat
JOIN Fabricante f ON f.CodFabr = p.CodFabr
WHERE f.UF = 'SP';
GO

-- d) nome do produto, valor total do estoque e categoria (só fabricantes de SP)
CREATE VIEW vw_EstoqueValorizadoSP AS
SELECT p.Descricao AS Produto,
       (p.Preco * p.Estoque) AS ValorTotalEstoque,
       c.Descricao AS Categoria
FROM Produto p
JOIN Categoria c   ON p.CodCat  = c.CodCat
JOIN Fabricante f  ON p.CodFabr = f.CodFabr
WHERE f.UF = 'SP';
GO

--3 Tabela marca
CREATE TABLE Marca (
    CodMarca  INT IDENTITY(5000,1) PRIMARY KEY,
    NomeMarca VARCHAR(100) NOT NULL UNIQUE
);
GO

--4 relacionamento produto
ALTER TABLE Produto
ADD CodMarca INT NULL FOREIGN KEY REFERENCES Marca(CodMarca);
GO

--5 cadastro de marcas
INSERT INTO Marca (NomeMarca) VALUES
('Marca Alfa'),
('Marca Beta'),
('Marca Gama'),
('Marca Delta'),
('Marca Épsilon');
GO

--6 view
CREATE VIEW vw_FabricantesMarcasInativas AS
SELECT f.RazaoSocial AS Fabricante, m.NomeMarca AS Marca
FROM Produto p
JOIN Fabricante f ON p.CodFabr  = f.CodFabr
JOIN Categoria c  ON p.CodCat   = c.CodCat
LEFT JOIN Marca m ON p.CodMarca = m.CodMarca
WHERE c.Status = 'INATIVO';
GO

--7 view
CREATE VIEW vw_ProdutosMarcas AS
SELECT TOP 100 PERCENT
       p.Descricao, p.Preco, m.NomeMarca AS Marca
FROM Produto p
LEFT JOIN Marca m ON p.CodMarca = m.CodMarca
ORDER BY p.Descricao;
GO