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
INSERT INTO especialidade VALUES
('OTTORINO'),
('OBSTETRA'),
('PEDIATRA'),
('CARDIOLOGISTA'),
('DERMATOLOGISTA'),
('ORTOPEDISTA')


--cadastro dos medicos preenchendo todos os campos
INSERT INTO medico VALUES
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
INSERT INTO medico (NOME, IDADE, SALARIO) VALUES
('KARINA', 40, 750),
('CARLA', 41, 1950)

--cadastro dos medicos preenchendo agluns campos (mais usado)
INSERT INTO medico (NOME, SALARIO) VALUES
('RODOLFO', 1330)

SELECT * FROM especialidade;
SELECT * FROM medico;

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

--completar o bd com as demais tabelas
CREATE TABLE Pacientes(
    codPac INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(40),
    fone VARCHAR(30)
)
CREATE TABLE Consultas(
    codCon INT PRIMARY KEY IDENTITY(1,1), --PK COM AUTONUMERACAO
    data date,
    codMed INT FOREIGN KEY REFERENCES Medicos(codMed) NOT NULL, --campo obrigatorio
    codPac INT FOREIGN KEY REFERENCES Pacientes(codPac) NOT NULL --campo obrigatorio
)

--recuperar todas as consultas feitas com pediatras em maio/2026
SELECT M.nome AS nomeMedico, C.data, P.nome AS nomePaciente
FROM Medico AS M INNER JOIN Consulta AS C
ON M.codMed = C.codMed
INNER JOIN Paciente AS P
ON P.codPac = C.codPac
WHERE C.data >= '2026/05/02' AND C.data <= '2026/05/31'
AND
E.nome = 'PEDIATRA'

--Exercicios de fixação
--1)cadastre 6 pacientes
INSERT INTO pacientes
VALUES 
('PEDRO','1498398983'),
('MARIA', '3949383983'),
('RITA', '94393849383'),
('RAFAEL', '49374937393'),
('PALOMA', '934494949'),
('AUGUSTO', '939479398398')

--2) Cadastre 10 consultas para medicos e pacientes diversos
INSERT INTO consultas
VALUES
('2025/12/31', 'SUS', 3,2),
('2025/12/31', 'SUS', 3,4),
('2025/12/31', 'UNMED', 3,2),
('2025/12/31', 'UNIMED', 5,2),
('2025/12/31', 'SUS', 1,3),
('2025/12/31', 'SUS', 3,2),
('2025/12/31', 'UNIMED', 3,2),
('2025/12/31', 'SUS', 3,2),
('2025/12/31', 'SUS', 3,2),
('2025/12/31', 'SUS', 3,2);

--3)Atualize o nome do medico joao para joao da silva
select * from medicos

UPDATE medicos SET nome= 'JOAO DA SILVA'
WHERE nome = 'JOAO';

--4)A data da consulta numero 3 é 15/maio/2026 (atualiza) essa informacao
UPDATE consultas SET data = '2025/05/15'
WHERE codCons = 3;

--5)Exclua a primeira consulta cadastrada
DELETE consultas
WHERE codCons=1;

--6)Liste os nomes dos medicos e a especialidade de cada um
SELECT m.nome, E.nome AS espMedica
FROM medicos AS M INNER JOIN especialidades AS E
ON M.codEsp = E.codEsp;

--7)Liste os medicos que nao tem especialidades
SELECT nome, codEsp 
FROM medicos
WHERE codEsp is null;

--8)Liste as consultas feitas pelo convenio UNIMED no mes de abril
SELECT *
FROM consultas
WHERE convenio = 'UNIMED'
AND
data BETWEEN '2026/04/01' AND '2026/04/30';


--9)Lista os nomes dos pacientes e os convenios que usaram nas suas consultas
SELECT P.nome, c.convenio FROM
pacientes AS p INNER JOIN consultas AS C
ON P.codPac = C.codPac

--10)Liste os telefones dos pacientes que nunca consultaram
SELECT p.nome, p.fone, c.data
FROM pacientes AS P LEFT JOIN consultas AS C
ON P.codPac = C.codPac
WHERE c.codPac IS NULL;

--11)Liste os convenios das consultas feitas por ortopedistas
SELECT c.convenio, m.nome, e.nome AS espMedica
FROM consultas AS c INNER JOIN medico AS m
ON c.codMed = m.codEsp
INNER JOIN especialidades AS e
ON m.codEsp = e.codEsp
WHERE e.nome = "DERMATOLOGISTA";

--12)Liste os nomes e fones dos pacientes atendidos por PEDIATRAS ou DERMATOLOGISTAS em abril/2026
SELECT p.nome as nomePaciente, p.fone
FROM especialidades AS e INNER JOIN medico AS m
ON e.codEsp = m.codEsp 
INNER JOIN consultas AS c
ON c.codMed = m.codMed
INNER JOIN pacientes AS p
ON c.codPac = p.codPac
WHERE (e.nome = 'PEDIATRA' OR e.nome = 'DERMATOLOGISTA') 
AND
data BETWEEN '2025/04/01' AND '2026/04/30';

--13)Cadastre a especialidade 'NEUROLOGISTA' e atualize as especilidades de 2 medicos para esta nova

--14)Crie 3 consultas para medicos NEUROLOGISTAS no mes de maio/2026

--15) As consultas feitas pelos PEDIATRAS em abril/2026 devem se somente do convenio 'SUS', Atualize essa informacao










