CREATE DATABASE  PROVA
GO USE PROVA

CREATE TABLE participante(
    id INT CONSTRAINT PK_PART PRIMARY KEY IDENTITY (1,1),
    nome VARCHAR(90),
    data_nasc DATE,
    profissao VARCHAR(50),
    cidade VARCHAR(80),
    uf VARCHAR(2),
    status VARCHAR(30) CONSTRAINT CK_STA CHECK(status IN('ATIVO', 'ELIMINADO'))
)

CREATE TABLE prova(
    id INT CONSTRAINT PK_PROV PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(40),
    data DATE CONSTRAINT DF_DAT DEFAULT(GETDATE()),
    tipo VARCHAR(50),
    tempo_minutos INT CONSTRAINT CK_TEMP CHECK (tempo_minutos between 0 and 180)
)

CREATE TABLE ingrediente(
    id IINT CONSTRAINT PK_INGR PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(80),
    categoria VARCHAR(80)
)

CREATE TABLE prato(
    id INT CONSTRAINT PK_PRATO PRIMARY KEY IDENTITY(1,1),
    nome VARCHARR(80),
    descricao VARCHAR(300),
    dificuldade VARCHAR(80) CONSTRAINT DF_DIF DEFAULT('MÉDIA'),
    id_partic INT CONSTRAINT FK_PART FOREIGN KEY REFERENCES participante(id),
    id_prova INT CONSTRAINT FK_PROV FOREIGN KEY REFERENCES prova(id)
)

CREATE TABLE utiliza(
    id INT CONSTRAINT PK_UTIL PRIMARY KEY IDENTITY(1,1),
    quantidade INT,
    unidade_media VARCHAR(10),
    id_prato INT CONSTRAINT FK_PRAT FOREIGN KEY REFERENCES prato(id),
    id_ingrediente INT CONSTRAINT FK_INGRED FOREIGN KEY REFERENCES ingrediente(id)
)
 
--2 
INSERT INTO prova(nome, tipo, tempo_minutos)
VALUES ('Desafio da Massa', 'ELIMINAÇÃO', 90)

UPDATE prova
SET tempo_minutos = 120
WHERE tipo = 'ELIMINAÇÃO' AND tempo_minutos < 90

--3
UPDATE participante
SET status = 'ELIMINADO'
WHERE
uf = 'SP' AND
status = 'ATIVO' AND
data_nasc < '1995/01/01'

--4 
CREATE VIEW viewEx4 
AS 
SELECT nome, profissao, cidade, uf
FROM participante
WHERE status = 'ATIVO'

--5
CREATE VIEW viewEx5
AS
SELECT P.nome AS nomePrato, I.nome AS nomeIngred, categoria,
quantidade, unidade_medida
FROM participante AS P INNER JOIN prato AS PR ON P.id = PR.id_partic
WHERE dificuldade = 'DIFÍCIL'

--6
CREATE VIEW viewEx6
AS 
    SELECT P.nome AS nomePrato, I.nome AS nomeIngred, categoria, 
    quantidade, unidade_medida
    FROM ingrediente AS I INNER JOIN utiliza AS U ON I.id = U.id_ingrediente
                        INNER JOIN prato AS P ON P.id = U.id_prato

--7
SELECT PA.nome AS nomeParticip, PR.nome AS nomePrato, PO.nome AS nomeProva
FROM participante AS PA INNER JOIN prato AS PR ON PA.id = PR.id_partic
                        INNER JOIN prova AS PO ON PO.id = PR.id_prova
WHERE PA.status = 'ATIVO' AND PO.tipo = 'ELIMINAÇÃO'

--8
SELECT PA.nome AS nomeParticip, PR.nome as nomePrato, I.nome AS nomeIngred
FROM participante AS PA INNER JOIN prato AS PR ON PA.id = PR.id_partic
                        INNER JOIN utiliza AS U ON PR.id = U.id_prato
                        INNER JOIN ingrediente AS I ON I.id = U.id_ingrediente
WHERE I.ingrediente = 'LATICÍNIOS'
ORDER BY PA.nome



