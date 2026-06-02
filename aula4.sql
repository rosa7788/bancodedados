CREATE DATABASE Hospital;

USE Hospital;

CREATE TABLE Especialidade(
    codEsp INT PRIMARY KEY IDENTITY(10,10),
    nome VARCHAR(40)
);
CREATE TABLE Medico(
    codMed INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(80),
    idade INT, -- o correto é guardar a data de nascimento
    salario MONEY,
    codEsp INT FOREIGN KEY REFERENCES Especialidade(codEsp)
)

--cadastro das especialidades
INSERT INTO Especialidade VALUES
('OTTORINO'),
('OBSTETRA'),
('PEDIATRA'),
('CARDIOLOGISTA'),
('DERMATOLOGISTA'),
('ORTOPEDISTA')


--cadastro dos medicos preenchendo todos os campos
INSERT INTO Medico VALUES
('JOAO', 48, 800, 10),
('JOSE', 35, 1200, 10),
('ANA', 47, 1400, 30),
('IVO', 51, 750, NULL),
('SILVIO', NULL, 2550, 20),
('ADAO', 62, 1950, 50),
('EVA', 42, 800, NULL),
('JOANA', 39, 1200, 10),
('AFONSO', NULL, 800, 30)

--cadastro dos medicos preenchendo agluns campos (mais usado)
INSERT INTO Medico (NOME, IDADE, SALARIO) VALUES
('KARINA', 40, 750),
('CARLA', 41, 1950)

--cadastro dos medicos preenchendo agluns campos (mais usado)
INSERT INTO Medico (NOME, SALARIO) VALUES
('RODOLFO', 1330)

SELECT * FROM Especialidade;
SELECT * FROM Medico;

--Medicos com ou sem especialidade
SELECT M.nome, E.nome 
FROM Medico AS M 
LEFT JOIN Especialidade AS E
ON M.codEsp = E.codEsp


--Medicos com Especilidades
SELECT M.nome, E.nome 
FROM Medico AS M 
INNER JOIN Especialidade AS E
ON M.codEsp = E.codEsp
WHERE E.codEsp IS NULL

--Medico sem especialidade
SELECT M.nome AS nomeMed, E.nome AS nomeEsp
FROM Medico AS M 
INNER JOIN Especialidade AS E
ON M.codEsp = E.codEsp
WHERE E.codEsp IS NULL





