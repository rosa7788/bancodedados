CREATE DATABASE EscolaTeste;

USE EscolaTeste;

-- date armazena somente a data
-- datetime armazena data e horário
-- char tem valor fixo, se for definido 10 caracteres e informado somente 5, o restante será espaços em branco
-- varchar tem valor variável, se for definido 10 caracteres e informado somente 5, ele armazenará somente o que foi informado
CREATE TABLE Alunos(
    RA int,
    nome varchar(80),
    fone varchar(20),
    mae varchar(50),
    pai varchar(50),
    data_nasc datetime -- formato: yyyy/mm/dd HH:MM:ss
);

-- Adicionar novo registro na tabela somente com as colunas selecionadas, definindo o restante dos campos como null
INSERT INTO alunos (RA, mae, pai, nome)
VALUES (102030, 'ANA', 'JOSE', 'CLAUDIO');

-- Adicionar uma nova coluna na tabela
ALTER TABLE Alunos
ADD naturalidade varchar(80);

-- Definir que uma coluna não tenha registros nulos
ALTER TABLE Alunos
ALTER COLUMN nome varchar(80) NOT NULL;

SELECT * FROM Alunos;

DROP TABLE Alunos;