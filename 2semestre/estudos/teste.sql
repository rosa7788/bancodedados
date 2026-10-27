-- 1
CREATE DATABASE BdVestibular;
GO

USE BdVestibular;
GO

CREATE TABLE Curso (
    CodCur INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CargaHoraria INT NOT NULL,
    NroVagas INT NOT NULL
);

CREATE TABLE Candidato (
    CodCan INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Endereco VARCHAR(200) NULL,
    CPF CHAR(11) NOT NULL UNIQUE,
    RG VARCHAR(20) NULL,
    Situacao VARCHAR(30) NULL,
    DataCadastro DATETIME NOT NULL
);

CREATE TABLE Inscricao (
    CodIns INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CodCan INT NOT NULL,
    CodCur1Opcao INT NOT NULL,
    CodCur2Opcao INT NOT NULL,
    Nota DECIMAL(5,2) NULL,
    AnoInscr INT NOT NULL,
    DataInscricao DATETIME NOT NULL DEFAULT GETDATE(),
    Situacao VARCHAR(25) NOT NULL,

    FOREIGN KEY (CodCan) REFERENCES Candidato(CodCan),
    FOREIGN KEY (CodCur1Opcao) REFERENCES Curso(CodCur),
    FOREIGN KEY (CodCur2Opcao) REFERENCES Curso(CodCur)
);

CREATE TABLE Pagamento (
    CodPag INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CodIns INT NOT NULL UNIQUE,
    dtRegistro DATE NOT NULL DEFAULT GETDATE(),
    dtVencto DATE NULL,
    dtPagto DATE NULL,
    VlPago DECIMAL(10,2) NULL,
    VlJurosMulta DECIMAL(10,2) NULL,

    FOREIGN KEY (CodIns) REFERENCES Inscricao(CodIns)
);
GO


-- 2
ALTER TABLE Curso
ADD CONSTRAINT CK_Curso_CargaHoraria
CHECK (CargaHoraria IN (2800, 3600));

ALTER TABLE Candidato
ADD CONSTRAINT CK_Candidato_Situacao
CHECK (Situacao IN ('Aprovado', 'Reprovado', 'Aprovado em 2ª chamada'));

ALTER TABLE Inscricao
ADD CONSTRAINT CK_Inscricao_Situacao
CHECK (Situacao IN ('Aguardando pagamento', 'Cancelado', 'Encerrado', 'Pago'));

ALTER TABLE Inscricao
ADD CONSTRAINT DF_Inscricao_Situacao
DEFAULT 'Aguardando pagamento' FOR Situacao;

ALTER TABLE Pagamento
DROP COLUMN dtVencto;

ALTER TABLE Pagamento
ADD dtVencto AS DATEADD(DAY, 10, dtRegistro) PERSISTED;

ALTER TABLE Inscricao
ADD CONSTRAINT UQ_Inscricao_Candidato_Ano
UNIQUE (CodCan, AnoInscr);

ALTER TABLE Inscricao
ADD CONSTRAINT CK_Inscricao_Opcoes
CHECK (CodCur1Opcao <> CodCur2Opcao);

ALTER TABLE Candidato
ADD CONSTRAINT DF_Candidato_DataCadastro
DEFAULT GETDATE() FOR DataCadastro;
GO


-- 3
CREATE PROCEDURE sp_NovaInscricao
    @CodCan INT,
    @CodCur1Opcao INT,
    @CodCur2Opcao INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @CodIns INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Inscricao (
            CodCan, CodCur1Opcao, CodCur2Opcao, AnoInscr
        )
        VALUES (
            @CodCan, @CodCur1Opcao, @CodCur2Opcao, YEAR(GETDATE())
        );

        SET @CodIns = SCOPE_IDENTITY();

        INSERT INTO Pagamento (CodIns)
        VALUES (@CodIns);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

EXEC sp_NovaInscricao
    @CodCan = 1,
    @CodCur1Opcao = 1,
    @CodCur2Opcao = 3;
GO


-- 4
CREATE PROCEDURE sp_RegistrarResultado
    @CodIns INT,
    @Nota DECIMAL(5,2),
    @Situacao VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Inscricao
        SET Nota = @Nota
        WHERE CodIns = @CodIns;

        IF @@ROWCOUNT = 0
            THROW 50001, 'Inscricao nao encontrada.', 1;

        UPDATE Candidato
        SET Situacao = @Situacao
        WHERE CodCan = (
            SELECT CodCan
            FROM Inscricao
            WHERE CodIns = @CodIns
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

EXEC sp_RegistrarResultado
    @CodIns = 1,
    @Nota = 8.5,
    @Situacao = 'Aprovado';
GO


-- 5
CREATE PROCEDURE sp_RegistrarPagamento
    @CodIns INT,
    @VlPago DECIMAL(10,2),
    @VlJurosMulta DECIMAL(10,2) = 0,
    @dtPagto DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @dtPagto = ISNULL(@dtPagto, CAST(GETDATE() AS DATE));

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Pagamento
        SET dtPagto = @dtPagto,
            VlPago = @VlPago,
            VlJurosMulta = @VlJurosMulta
        WHERE CodIns = @CodIns
          AND dtPagto IS NULL;

        IF @@ROWCOUNT = 0
            THROW 50002, 'Boleto nao encontrado ou ja pago.', 1;

        UPDATE Inscricao
        SET Situacao = 'Pago'
        WHERE CodIns = @CodIns;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

EXEC sp_RegistrarPagamento
    @CodIns = 1,
    @VlPago = 150.00;
GO