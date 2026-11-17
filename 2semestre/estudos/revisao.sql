CREATE DATABASE HotelDb;
GO
USE HotelDb;

CREATE TABLE Empregado (
    CodEmp INT,
    Nome VARCHAR(100),
    Salario MONEY,
    Funcao VARCHAR (50)
);

CREATE TABLE Hospede (
    CodHos INT,
    Nome VARCHAR (100),
    Profissao VARCHAR (100),
    Cidade VARCHAR (100)
);

CREATE TABLE Quarto (
    CodQua INT,
    Numero INT,
    Capacidade INT,
    Preco MONEY
);

CREATE TABLE Reserva (
    CodRes INT,
    DtEntrada DATE,
    DtSaida DATE,
    TotalGasto DECIMAL (10,2)
);
