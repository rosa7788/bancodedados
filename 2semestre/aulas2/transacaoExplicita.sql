BEGIN TRANSACTION TranSaldo
    BEGIN TRY
    UPDATE contaBancaria SET saldo = saldo - 50
    WHERE nroConta = 111000
    UPDATE contaBancaria SET saldo = saldo + 50
    WHERE nroConta = 222000

    COMMIT TRANSACTION TranSaldo
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION TranSaldo
END CATCH