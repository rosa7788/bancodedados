CREATE DATABASE aula2809
GO
USE aula2809
GO

--##########

CREATE TABLE Time (
    idTime INT CONSTRAINT PK_TIME PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(50) NOT NULL,
    cidade VARCHAR(50),
    estado VARCHAR(2),
    anoFundacao INT
);
GO

CREATE TABLE Jogador (
    idJogador INT CONSTRAINT PK_JOGADOR PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(80) NOT NULL,
    apelido VARCHAR(40),
    posicao VARCHAR(30),
    salario DECIMAL(10,2),
    dataNascimento DATE,
    numeroCamisa INT,
    idTime INT,

    CONSTRAINT FK_TIME_JOGADOR FOREIGN KEY (idTime) REFERENCES Time(idTime)
);
GO


-- ============================================================
-- 2. INSERÇÃO DOS DADOS
-- ============================================================

INSERT INTO Time (nome, cidade, estado, anoFundacao)
VALUES
('Flamengo', 'Rio de Janeiro', 'RJ', 1895),
('Palmeiras', 'São Paulo', 'SP', 1914),
('Corinthians', 'São Paulo', 'SP', 1910),
('São Paulo', 'São Paulo', 'SP', 1930),
('Cruzeiro', 'Belo Horizonte', 'MG', 1921),
('Grêmio', 'Porto Alegre', 'RS', 1903);
GO


INSERT INTO Jogador
(nome, apelido, posicao, salario, dataNascimento, numeroCamisa, idTime)
VALUES
('Marcelo Santos', 'Marcelinho', 'Atacante', 85000, '1998-05-12', 9, 1),
('Bruno Oliveira', NULL, 'Goleiro', 55000, '1995-08-20', 1, 1),
('Lucas Almeida', 'Luquinha', 'Meia', 72000, '2000-03-15', 10, 1),
('Matheus Silva', NULL, 'Zagueiro', 60000, '1997-11-02', 4, 1),

('Gabriel Souza', 'Biel', 'Atacante', 92000, '1999-01-25', 11, 2),
('Pedro Martins', 'Pedrinho', 'Meia', 78000, '2001-06-17', 8, 2),
('Rafael Costa', NULL, 'Zagueiro', 63000, '1996-09-08', 3, 2),
('Carlos Mendes', NULL, 'Goleiro', 58000, '1994-12-11', 1, 2),

('Marcos Ferreira', 'Marcão', 'Zagueiro', 67000, '1995-04-30', 4, 3),
('Felipe Rocha', NULL, 'Atacante', 88000, '2000-07-21', 9, 3),
('André Lima', 'Dedé', 'Meia', 74000, '1998-02-14', 10, 3),

('Rodrigo Alves', NULL, 'Goleiro', 52000, '1993-10-05', 1, 4),
('Miguel Ribeiro', 'Migué', 'Atacante', 95000, '2002-05-19', 7, 4),
('Daniel Barbosa', NULL, 'Meia', 76000, '1999-08-09', 8, 4),

('Eduardo Lopes', 'Dudu', 'Atacante', 81000, '1997-03-22', 11, 5),
('Henrique Gomes', NULL, 'Zagueiro', 59000, '1996-01-18', 3, 5),
('Gustavo Moraes', 'Guga', 'Meia', 70000, '2001-09-27', 10, 5),

('Leonardo Nunes', 'Leo', 'Goleiro', 50000, '1995-06-16', 1, 6),
('Thiago Cardoso', NULL, 'Atacante', 83000, '1998-12-03', 9, 6),
('Murilo Teixeira', 'Muri', 'Meia', 69000, '2000-10-10', 8, 6);
GO

-----------================================================
---3.sempre que tiver uma função select junto com algum campo, devera ter um GRUOPU BY com esses campos
-----------================================================
SELECT COUNT(*) AS qtdeTotal, posicao
FROM Jogador
GROUP BY posicao

SELECT AVG(salario) AS mediaSalarial, posicao
FROM jogador
GROUP BY posicao

---=====================================================
---4. LIKE
---representa qualquer quantidade de caracteres
---=====================================================

---começa com M
SELECT *
FROM jogador
WHERE nome LIKE 'M%';

--termina com Silva
SELECT *
FROM jogador
WHERE nome LIKE '%Silva';

---contém "el"
SELECT *
FROM jogador
WHERE nome LIKE '%el%';

---======================================
---5. funções de texto
---=======================================


SELECT 
    nome, 
    UPPER(nome) AS nomeMaisculo,
    LOWER(nome) AS nomeMinusculo
FROM jogador;

--- primeiro 5 caracteres
SELECT 
    nome,
    LEFT(nome, 5) AS primeirosCaracteres
FROM jogador;

---ultimo 5 caracteres
SELECT
    nome,
    RIGHT(nome, 5) AS ultimosCaracteres
FROM jogador;

---========================================
---6 SUBSTRING
---=========================================

SELECT
    nome,
    LEFT(nome, 5) AS primeirosCaracteres,
    RIGHT(nome, 5) AS ultimosCaracteres,
    SUBSTRING(nome, 3, 3) AS parteNome --substring(campo, inicio, fim)
FROM jogador;

---=====================================
---7. GETDATE()
---=====================================
SELECT GETDATE() AS daatHoraAtual;

SELECT
    nome,
    dataNascimento,
    GETDATE() AS dataAtual
FROM jogador;

---==========================================
---8. set DATEFORMAT
---DMY = Day Month Year
---===========================================

SET DATEFORMAT DMY;

INSERT INTO jogador
(nome, posicao, salario, dataNascimento, numeroCamisa, idTime)
VALUES
('João Pereira', 'Atacante', 65000, '25/08/2000', 17,1);

---=================================
---8. ISNULL()
---====================================

SELECT
    nome,
    ISNULL(apelido, 'Sem Apelido') AS Apelido
FROM jogador;

---=============================================
---9. TOP N
--top limita a quantidade de registros
--ORDER BY define quais serão os primeiros
---================================================

--- 5 maiores salarios
SELECT TOP 5
    nome,
    salario
FROM jogador
ORDER BY salario DESC;

--- 3 menores salarios
SELECT TOP 3
    nome,
    salario
FROM jogador
ORDER BY salario ASC;






