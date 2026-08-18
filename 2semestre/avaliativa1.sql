CREATE DATABASE Clinica
USE Clinica;

CREATE TABLE "Veterinario" (    "CodMed"   INT PRIMARY KEY,    
"Nome"     VARCHAR(100) NOT NULL,   
"DataNasc" DATE NOT NULL );

CREATE TABLE "Animal" (    
"CodPac"     INT PRIMARY KEY,    
"NomeAnimal" VARCHAR(100) NOT NULL,    
"Especie"    VARCHAR(50) NOT NULL );

CREATE TABLE "Consulta" (    
"CodCons"  INT PRIMARY KEY,   
 "DataCons" DATE NOT NULL,    
"Valor"    NUMBER(10,2) NOT NULL,    
"CodMed"   INT NOT NULL REFERENCES "Veterinario"("CodMed"),    
"CodPac"   INT NOT NULL REFERENCES "Animal"("CodPac") );

INSERT INTO "Veterinario" ("Nome", "DataNasc") VALUES 
('Ana Souza',      '1985-03-12'), 
('Bruno Lima',     '1990-07-22'), 
('Carla Dias',     '1978-11-05'), 
('Diego Alves',    '1992-01-30'), 
('Elisa Martins',  '1983-09-14');

INSERT INTO "Animal" ("NomeAnimal", "Especie") VALUES 
('Rex',   'Cachorro'), 
('Mimi',  'Gato'),
('Loro',  'Ave'), 
('Bidu',  'Cachorro'), 
('Fifi',  'Gato'), 
('Piu',   'Ave'), 
('Thor',  'Cachorro'), 
('Nina',  'Gato'),
 ('Kiwi',  'Ave'), 
('Bolt',  'Cachorro');

INSERT INTO "Consulta" ("DataCons", "Valor", "CodMed", "CodPac") VALUES ('2026-01-15', 120.00, 1, 1),
 ('2026-01-20', 150.50, 2, 2), 
('2026-02-05', 200.00, 3, 3), 
('2026-02-18',  95.75, 1, 4), 
('2026-03-01', 180.00, 4, 5), 
('2026-03-10', 210.25, 5, 6), 
('2026-03-22', 130.00, 2, 7), 
('2026-04-03', 175.50, 3, 8), 
('2026-04-15', 160.00, 1, 9), 
('2026-05-02', 220.00, 4, 10), 
('2026-05-19', 140.75, 5, 1), 
('2026-06-08', 190.00, 2, 2), 
('2026-06-25', 205.50, 3, 3),
('2026-07-02', 165.00, 1, 4), 
('2026-07-09', 230.00, 4, 5), 
('2026-07-16', 145.25, 5, 6), 
('2026-07-23', 250.00, 2, 7), 
('2026-07-28', 110.00, 3, 8), 
('2026-08-05', 195.75, 1, 9), 
('2026-08-10', 260.00, 4, 10);

SELECT MAX("Valor") AS "MaiorValor" 
FROM "Consulta";

SELECT    AVG("Valor") AS "ValorMedio",    
MAX("Valor") AS "MaiorValor",   
 MIN("Valor") AS "MenorValor" 
FROM "Consulta" WHERE "DataCons" >= date_trunc('month', CURRENT_DATE - INTERVAL '1 month')  AND "DataCons" <  date_trunc('month', CURRENT_DATE);

INSERT INTO "Consulta" ("DataCons", "Valor", "CodMed", "CodPac") VALUES ('2026-08-14', 175.00, 2, 3);

SET "Nome" = 'Seu Nome Aqui' WHERE "CodMed" = 3;

SELECT "Especie" FROM "Animal";

SELECT COUNT(*) AS "TotalConsultas" 
FROM "Consulta" WHERE "CodMed" = 3;

SELECT COUNT(*) AS "TotalConsultas" 
FROM "Consulta";

SELECT DISTINCT "Especie"
 FROM "Animal";

SELECT "NomeAnimal" 
FROM "Animal" ORDER BY "NomeAnimal" ASC;

SELECT SUM("Valor") AS "ValorTotal" 
FROM "Consulta" WHERE "CodMed" = 3;

SELECT COUNT(*) AS "TotalMedicos" 
FROM "Veterinario";

SELECT SUM("Valor") * 1.10 AS "ValorComAumento"
FROM "Consulta" WHERE "CodMed" = 3;

SELECT COUNT(*) AS "ConsultasNoPeriodo" 
FROM "Consulta" WHERE "CodMed" = 3  AND "DataCons" BETWEEN '2026-01-01' AND '2026-03-31';



