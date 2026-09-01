-- 1. CREATE TABLE TB_CLIENTE (

codigo INT NOT NULL,

nome VARCHAR(50) NOT NULL,

telefone VARCHAR(20) NOT NULL,

tipo_cliente VARCHAR(20) NOT NULL,

dt_cadastro DATETIME NOT NULL DEFAULT GETDATE(),

nr_dependentes INT NOT NULL,

CONSTRAINT PK_TB_CLIENTE PRIMARY KEY (codigo),

CONSTRAINT CK_TB_CLIENTE_TIPO CHECK (tipo_cliente IN ('Titular', 'Dependente')),

CONSTRAINT CK_TB_CLIENTE_DEPENDENTES CHECK (nr_dependentes >= 0 AND nr_dependentes <= 3) );

GO

-- 2. INSERT INTO TB_CLIENTE (codigo, nome, telefone, tipo_cliente, nr_dependentes)

VALUES (1, 'João da Silva', '16999999999', 'Titular', 2);

 GO

INSERT INTO TB_CLIENTE (codigo, nome, telefone, tipo_cliente, nr_dependentes)

VALUES (2, 'Maria Oliveira', '16988888888', 'Dependente', 0); GO SELECT * FROM TB_CLIENTE;

GO

-- 3. INSERT INTO TB_CLIENTE (codigo, nome, telefone, tipo_cliente, nr_dependentes)

VALUES (1, 'Pedro Santos', '16977777777', 'Titular', 1);

 GO

INSERT INTO TB_CLIENTE (codigo, nome, telefone, tipo_cliente, nr_dependentes)

VALUES (3, NULL, '16966666666', 'Titular', 1);

GO

INSERT INTO TB_CLIENTE (codigo, nome, telefone, tipo_cliente, nr_dependentes) VALUES (4, 'Ana Costa', '16955555555', 'Funcionario', 1);

GO

INSERT INTO TB_CLIENTE (codigo, nome, telefone, tipo_cliente, nr_dependentes) VALUES (5, 'Lucas Almeida', '16944444444', 'Titular', 4); 

GO

INSERT INTO TB_CLIENTE (codigo, nome, telefone, tipo_cliente, nr_dependentes) VALUES (6, 'Juliana Martins', '16933333333', 'Titular', -1);

GO

UPDATE TB_CLIENTE SET tipo_cliente = 'Funcionario' WHERE codigo = 1;

GO

UPDATE TB_CLIENTE SET nr_dependentes = 5 WHERE codigo = 1;

GO

UPDATE TB_CLIENTE SET nr_dependentes = -2 WHERE codigo = 1;

 GO

UPDATE TB_CLIENTE SET codigo = 2 WHERE codigo = 1;

GO

---EXERCICIO 2---

-- 1.

ALTER TABLE Produto
ADD CONSTRAINT CK_Produto_NomeObrigatorio
CHECK (nome_produto IS NOT NULL);
GO


-- 2.

ALTER TABLE Produto
ADD CONSTRAINT FK_Produto_Marca
FOREIGN KEY (id_marca)
REFERENCES Marca(id_marca);
GO


-- 3.

ALTER TABLE Produto
ADD CONSTRAINT CK_Produto_IdPro
CHECK (id_pro BETWEEN 1000 AND 9999);
GO


-- 4.

ALTER TABLE Pedido
ADD CONSTRAINT DF_Pedido_Data
DEFAULT GETDATE() FOR data;
GO


-- 5.

ALTER TABLE ItemPedido
ADD CONSTRAINT PK_ItemPedido
PRIMARY KEY (id_pedido, id_pro);
GO


-- 6.

ALTER TABLE ItemPedido
ADD CONSTRAINT CK_ItemPedido_PrecoQuantidade
CHECK (vl_unit <= 1000 OR qtde < 100);
GO


-- 7.

CREATE TRIGGER TR_Produto_Estoque
ON Produto
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Produto
        WHERE estoque * preço > 250000
    )
    BEGIN
        RAISERROR ('O valor total do estoque não pode exceder 250.000.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO