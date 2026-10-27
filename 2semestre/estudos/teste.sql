
CREATE DATABASE BdVestibular
GO
USE BdVestibular
GO

-- 1) e 2)

CREATE TABLE cursos (
    codCur       INT         CONSTRAINT PK_codCur PRIMARY KEY IDENTITY (1,1),
    nome         VARCHAR(90) NOT NULL,
    cargaHoraria INT         NOT NULL,
    nroVagas     INT         NOT NULL,                       
    CONSTRAINT CK_carga CHECK (cargaHoraria IN (2800, 3600)),
    CONSTRAINT CK_vagas CHECK (nroVagas >= 0)
)
GO

CREATE TABLE candidato (
    codCan       INT         CONSTRAINT PK_codCan PRIMARY KEY IDENTITY (1,1),
    nome         VARCHAR(90) NOT NULL,
    cpf          CHAR(11)    NOT NULL CONSTRAINT UQ_cpf UNIQUE,  
    rg           VARCHAR(20) NOT NULL,
    endereco     VARCHAR(90) NOT NULL,                           
    dtCadastro   DATE        NOT NULL CONSTRAINT DF_dtCadastro DEFAULT (CAST(GETDATE() AS DATE)),
    situacao     VARCHAR(30) NULL,
    CONSTRAINT CK_sitCandidato
        CHECK (situacao IN ('Aprovado', 'Reprovado', 'Aprovado em 2ª chamada'))
)
GO

CREATE TABLE inscricao (
    codIns       INT          CONSTRAINT PK_codIns PRIMARY KEY IDENTITY (1,1),
    codCan       INT          NOT NULL,                      
    codCurOpcao1 INT          NOT NULL,                    
    dataIns      DATETIME     NOT NULL CONSTRAINT DF_dataIns DEFAULT (GETDATE()),
    anoIns       AS YEAR(dataIns) PERSISTED,                 
    situacao     VARCHAR(30)  NOT NULL CONSTRAINT DF_sitInscricao DEFAULT ('Aguardando pagamento'),

    CONSTRAINT FK_ins_candidato FOREIGN KEY (codCan)       REFERENCES candidato (codCan),
    CONSTRAINT FK_ins_curso1    FOREIGN KEY (codCurOpcao1) REFERENCES cursos (codCur),
    CONSTRAINT FK_ins_curso2    FOREIGN KEY (codCurOpcao2) REFERENCES cursos (codCur),
    CONSTRAINT CK_sitInscricao
        CHECK (situacao IN ('Aguardando pagamento', 'Cancelado', 'Encerrado', 'Pago')),
    CONSTRAINT UQ_candidato_ano UNIQUE (codCan, anoIns),
    CONSTRAINT CK_opcoes CHECK (codCurOpcao1 <> codCurOpcao2),
    CONSTRAINT CK_nota   CHECK (nota IS NULL OR nota BETWEEN 0 AND 10)
)
GO

CREATE TABLE pagamento (
    codPag       INT   CONSTRAINT PK_codPag PRIMARY KEY IDENTITY (1,1),
    codIns       INT   NOT NULL,                        
    VlPago       MONEY NULL,
    VlValorJuros MONEY NULL,
    dtRegistro   DATETIME NOT NULL CONSTRAINT DF_dtRegistro DEFAULT (GETDATE()),
    dtVencimento AS DATEADD(DAY, 10, dtRegistro) PERSISTED,
    dtPagto      DATETIME NULL,

    CONSTRAINT FK_pag_inscricao FOREIGN KEY (codIns) REFERENCES inscricao (codIns),
    CONSTRAINT UQ_pag_inscricao UNIQUE (codIns)            
)
GO

-- 3)
CREATE PROCEDURE sp_realizarInscricao
    @codCan INT, @codCurOpcao1 INT, @codCurOpcao2 INT
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRY
        BEGIN TRANSACTION

        INSERT INTO inscricao (codCan, codCurOpcao1, codCurOpcao2)
        VALUES (@codCan, @codCurOpcao1, @codCurOpcao2)

        INSERT INTO pagamento (codIns) VALUES (SCOPE_IDENTITY())

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        THROW
    END CATCH
END
GO

-- 4) 
CREATE PROCEDURE sp_registrarNota
    @codIns INT, @nota DECIMAL(5,2), @situacao VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRY
        BEGIN TRANSACTION

        UPDATE inscricao SET nota = @nota WHERE codIns = @codIns
        IF @@ROWCOUNT = 0
            THROW 50001, 'Inscrição não encontrada.', 1

        UPDATE c SET c.situacao = @situacao
          FROM candidato c
          JOIN inscricao i ON i.codCan = c.codCan
         WHERE i.codIns = @codIns

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        THROW
    END CATCH
END
GO

-- 5)
CREATE PROCEDURE sp_registrarPagamento
    @codIns INT, @vlPago MONEY, @vlJuros MONEY = 0, @dtPagto DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRY
        BEGIN TRANSACTION

        UPDATE pagamento
           SET VlPago = @vlPago,
               VlValorJuros = @vlJuros,
               dtPagto = ISNULL(@dtPagto, GETDATE())
         WHERE codIns = @codIns
        IF @@ROWCOUNT = 0
            THROW 50002, 'Pagamento não encontrado para a inscrição.', 1

        UPDATE inscricao SET situacao = 'Pago' WHERE codIns = @codIns

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        THROW
    END CATCH
END
GO

