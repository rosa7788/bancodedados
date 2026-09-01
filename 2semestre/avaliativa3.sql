-- -- Exercício 01:
-- 1. Criar uma tabela com o nome TB_CLIENTE. A tabela deverá conter a seguinte estrutura:
--  a. Um atributo código do tipo inteiro;
--  b. Um atributo nome do tipo cadeia de caracteres de tamanho 50;
--  c. Um atributo telefone do tipo cadeia de caracteres de tamanho 20;
--  d. Um atributo tipo_cliente do tipo cadeia de caracteres de tamanho 20;
--  e. Um atributo dt_cadastro do tipo data e hora;
--  f. Um atributo nr_dependentes do tipo inteiro.
--  g. Todos os atributos da tabela devem ser obrigatórios.

-- 2. A tabela acima deve conter as seguintes restrições:
--  a. O atributo código representa a chave primária da tabela;
--  b. O atributo dt_cadastro (data do cadastro) deve ter como valor padrão (default) a data e hora atual do sistema;
--  c. O atributo tipo_cliente deve ser “Titular” ou “Dependente”;
--  d. O atributo nr_dependentes deve ser um inteiro maior ou igual a 0 e <= a 3.

CREATE TABLE TB_CLIENTE (
    codCliente INT CONSTRAINT pk_cliente PRIMARY KEY IDENTITY(1, 1),
    nome VARCHAR(50) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    tipo_cliente VARCHAR(20) CONSTRAINT tipos_clientes CHECK(tipo_cliente IN ('Titular', 'Dependente')) NOT NULL,
    dt_cadastro DATETIME CONSTRAINT dt_cadastro_cliente DEFAULT GETDATE() NOT NULL,
    nr_dependentes INT CONSTRAINT nr_dependentes_cliente CHECK(nr_dependentes BETWEEN 0 AND 3) NOT NULL
)

-- 3. Utilizar comandos SQL de inserção e atualização que tentem verificar e violar as -- restrições acima.

INSERT INTO TB_CLIENTE VALUES
    ('Igor', 'xx99xxxxx', 'titular', 4);
-- viola o tipo_cliente e nr_dependentes

-- Exercício 02:
-- Dado o seguinte esquema relacional:
--     Marca (id_marca, nome)
--     Produto (id_pro, nome_produto, id_marca, estoque, preço)
--     Pedido(id_pedido, data_pedido, valor_desc, valor_total)
--     ItemPedido (id_pedido, id_pro, qtde, vl_unit)
-- em que:
--     id_marca – identificador único da marca
--     nome – nome completo da marca, também único
--     id_pro- inteiro identificador de produto
--     nome_produto – não necessariamente único, descreve o produto, p.ex. “borracha”
--     estoque – inteiro que define a quantidade em estoque (sempre positivo)
--     preço – preço de venda do produto
--     id_pedido – inteiro identificador do pedido
--     data – data do pedido

-- Defina em SQL as seguintes restrições de integridade:
-- 1. O nome_produto é de preenchimento obrigatório.
ALTER TABLE Produto
ALTER column nome_produto VARCHAR(100) NOT NULL;

-- 2. Todos os valores da marca na relação Produto existem na relação Marca em id_marca.
ALTER TABLE Produto
ADD CONSTRAINT fk_produto_marca FOREIGN KEY (id_marca) REFERENCES Marca(id_marca);

-- 3. O id_pro é um inteiro com 4 dígitos.
ALTER TABLE Produto
ALTER column id_pro NUMERIC(4);

-- 4. A data do pedido é por padrão a data atual.
ALTER TABLE Pedido
ADD CONSTRAINT DF_Pedido_Data
DEFAULT GETDATE() FOR data_pedido;

-- 5. No mesmo pedido, não pode haver mais de uma venda do mesmo produto.
ALTER TABLE ItemPedido
ADD CONSTRAINT UC_Pedido_Produto UNIQUE (id_pedido, id_pro);

-- 6. Se o preço de um item vendido é superior a 1000 então a quantidade vendida tem de ser menor que 100.
ALTER TABLE ItemPedido
ADD constraint item_pedido_vl_unit_qtde CHECK (vl_unit <= 1000 OR qtde < 100);

-- 7. O valor total do Estoque de cada Produto não pode exceder os 250.000 (considerando o preço de venda).
ALTER TABLE Produto
ADD CONSTRAINT x CHECK((estoque * preco) <= 250000);