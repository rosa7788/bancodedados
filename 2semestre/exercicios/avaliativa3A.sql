-- -- Exercício 01:
-- 1. Criar uma tabela com o nome TB_CLIENTE. A tabela deverá conter a seguinte estrutura:
--  a. Um atributo código do tipo inteiro;
--  b. Um atributo nome do tipo cadeia de caracteres de tamanho 50;
--  c. Um atributo telefone do tipo cadeia de caracteres de tamanho 20;
--  d. Um atributo tipo_cliente do tipo cadeia de caracteres de tamanho 20;
--  e. Um atributo dt_cadastro do tipo data e hora;
--  f. Um atributo nr_dependentes do tipo inteiro.
--  g. Todos os atributos da tabela devem ser obrigatórios.

CREATE TABLE TB_CLIENTE (
    codCliente INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    tipo_cliente VARCHAR(20) NOT NULL,
    dt_cadastro DATETIME NOT NULL,
    nr_dependentes INT NOT NULL
)

-- 2. A tabela acima deve conter as seguintes restrições:
--  a. O atributo código representa a chave primária da tabela;
ALTER TABLE TB_CLIENTE
ADD CONSTRAINT pk_cliente PRIMARY KEY(codCliente); -- Não é possível usar identity

--  b. O atributo dt_cadastro (data do cadastro) deve ter como valor padrão (default) a data e hora atual do sistema;
ALTER TABLE TB_CLIENTE
ADD CONSTRAINT dt_cadastro_cliente DEFAULT(GETDATE()) FOR dt_cadastro;

--  c. O atributo tipo_cliente deve ser “Titular” ou “Dependente”;
ALTER TABLE TB_CLIENTE
ADD CONSTRAINT tipos_clientes CHECK(tipo_cliente IN ('Titular', 'Dependente'));

--  d. O atributo nr_dependentes deve ser um inteiro maior ou igual a 0 e <= a 3.
ALTER TABLE TB_CLIENTE
ADD CONSTRAINT nr_dependentes_cliente CHECK(nr_dependentes BETWEEN 0 AND 3);

-- OU

CREATE TABLE TB_CLIENTE ( 
    codCliente INT IDENTITY(1, 1) NOT NULL, 
    nome VARCHAR(50) NOT NULL, 
    telefone VARCHAR(20) NOT NULL, 
    tipo_cliente VARCHAR(20) NOT NULL, 
    dt_cadastro DATETIME DEFAULT GETDATE() NOT NULL, 
    nr_dependentes INT NOT NULL, 
    
    CONSTRAINT pk_cliente PRIMARY KEY(codCliente), 
    CONSTRAINT tipos_clientes CHECK(tipo_cliente IN ('Titular', 'Dependente')), 
    CONSTRAINT nr_dependentes_cliente CHECK(nr_dependentes BETWEEN 0 AND 3) 
);