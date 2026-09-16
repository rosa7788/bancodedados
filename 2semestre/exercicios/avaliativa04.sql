CREATE DATABASE ex005;
GO;
USE Aula004;

-- 1. Crie um novo BD e as seguintes tabelas, observando suas restrições de integridade:
--  a) Cidade do Fabricante tem valor padrão como sendo ‘FRANCA’
--  b) Campo Razão Social é um campo obrigatório.
--  c) Só poderão ser cadastrados fabricantes de SP, MG ou RJ.
--  d) Descrição do produto é obrigatório.
--  e) Status da categoria poderá ser ATIVO ou INATIVO.
--  f) Crie um campo para guardar o estoque dos produtos. Este campo deverá ser sempre um número positivo.
--  g) Preço do produto deverá ser sempre maior que 0 (zero).
--  h) Observe as restrições impostas pelas cardinalidades.
--  i) Código da categoria deverá ser um número inteiro de 3 dígitos.

CREATE TABLE fabricantes (
    codFabr INT CONSTRAINT pk_codFabr PRIMARY KEY IDENTITY(1, 1),
    razaoSocial VARCHAR(80) NOT NULL,
    cidade VARCHAR(80) CONSTRAINT df_cidade DEFAULT('FRANCA'),
    UF VARCHAR(2) CONSTRAINT chk_UF CHECK(UF in('SP', 'MG', 'RJ'))
);

INSERT INTO fabricantes VALUES
    ('P%G', 'SAO PAULO', 'SP'),
    ('UNILEVER', 'CAMPINAS', 'SP'),
    ('JUSSARA', 'FRANCO DA ROCHA', 'SP'),
    ('NESTLÉ', 'BELO HORIZONTE', 'MG'),
    ('PARMALAT', 'RIO DE JANEIRO', 'RJ');

SELECT * FROM fabricantes;

CREATE TABLE categorias (
    codCat INT CONSTRAINT pk_codCat PRIMARY KEY IDENTITY(100, 1),
    descricao VARCHAR(40),
    situacao VARCHAR(30) CONSTRAINT chk_situacao CHECK(situacao IN('ATIVO', 'INATIVO')),

    CONSTRAINT chk_codCat CHECK(codCat <= 999)
);

INSERT INTO categorias VALUES
    ('HIGIENE', 'ATIVO'),
    ('ALIMENTOS', 'ATIVO'),
    ('LIMPEZA', 'INATIVO'),
    ('BEBIDA', 'INATIVO'),
    ('LATICINIOS', 'INATIVO');

SELECT * FROM categorias;

CREATE TABLE produtos (
    codPro INT CONSTRAINT pk_codPro PRIMARY KEY IDENTITY(1, 1),
    preco MONEY CONSTRAINT chk_preco CHECK(preco > 0),
    descricao VARCHAR(50) NOT NULL,
    codFabr INT CONSTRAINT fk_codFabr FOREIGN KEY REFERENCES fabricantes(codFabr),
    codCat INT CONSTRAINT fk_codCat FOREIGN KEY REFERENCES categorias(codCat)
);

INSERT INTO produtos VALUES
    (15, 'VEJA', 4, 104),
    (4.90, 'KAYSER', 3, 101),
    (11, 'DESODORANTE', 1, 100),
    (8.30, 'BANANA', 2, 102),
    (1.99, 'FARINHA DE TRIGO', 1, 102),
    (1.50, 'SABAO EM PO', 3, 104),
    (2.25, 'LAVA LOUÇAS', 3, 104),
    (2.2, 'SORVETE NAPOLITANO', 4, 100),
    (1.80, 'ARROZ BRANCO', 1, 101),
    (10.5, 'CHOCOLATE PRESTÍGIO', 3, 103),
    (11.5, 'SKOL LATA', 2, 100),
    (18.5, 'PATO', 1, 103);

SELECT * FROM produtos;

ALTER TABLE produtos
ADD estoque INT CONSTRAINT chk_estoque check(estoque >= 0);

