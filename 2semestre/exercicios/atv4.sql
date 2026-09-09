CREATE DATABASE Atv04;

USE Atv04

CREATE TABLE Funcionarios (
    cod INT IDENTITY (1,1) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    CPF VARCHAR(20) NOT NULL,
    RG VARCHAR(20) NOT NULL,  
    sexo CHAR(1) NOT NULL CHECK(sexo IN('F', 'M')) 
)

CREATE TABLE Departamentos (
    cod INT IDENTITY (1,1) PRIMARY KEY,
    nome VARCHAR (50),
    descricao VARCHAR (100)
)

CREATE TABLE Projetos (
    cod INT IDENTITY (1,1) PRIMARY KEY,
    nome VARCHAR (50),
    descricao VARCHAR (100) 
)

CREATE TABLE Participacao (
    codFun INT IDENTITY (1,1) PRIMARY KEY,
)


