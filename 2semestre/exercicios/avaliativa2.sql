CREATE DATABASE Hotel;
GO

USE Hotel;
GO


CREATE TABLE Hospede (
    CodHospede INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Sexo CHAR(1) NOT NULL,
    Idade INT
);
GO


CREATE TABLE Quarto (
    CodQuarto INT IDENTITY(1,1) PRIMARY KEY,
    Tipo VARCHAR(50) NOT NULL,
    Numero INT NOT NULL,
    Andar INT NOT NULL
);
GO


CREATE TABLE Refeicao (
    CodConsumo INT IDENTITY(1,1) PRIMARY KEY,
    DescRefeicao VARCHAR(100) NOT NULL,
    Valor DECIMAL(10,2) NOT NULL
);
GO


CREATE TABLE Reserva (
    CodReserva INT IDENTITY(1,1) PRIMARY KEY,
    DtEntrada DATE NOT NULL,
    DtSaida DATE NOT NULL,
    CodHospede INT NOT NULL,
    CodQuarto INT NOT NULL,
    CodConsumo INT NOT NULL,

    CONSTRAINT FK_Reserva_Hospede
        FOREIGN KEY (CodHospede)
        REFERENCES Hospede(CodHospede),

    CONSTRAINT FK_Reserva_Quarto
        FOREIGN KEY (CodQuarto)
        REFERENCES Quarto(CodQuarto),

    CONSTRAINT FK_Reserva_Refeicao
        FOREIGN KEY (CodConsumo)
        REFERENCES Refeicao(CodConsumo)
);
GO


CREATE TABLE Pagamento (
    CodPagto INT IDENTITY(1,1) PRIMARY KEY,
    Valor DECIMAL(10,2) NOT NULL,
    DtPagto DATE NOT NULL,
    CodReserva INT NOT NULL,

    CONSTRAINT FK_Pagamento_Reserva
        FOREIGN KEY (CodReserva)
        REFERENCES Reserva(CodReserva)
);
GO


INSERT INTO Quarto (Tipo, Numero, Andar)
VALUES
('Standard', 101, 1),
('Superior', 202, 2),
('Superior Master', 301, 3),
('Superior Master', 402, 4),
('Luxo', 501, 5);
GO


INSERT INTO Hospede (Nome, Sexo, Idade)
VALUES
('João da Silva', 'M', 35),
('Maria Oliveira', 'F', 28),
('Carlos Santos', 'M', 42),
('Ana Souza', 'F', 31),
('Pedro Almeida', 'M', 25),
('Juliana Costa', 'F', 38),
('Lucas Pereira', 'M', 29),
('Fernanda Lima', 'F', 45);
GO


INSERT INTO Refeicao (DescRefeicao, Valor)
VALUES
('Café da manhã', 25.00),
('Almoço', 45.00),
('Jantar', 50.00),
('Lanche', 20.00),
('Café especial', 30.00),
('Jantar especial', 80.00);
GO


INSERT INTO Reserva (DtEntrada, DtSaida, CodHospede, CodQuarto, CodConsumo)
VALUES
('2024-12-28', '2025-01-05', 1, 1, 1),
('2025-01-10', '2025-01-15', 2, 2, 2),
('2026-02-10', '2026-02-17', 3, 4, 3),
('2026-02-20', '2026-02-23', 4, 5, 4);
GO


SELECT COUNT(*) AS Quantidade
FROM Quarto
WHERE Tipo = 'Superior Master';
GO


SELECT AVG(Valor) AS ValorMedio
FROM Refeicao;
GO


ALTER TABLE Hospede
DROP COLUMN Idade;
GO


ALTER TABLE Hospede
ADD DtNascimento DATE;
GO


SELECT COUNT(DISTINCT CodHospede) AS QuantidadeHospedes
FROM Reserva;
GO


SELECT 
    H.Nome,
    R.DtEntrada
FROM Hospede H
INNER JOIN Reserva R
    ON H.CodHospede = R.CodHospede;
GO


UPDATE Hospede
SET DtNascimento = '1990-05-15'
WHERE CodHospede = 1;
GO

UPDATE Hospede
SET DtNascimento = '1997-08-20'
WHERE CodHospede = 2;
GO

UPDATE Hospede
SET DtNascimento = '1983-03-10'
WHERE CodHospede = 3;
GO

UPDATE Hospede
SET DtNascimento = '1994-11-25'
WHERE CodHospede = 4;
GO

UPDATE Hospede
SET DtNascimento = '2000-01-12'
WHERE CodHospede = 5;
GO

UPDATE Hospede
SET DtNascimento = '1987-06-30'
WHERE CodHospede = 6;
GO

UPDATE Hospede
SET DtNascimento = '1996-09-18'
WHERE CodHospede = 7;
GO

UPDATE Hospede
SET DtNascimento = '1981-12-05'
WHERE CodHospede = 8;
GO


SELECT
    H.Nome,
    R.DtEntrada
FROM Hospede H
INNER JOIN Reserva R
    ON H.CodHospede = R.CodHospede
WHERE R.DtEntrada < '2025-01-01'
ORDER BY H.Nome ASC;
GO


SELECT DISTINCT
    H.Nome
FROM Hospede H
INNER JOIN Reserva R
    ON H.CodHospede = R.CodHospede
INNER JOIN Quarto Q
    ON R.CodQuarto = Q.CodQuarto
WHERE H.Sexo = 'F'
  AND Q.Andar = 4;
GO


SELECT
    Q.Numero,
    Q.Tipo
FROM Quarto Q
WHERE NOT EXISTS (
    SELECT 1
    FROM Reserva R
    WHERE R.CodQuarto = Q.CodQuarto
);
GO


SELECT
    H.Nome,
    SUM(P.Valor) AS TotalPago
FROM Hospede H
INNER JOIN Reserva R
    ON H.CodHospede = R.CodHospede
INNER JOIN Pagamento P
    ON R.CodReserva = P.CodReserva
WHERE H.Nome = 'João da Silva'
GROUP BY H.Nome;
GO


SELECT COUNT(DISTINCT CodHospede) AS QuantidadeHospedes
FROM Reserva
WHERE DtEntrada >= '2026-02-01'
  AND DtEntrada < '2026-03-01'
  AND DATEDIFF(DAY, DtEntrada, DtSaida) > 5;
GO