-- 2. Crie as seguintes views para:
--  a. Listar o código do produto, sua descrição e preço, a categoria, o nome e a cidade do fabricante.
GO;
CREATE VIEW vProFabrCat
AS
    SELECT codPro, P.descricao AS nomePro, preco, F.descricao AS nomeCat,
        F.razaoSocial AS nomeFabricante, F.cidade AS cidadeFabricante
    FROM produto AS P
    INNER JOIN fabricantes AS F ON P.codFabr = F.codFabr
    INNER JOIN categorias AS C ON P.codCat = C.codCat;
GO;

SELECT * FROM vProFabrCat; -- para ver o conteudo trazido pela view

SELECT * FROM vProFabrCat
WHERE cidadeFabricante = 'SAO PAULO'
ORDER BY preco;

--  b. Listar os produtos dos fabricantes do RJ.
GO;
CREATE VIEW vProdutosRJ
AS
    SELECT P.descricao, F.UF
    FROM produtos P
    INNER JOIN fabricantes F
    ON P.codFabr = F.codFabr
    WHERE F.UF = 'RJ';
GO;

SELECT * FROM vProdutosRJ;

--  c. Selecionar de forma exclusiva as categorias que possuem produtos fornecidos para o estado de SP e que estão em categorias inativas.
GO;
CREATE VIEW vCatSPInativas
AS
    SELECT DISTINCT C.descricao
    FROM produtos AS P
    INNER JOIN fabricantes AS F
    ON P.codFabr = F.codFabr
        INNER JOIN categorias AS C
        ON P.codCat = C.codCat
    WHERE UF = 'SP' AND situacao = 'INATIVO';
GO;

SELECT * FROM vCatSPInativas;

--  d. Listar os nomes dos produtos, o preço total dos seus estoques (considerando o preço de venda) e o nome das categorias que eles pertencem. Somente de produtos fabricados em SP.
GO;
CREATE VIEW vEstoqueSP
AS
    SELECT P.descricao AS produto, C.descricao, (estoque * preco) AS valorEstoque
    FROM produtos P
    INNER JOIN fabricantes F
    ON P.codFabr = F.codFabr
        INNER JOIN categorias C
        ON P.codCat = C.codCat
    WHERE UF = 'SP';
GO;

SELECT * FROM vEstoqueSP;

-- 3. Crie uma nova tabela para cadastro de Marcas com os campos CodMarca e NomeMarca. O código deverá ser chave primária com numeração automática a partir de 5000 e o Nome da marca precisará ser único e de preenchimento obrigatório.
CREATE TABLE marcas (
    codMarca INT CONSTRAINT pk_codMarca PRIMARY KEY IDENTITY(5000, 1),
    nomeMarca VARCHAR(50) CONSTRAINT uk_nome UNIQUE NOT NULL
);

-- 4. Cada produto poderá ter apenas uma marca.
ALTER TABLE produtos
ADD codMarca INT CONSTRAINT fk_codMarca FOREIGN KEY REFERENCES marcas(codMarca);

-- 5. Cadastre 5 marcas.
INSERT INTO marcas VALUES
    ('OMO'),
    ('YPÊ'),
    ('KIBOM'),
    ('DOVE'),
    ('VANISH');

-- 6. Crie uma view que informe quais são os fabricantes e as marcas dos produtos que estão nas categorias Inativas.
GO;
CREATE VIEW vFabrInativo
AS
    SELECT F.razaoSocial, M.nomeMarca
    FROM fabricantes F
    INNER JOIN produtos P
    ON P.codFabr = F.codFabr
        INNER JOIN marcas M
        ON P.codMarca = M.codMarca
            INNER JOIN categorias C
            ON P.codCat = C.codCat
    WHERE C.situacao = 'INATIVO'
GO;

SELECT * FROM vFabrInativo;

-- 7. Crie uma nova view para mostrar a descrição e os preços dos produtos e suas respectivas marcas, ordenado por produto.
GO;
CREATE VIEW vProMarca
AS
    SELECT P.descricao, P.preco, M.nomeMarca
    FROM produtos P
    INNER JOIN marcas M
    ON P.codMarca = M.codMarca;
GO;

SELECT * FROM vProMarca
ORDER BY descricao;



/*
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

*/