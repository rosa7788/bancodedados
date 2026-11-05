CREATE DATABASE Loja
USE Loja

CREATE TABLE Financeiro (
    Id_finan INT CONSTRAINT Pk_finan PRIMARY KEY IDENTITY (1,1),
    Valor MONEY,
    Dt_lanc DATE,
    Dt_venc DATE,
    Dt_liq DATE,
    Id_venda INT CONSTRAINT Fk_venda FOREIGN KEY REFERENCES Venda(Id_venda)

)

CREATE TABLE Endereco (
    Id_endereco INT CONSTRAINT Pk_ende PRIMARY KEY IDENTITY (1,1),
    Rua VARCHAR (80),
    Nro NUMBER,
    Bairro VARCHAR (50),
    Cep NUMBER

)

CREATE TABLE Cliente (
    Id_cli INT CONSTRAINT Pk_cli PRIMARY KEY IDENTITY (1,1),
    Nome VARCHAR (80) NOT NULL,
    Fone VARCHAR (40),
    LimiteCredito MONEY,
    Id_endereco INT CONSTRAINT Fk_ende FOREIGN KEY REFERENCES Endereco(Id_endereco)
)

CREATE TABLE Vendedor (
    Id_vend INT CONSTRAINT Pk_vend PRIMARY KEY IDENTITY (1,1),
    Nome VARCHAR (80),
    Fone VARCHAR (40),
    Funcao VARCHAR(80) CONSTRAINT Ck_funcao CHECK (Funcao IN('Balcao','Externo', 'Aprendiz', 'Supervisor')),
    Id_endereco INT CONSTRAINT Fk_ende FOREIGN KEY REFERENCES Endereco(Id_endereco)
)

CREATE TABLE Salario (
    Id_salario INT CONSTRAINT Pk_sala PRIMARY KEY IDENTITY (1,1),
    Data DATE,
    Vl_fixo MONEY,
    Vl_comissao MONEY,
    Id_comi INT CONSTRAINT Fk_comi FOREIGN KEY REFERENCES Comissao(Id_comi)
)

CREATE TABLE Produto (
    Id_produto INT CONSTRAINT Pk_prod PRIMARY KEY IDENTITY (1,1),
    Nome VARCHAR (80),
    Estoque INT,
    Unidade VARCHAR (40),
    CONSTRAINT PÇ_estoque CHECK (Unidade = 'PÇ' OR Estoque>0)

)

CREATE TABLE Item (
    Id_item INT CONSTRAINT Pk_item PRIMARY KEY IDENTITY (1,1),
    Quantidade INT,
    Vl_unitario MONEY,
    Id_produto INT CONSTRAINT Fk_produto FOREIGN KEY REFERENCES Produto(Id_produto),
    Id_venda INT CONSTRAINT Fk_venda FOREIGN KEY REFERENCES Venda(Id_venda)

)

CREATE TABLE Comissao (
    Id_comissao INT CONSTRAINT Pk_comi PRIMARY KEY IDENTITY (1,1),
    Valor MONEY CONSTRAINT Ck_valor CHECK(Valor>0),
    Id_venda INT CONSTRAINT Fk_venda FOREIGN KEY REFERENCES Venda(Id_venda)
)
CREATE TABLE Venda (
    Id_venda INT CONSTRAINT Pk_venda PRIMARY KEY IDENTITY (1,1),
    Vl_frete MONEY,
    Data DATE CONSTRAINT Df_data DEFAULT(GETDATE()),
    Id_cli INT CONSTRAINT Fk_cli FOREIGN KEY REFERENCES Cliente(Id_cli),
    Id_vend INT CONSTRAINT Fk_vend FOREIGN KEY REFERENCES Vendedor(Id_vend)
)






