CREATE TABLE teste (
    ID INT PRIMARY KEY,
    campA VARCHAR(50) NOT NULL,
    campB VARCHAR(50) NOT NULL
)

/*--transições de autoconfrimação (executadas uma a uma):
INSERT INTO teste VALUES (1,'Um texto qualquer', 'Outro texto')
INSERT INTO teste VALUES (2, NULL, 'Novo texto')
INSERT INTO teste VALUES (3, 'Terceiro texto', 'Nova tentativa')

SELECT * FROM teste 

*/

BEGIN TRANSACTION testeTran
    BEGIN TRY
        INSERT INTO teste VALUES (10,'Um texto qualquer', 'Outro texto')
        INSERT INTO teste VALUES (2, NULL, 'Novo texto')
        INSERT INTO teste VALUES (3, 'Terceiro texto', 'Nova tentativa')

    COMMIT TRANSACTION testeTran
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS NumeroErro,
           ERROR_LINE() AS LinhaErro,
           ERROR_MESSAGE() MensagemErro

    ROLLBACK TRANSACTION testeTran
END CATCH
