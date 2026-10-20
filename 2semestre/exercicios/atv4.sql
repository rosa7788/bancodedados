CREATE DATABASE Atv04;

USE Atv04

--2
CREATE TABLE Departamentos (
    cod INT IDENTITY (1,1) PRIMARY KEY,
    nome VARCHAR (100) NOT NULL,
    descricao VARCHAR (255) NULL,
    codGerente INT NULL -- fk para funcionários, adiciona depois (refência cruzada)
);
GO

--1
CREATE TABLE Funcionarios (
    codFuncionario INT IDENTITY (1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    CPF VARCHAR(11) NOT NULL UNIQUE,
    RG VARCHAR(20) NOT NULL UNIQUE,  
    sexo CHAR(1) NOT NULL,
    categoria VARCHAR (20) NOT NULL,
    idade INT NOT NULL,
    CodDepartamento INT NULL,

    CONSTRAINT CK_Funcionarios_sexo
        CHECK (sexo IN ('M', 'F')),

    CONSTRAINT CK_Funcionarios_categoria
        CHECK (categoria IN ('Auxiliar', 'Supervisor', 'Terceirizado', 'Contratado', 'Coordenador')),

    CONSTRAINT CK_Funcionarios_idade
        CHECK (idade BETWEEN 16 AND 65),

    CONSTRAINT FK_Funcionarios_departamento
        FOREIGN KEY (CodDepartamento) REFERENCES Departamentos(CodDepartamento)

);
GO

ALTER TABLE Departamentos
    ADD CONSTRAINT FK_Departamentos_Gerente 
    FOREIGN KEY (CodGerente) REFERENCES Funcionarios(CodFuncionario);
GO

--3
CREATE TABLE Projetos (
    codProjeto INT IDENTITY (1,1) PRIMARY KEY,
    nome VARCHAR (100) NOT NULL,
    descricao VARCHAR (255) NULL 
);
GO

--4
CREATE TABLE ParticipacaoProjetos (
    CodParticipacao INT IDENTITY(1,1) PRIMARY KEY,
    CodFuncionario INT NOT NULL,
    CodProjeto INT NOT NULL,
    DataInicio DATE NOT NULL,
    DataFim DATE NULL,

    CONSTRAINT FK_Participacao_Funcionario 
        FOREIGN KEY (CodFuncionario) REFERENCES Funcionarios(CodFuncionario),

    CONSTRAINT FK_Participacao_Projeto 
        FOREIGN KEY (CodProjeto) REFERENCES Projetos(CodProjeto),

    CONSTRAINT CK_Participacao_Datas 
        CHECK (DataFim IS NULL OR DataInicio < DataFim)
);
GO

--5
ALTER TABLE Funcionarios
ADD CodDepartamento INT NULL;
GO

ALTER TABLE Funcionarios
ADD CONSTRAINT FK_Funcionarios_Departamentos
    FOREIGN KEY (CodDepartamento) REFERENCES Departamentos(CodDepartamento);
GO

--6
-- Descobre o nome da constraint de PK atual (gerado automaticamente pelo SQL Server)
SELECT name 
FROM sys.key_constraints 
WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = 'ParticipacaoProjetos';
GO

-- Remove a PK atual (substitua pelo nome retornado acima)
ALTER TABLE ParticipacaoProjetos
DROP CONSTRAINT PK__Particip__XXXXXXXX;  -- ajuste o nome
GO

-- Cria a nova PK composta (CodFuncionario = CodFun / CodProjeto = CodProj)
ALTER TABLE ParticipacaoProjetos
ADD CONSTRAINT PK_Participacao PRIMARY KEY (CodFuncionario, CodProjeto);
GO

--7
INSERT INTO Departamentos (Nome) VALUES
('CONTAS A PAGAR'),
('CONTAS A RECEBER'),
('FATURAMENTO'),
('VENDAS'),
('COMPRAS');
GO

--8
INSERT INTO Projetos (Nome, Descricao) VALUES
('Implantação ERP', 'Projeto de implantação do novo sistema ERP'),
('Migração de Servidores', 'Migração dos servidores para nuvem'),
('Reestruturação Financeira', 'Revisão dos processos financeiros'),
('Campanha de Vendas 2026', 'Planejamento da campanha anual de vendas'),
('Auditoria de Compras', 'Auditoria dos processos de compras');
GO

--9
INSERT INTO Funcionarios (Nome, CPF, RG, Sexo, Categoria, Idade, CodDepartamento) VALUES
('Ana Souza',        '11111111111', '1111111', 'F', 'Coordenador',   35, 1),
('Bruno Lima',       '22222222222', '2222222', 'M', 'Auxiliar',      22, 1),
('Carla Mendes',     '33333333333', '3333333', 'F', 'Supervisor',    40, 2),
('Diego Alves',      '44444444444', '4444444', 'M', 'Terceirizado',  28, 2),
('Elaine Rocha',     '55555555555', '5555555', 'F', 'Contratado',    31, 3),
('Fábio Nunes',      '66666666666', '6666666', 'M', 'Auxiliar',      19, 3),
('Gabriela Torres',  '77777777777', '7777777', 'F', 'Coordenador',   45, 4),
('Henrique Costa',   '88888888888', '8888888', 'M', 'Supervisor',    38, 4),
('Isabela Ramos',    '99999999999', '9999999', 'F', 'Terceirizado',  27, 5),
('João Pedro Silva', '10101010101', '1010101', 'M', 'Contratado',    33, 5);
GO

--10
INSERT INTO ParticipacaoProjetos (CodFuncionario, CodProjeto, DataInicio) VALUES
(1, 100, '2026-01-10'), (2, 100, '2026-01-10'), (3, 100, '2026-01-15'),
(4, 101, '2026-02-01'), (5, 101, '2026-02-01'), (6, 101, '2026-02-05'),
(7, 102, '2026-03-01'), (8, 102, '2026-03-01'), (9, 102, '2026-03-10'),
(10,103, '2026-04-01'), (1, 103, '2026-04-01'), (2, 103, '2026-04-05'),
(3, 104, '2026-05-01'), (4, 104, '2026-05-01'), (5, 104, '2026-05-05');
GO

--11
UPDATE Departamentos SET CodGerente = 1  WHERE CodDepartamento = 1; -- Contas a Pagar
UPDATE Departamentos SET CodGerente = 3  WHERE CodDepartamento = 2; -- Contas a Receber
UPDATE Departamentos SET CodGerente = 5  WHERE CodDepartamento = 3; -- Faturamento
UPDATE Departamentos SET CodGerente = 7  WHERE CodDepartamento = 4; -- Vendas
UPDATE Departamentos SET CodGerente = 9  WHERE CodDepartamento = 5; -- Compras
GO

--12
ALTER TABLE Funcionarios
ADD Cidade VARCHAR(50) NOT NULL 
    CONSTRAINT DF_Funcionarios_Cidade DEFAULT 'Franca';
GO

--13
INSERT INTO Funcionarios (Nome, CPF, RG, Sexo, Categoria, Idade, CodDepartamento)
VALUES ('Marcos Vinícius', '12312312312', '1231231', 'M', 'Auxiliar', 24, 1);
GO

-- Verificando se o valor padrão foi aplicado
SELECT Nome, Cidade FROM Funcionarios WHERE Nome = 'Marcos Vinícius';
GO

--14
INSERT INTO Projetos (Nome, Descricao)
VALUES ('Projeto Qualidade Total', 'Programa de melhoria contínua de processos');
GO

-- Supondo que o novo projeto tenha gerado o código 105
INSERT INTO ParticipacaoProjetos (CodFuncionario, CodProjeto, DataInicio) VALUES
(1,  105, '2026-06-01'),
(2,  105, '2026-06-01'),
(3,  105, '2026-06-02'),
(4,  105, '2026-06-02'),
(5,  105, '2026-06-03');
GO

--15
-- Verifica se existem funcionários sem departamento
SELECT * FROM Funcionarios WHERE CodDepartamento IS NULL;
GO

-- Caso existam, vincula todos a um departamento (exemplo: departamento 1)
UPDATE Funcionarios
SET CodDepartamento = 1
WHERE CodDepartamento IS NULL;
GO

--16
ALTER TABLE Departamentos
ADD CONSTRAINT DF_Departamentos_Descricao DEFAULT 'Sem descrição' FOR Descricao;
GO

ALTER TABLE Projetos
ADD CONSTRAINT DF_Projetos_Descricao DEFAULT 'Sem descrição' FOR Descricao;
GO

--17
-- 1. Remove a tabela associativa (depende de Funcionarios e Projetos)
DROP TABLE ParticipacaoProjetos;
GO

-- 2. Remove a FK do gerente em Departamentos, quebrando a referência circular
ALTER TABLE Departamentos
DROP CONSTRAINT FK_Departamentos_Gerente;
GO

-- 3. Agora é possível excluir Funcionarios
DROP TABLE Funcionarios;
GO

-- 4. Exclui Departamentos
DROP TABLE Departamentos;
GO

-- 5. Exclui Projetos
DROP TABLE Projetos;
GO




