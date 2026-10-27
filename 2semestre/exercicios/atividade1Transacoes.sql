CREATE DATABASE BdVestibular
GO
USE BdVestibular
GO

CREATE TABLE cursos (
    codCur INT CONSTRAINT PK_codCur PRIMARY KEY IDENTITY (1,1),
    nome VARCHAR (90),
    cargaHoraria INT CONSTRAINT CK_carga CHECK(cargaHoraria BETWEEN 2800 AND 3600),
    nroVagas INT CONSTRAINT
)

CREATE TABLE candidato (
    codCan INT CONSTRAINT PK_codCan PRIMARY KEY IDENTITY (1,1),
    nome VARCHAR (90),
    cpf VARCHAR (90),
    rg VARCHAR (90),
    endereco VARCHAR (90),

)

CREATE TABLE inscricao (
    codIns INT CONSTRAINT PK_codIns PRIMARY KEY IDENTITY (1,1),
    nota NUMBER,
    dataIns DATETIME,
    anoIns DATE

)

CREATE TABLE pagamento (
    codPag INT CONSTRAINT PK_codPag PRIMARY KEY IDENTITY (1,1),
    VlPago MONEY,
    VlValorJuros MONEY,
    dtVencimento DATETIME,
    dtPagto DATETIME,
    dtRegistro DATETIME

)

