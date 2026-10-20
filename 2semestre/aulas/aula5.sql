CREATE DATABASE restaurante;
USE restaurante;

CREATE TABLE mesa(
    nroMesa INT PRIMARY KEY IDENTITY(1,1),
    setor VARCHAR(30),
    capacidade INT,
    situacao VARCHAR(15)
)

CREATE TABLE garcom(
    codGarcom INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(50),
    calcularComissao MONEY
)

CREATE TABLE produto(
    codPro INT PRIMARY KEY IDENTITY(1,1),
    descricao VARCHAR(80),
    preco money
)

CREATE TABLE atendimento(
    codAtendimento INT PRIMARY KEY IDENTITY(1,1),
    situacao VARCHAR(15),
    dtHrChegada DATETIME2,
    nroPessoas INT,
    nroMesa INT FOREIGN KEY REFERENCES mesa(nroMesa) NOT NULL,
    codGarcom INT FOREIGN KEY REFERENCES garcom(codGarcom) NOT NULL
)

CREATE TABLE consumo(
    codConsumo INT PRIMARY KEY IDENTITY(1,1),
    qtde INT,
    vlrUnit MONEY,
    codPro INT FOREIGN KEY REFERENCES produto(codPro) NOT NULL,
    codAtendimento INT FOREIGN KEY REFERENCES atendimento(codAtendimento) NOT NULL
)

INSERT INTO mesa VALUES
    ('VARANDA', 4, 'ATENDENDO'),
    ('VARANDA', 5, 'AGUARDANDO'),
    ('INTERNO', 4, 'ATENDENDO'),
    ('INTERNO', 4, 'ATENDIDO'),
    ('VIP', 6, 'ATENDENDO')

INSERT INTO produto VALUES
    ('BATATA FRITA', 5.00),
    ('COCA-COLA LATA', 6.00),
    ('QUIBE COM QUEIJO', 12.00),
    ('CHOPP 500ML', 8.00),
    ('TORRE CHOPP', 35.00),
    ('COXINHA', 9.00),
    ('SALADA', 10.00),
    ('ESPETINHO', 8.00),
    ('ÁGUA COM GÁS', 7.00),
    ('ÁGUA SEM GÁS', 6.00),
    ('GUARANÁ LATA', 5.50)

INSERT INTO garcom (nome) VALUES
    ('JOSÉ'),
    ('PAULO'),
    ('MARIA'),
    ('ANA'),
    ('PEDRO')

INSERT INTO atendimento VALUES
    ('ATENDENDO', 1, 1, 4, '2026-06-09'),
    ('ATENDENDO', 2, 2, 3, '2026-06-10'),
    ('AGUARDANDO', 1, 3, 2, '2026-05-15'),
    ('AGUARDANDO', 5, 5, 6, '2026-05-20'),
    ('ATENDENDO', 2, 1, 5, '2026-01-02'),
    ('ATENDIDO', 3, 3, 4, '2026-02-01'),
    ('ATENDIDO', 4, 5, 4, '2026-03-02'),
    ('AGUARDANDO', 3, 4, 4, '2026-06-09'),
    ('ATENDENDO', 1, 4, 3, '2026-06-07'),
    ('ATENDENDO', 2, 2, 5, '2026-06-08')

select * from consumo

INSERT INTO consumo VALUES
    (2, 5.00, 1, 8),
    (3, 6.00, 2, 9),
    (2, 12.00, 3, 10),
    (3, 8.00, 4, 11),
    (1, 35.00, 5, 12),
    (1, 35.00, 6, 13),
    (2, 10.00, 7, 14),
    (2, 10.00, 7, 15),
    (4, 8.00, 8, 16),
    (7, 7.00, 9, 17),
    (4, 60.00, 10, 17),
    (1, 7.00, 9, 16),
    (2, 9.00, 6, 15),
    (3, 5.50, 11, 13),
    (2, 6.00, 2, 12),
    (3, 5.00, 1, 11)

-- 2. Atualize o nome do garçom que possui maior código para o seu nome
UPDATE garcom SET nome = 'JONATA'
    WHERE codGarcom = (SELECT MAX(codGarcom) FROM garcom)

-- 3. Crie uma campo para guardar o salário dos garçons
ALTER TABLE garcom
    add salario MONEY

-- 4. Liste os produtos e seus preços em ordem do mais caro para o mais barato
SELECT descricao, preco FROM produto
    ORDER BY preco DESC

-- 5. Liste o número e o setor das mesas que estão em atendimentos (situação = 'ATENDENDO')
SELECT M.nroMesa AS 'nº mesa', setor FROM
    mesa AS M INNER JOIN atendimento AS A
    ON A.nroMesa = M.nroMesa
    WHERE A.situacao = 'ATENDENDO'

-- 6. Atualize o salário de cada garçom
UPDATE garcom SET salario = 1800

-- 7. Liste o seu salário caso você tivesse um aumento de salário de 15%
-- Não atualize seu novo salário, apenas o exiba com o possível aumento
SELECT nome, (salario * 1.15) AS 'novo salario' FROM garcom
    WHERE nome = 'JONATA'

-- 8. Cadastre uma nova mesa e 2 novos atendimentos para esta mesa. Você é o garçom
-- que está atendendo estes clientes e eles já consumiram 3 produtos diferentes
INSERT INTO mesa VALUES ('VIP', 8, 'OCUPADO')

INSERT INTO atendimento VALUES 
    ('ATENDENDO', 1002, 5, 4, '2026-06-10'),
    ('FINALIZADO', 1002, 5, 3, '2026-06-10') 

INSERT INTO consumo VALUES 
    (1, 5, 1, 1002),
    (1, 6, 2, 1002),
    (1, 12, 3, 1002)

-- 9. Liste os produtos que nunca foram consumidos
INSERT INTO produto VALUES ('OVO', 1) -- novo produto não consumido

SELECT P.descricao AS nomeProduto FROM
    produto AS P LEFT JOIN consumo AS C
    ON C.codPro = P.codPro
    WHERE C.codPro IS NULL

-- 10. Liste os atendimentos já realidados no dia de hoje. Considere apenas atendimentos
-- que já estão com situação de 'FINALIZADO', juntamente com os nomes dos garçons
-- que fizeram tais atendimentos
SELECT A.codAtendimento, A.situacao, G.nome AS nomeGarcom FROM
    atendimento AS A INNER JOIN garcom AS G
    ON A.codGarcom = G.codGarcom
    -- Faz o Casting das datas como DATE para ignorarem as horas
    -- GETDATE() pega o dia/hora atuais
    WHERE A.situacao = 'FINALIZADO' AND CAST(A.dtHrCheada AS DATE) = CAST(GETDATE() AS DATE)