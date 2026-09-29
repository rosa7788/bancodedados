create database exerc04
go
use exerc04

create table Func (
         CodFunc int constraint pk_func primary key, 
         PrimeiroNome varchar(50), 
         SegundoNome varchar(50), 
         UltimoNome varchar(50), 
         DataNasci datetime, 
         CPF   varchar(20), 
         RG varchar(20), 
         Endereco varchar(50), 
         CEP varchar(15), 
         Cidade varchar(50), 
         Fone varchar(20), 
         CodDepto int, 
         Funcao varchar(50), 
         Salario money
)

create table Depto (
          CodDepto int constraint pk_deto primary key, 
          Nome varchar(50), 
          Localizacao varchar(50), 
          CodigoFuncionarioGerente int
)

alter table Func
add constraint fk_depto_func foreign key (CodDepto) references Depto(CodDepto)

alter table Depto
add constraint fk_func_gerente foreign key (CodigoFuncionarioGerente) 
      references Func(CodFunc)


INSERT INTO DEPTO 
values
      (1,         'RH',            'SUL',      NULL),
      (2,         'COMPRAS',         'SUL',      NULL),
      (3,         'VENDAS',         NULL,      NULL),
      (4,         'FINANCEIRO',      'NORTE',   NULL),
      (5,         'MARKETING',      'NORTE',   NULL),
      (6,         'DESENVOLVIMENTO',   NULL,      NULL),
      (7,         'CONTABILIDADE',   NULL,      NULL)


INSERT INTO Func (CodFunc, PrimeiroNome, SegundoNome, 
               UltimoNome, DataNasci, Cidade, 
               Funcao, Salario)
values (1, 'JOSE', 'MANOEL', 'DA SILVA', 
            '1980/01/01','FRANCA',
            'CONTADOR', 1200.00)

update func set salario = 1700
where codFunc = 5

--1 listar todos os campos de funcionarios ordenados por cidade
SELECT * 
FROM Func
ORDER BY cidade;

--2 obter os nomes dos funcionarios nascidos entre as datas 1950-01-01 e 1970-01-01
SELECT PrimeiroNome
FROM Func
WHERE DataNasci BETWEEN '1950-01-01' AND '1970-01-01'


--3 liste os funcionarios que tem salario superior a 1000 ordenados pelo nome completo

SELECT PrimeiroNome
FROM Func
WHERE salario > 1000
ORDER BY PrimeiroNome, SegundoNome, UltimoNome

--4 liste a data de nascimento e o primeiro nome dos funcionarios ordenados do mais novo para o mais velho
SELECT DataNasci, PrimeiroNome
FROM Func
ORDER BY DataNasci desc;


--5 liste o total da folha de pagamento
SELECT SUM(salario) AS ToTFolha
FROM Func


--6 liste o nome, o nome do departamento e a função de todos os funcionarios
SELECT f.PrimeiroNome, d.Nome AS Depto, f.funcao
FROM Func f INNER JOIN depto d ON f.codDepto = d.codDepto