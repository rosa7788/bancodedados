CREATE TABLE Professores (
codProf int constraint pk_codProf primary key identity(1,1), 
nome varchar(80) NOT NULL, 
RG numeric(12) UNIQUE, 
sexo char(1) check(sexo in ('M', 'F')),
idade int check(idade between 21 and 80), 
cidade varchar(50) CONSTRAINT DF_Prof_cidade DEFAULT ('FRANCA'), 
titulacao varchar(15) CONSTRAINT chk_tit check(titulacao in ('graduado','especialista', 'mestre', 'doutor')), 
categoria varchar (15) check(categoria in ('auxiliar', 'assistente','adjunto',
'titular')),
salario money check (salario>=500)
)