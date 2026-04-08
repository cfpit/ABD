create database dml
go
use dml


create table clientes(
						codigo int primary key identity(1,1),
						nombre varchar(40) not null,
						dni int not null unique,
						sexo char(1) not null default 'F',
						categoria int not null check (categoria between 1 and 10) 
  
						);

						--insert

--simple

--variante 1
insert into clientes (nombre,dni,sexo,categoria)
values	('carlos',25765981,'M',6)

insert into clientes (nombre,dni,sexo,categoria)
values	('jose',24578965,'M',3)

insert into clientes (nombre,dni,categoria)
values	('maria',19653827,8)

insert into clientes (nombre,dni,categoria)
values	('mariana',20123456,5)
						

select * from clientes	

-- clonacion de tabla (campos y datos) sin restricciones
select *
into clientes2
from clientes

--clonacion de tabla (solo campos) sin restricciones
select *
into clientes3
from clientes
where 1=2  --false no carga los datos

select * from clientes
select * from clientes2
select * from clientes3		


-- insert
--variante 2 (todos los registros deben tener la misma cantidad de columnas)

truncate table clientes

delete from clientes

SELECT * FROM clientes

-- insert multiple
insert into clientes (nombre,dni,sexo,categoria)
values	('carlos',25765981,'M',6),
		('jose',24578965,'M',3),
		('maria',19653827,'F',8),
		('mariana',20123456,'F',5);

-- no cumple restriccion(constraint) check	

--insert into clientes (nombre,dni,categoria)
--values ('maria',9653827,18)

--no cumple restriccion unique

--insert into clientes (nombre,dni,categoria)
--values ('jorge',24578965,9)



-- insert multiple con origen de datos proveniente de otra tabla
insert into clientes3(nombre,dni,sexo,categoria)
select nombre,convert(varchar(8),dni),sexo,categoria -- cast(dni as varchar(8))
from clientes
where codigo>2

use dml
select * from clientes3

--otros tipos de clonacion de tablas

--full
select *
into clientes4
from clientes

--parcial (solo algunos campos)

select codigo,nombre
into clientes5
from clientes


--update

update clientes2 
set categoria=7,dni=23456789
where codigo=1

update clientes2
set categoria=categoria+1
where nombre='carlos'

--delete

delete from clientes2
where codigo=2

delete from clientes2 --delete masivo no borra la tabla solo todos los registros

truncate table clientes2 --no trabaja con transacciones es mas rapido que delete

drop table clientes4 --borra la tabla

--combinaciones con update 

use pubs
go

 update titles set price = price * 1.1
 from titles t
 inner join publishers p
 on t.pub_id = p.pub_id
 and p.pub_name = 'Algodata Infosystems';

select * from titles where pub_id = 1389

select * from publishers


-- 74. clonar estructura y datos de los campos nombre ,color y precio de lista de la tabla production.product en una tabla llamada productos
use [AdventureWorks2008R2] 

SELECT Name, Color, ListPrice
INTO 	productos
FROM	Production.product

select * from productos

-- 75. clonar solo estructura de los campos identificador ,nombre y apellido de la tabla person.person en una tabla llamada personas 
SELECT BusinessEntityID, FirstName, LastName
INTO 	personas	
FROM	person.Person
WHERE 	1=2

SELECT * FROM personas

--76.insertar un producto dentro de la tabla productos.tener en cuenta los siguientes datos. el color de producto debe ser rojo, el nombre debe ser "bicicleta mountain bike" y el precio de lista debe ser de 4000 pesos.
INSERT INTO productos (Name, Color, ListPrice)
VALUES ('bicicleta mountain bike', 'rojo', 4000)

select * from productos

--77. copiar los registros de la tabla person.person a la tabla personas cuyo identificador este entre 100 y 200
INSERT INTO personas (BusinessEntityID, FirstName, LastName)
SELECT BusinessEntityID, FirstName, LastName
FROM person.Person
WHERE BusinessEntityID BETWEEN 100 AND 200

--78. aumentar en un 15% el precio de los pedales de bicicleta
UPDATE productos
SET ListPrice = ListPrice * 1.15
WHERE Name LIKE '%pedal%'

SELECT * FROM productos
WHERE Name LIKE '%pedal%'

--79. eliminar de las personas cuyo nombre empiecen con la letra m
DELETE FROM personas
WHERE FirstName LIKE 'm%'

SELECT * FROM personas

--80. borrar todo el contenido de la tabla productos
DELETE FROM productos

--81. borrar todo el contenido de la tabla personas sin utilizar la instrucción delete.
TRUNCATE TABLE personas


