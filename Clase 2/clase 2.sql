use [AdventureWorks2008R2]

select	*
from	[Production].[Product]

-- Listar el nombre, el color , el precio y el precio con iva
-- de la primera mitad de todos los productos cuyo precio sea 
-- mayor a cero, ordenados en forma descendente

select	top 50 percent	'Info' as Informacion,--columna agregada
						[Name] as Nombre,
						[Color] color,
						[ListPrice] 'Precio de Lista',
						ListPrice * 1.21 'Precio con IVA'--columna calculada
from					[Production].[Product]
where					ListPrice > 0
order by				ListPrice desc

-- Listar los diferentes colores de los productos
-- Clausula Distinct: devuelve los diferentes valores de una columna
select	distinct (Color) as 'Diferentes Colores de Productos' 
from	[Production].[Product]
where	Color is not null

-- funcion ifnull (MySQL)
-- funcion isnull (SQL Server)
select	distinct(isnull(Color,'Sin pintar')) as 'Color de Producto'
from	Production.Product

-- Funciones de Agrupacion
select	max(ListPrice) 'Precio del Producto mas caro' 
from	Production.Product --3578,27 dolares

select	min(ListPrice) 'Precio del Producto mas barato' 
from	Production.Product 
where	ListPrice <> 0 -- 2,29 dolares

select	avg(ListPrice) 'Precio Promedio de todos los Productos' 
from	Production.Product -- 438,6662 dolares

select	sum(ListPrice) 'Suma de todos los Precios' 
from	Production.Product -- 221087,79 dolares

select	count(ProductID) 'Cantidad de Productos' 
from	Production.Product -- 504

-- Agrupaciones
-- Informar la cantidad de productos por color
select		Color,
			COUNT(ProductID) cantidad
from		Production.Product
where		Color like 's%'
group by	Color
having		COUNT(ProductID) > 20
order by	2 desc
-- concat (MySQL)
-- listar el nombre concatenado con el apellido de las personas
select	FirstName + ' ' + LastName as 'Nombre completo'
from	Person.Person

-- ej7: 
select	*
from	Production.Product
where	ListPrice < 150 and Color = 'red'
or		ListPrice > 500 and Color = 'black'

-- listar los productos cuyo color sea blanco, negro o rojo
select	*
from	Production.Product
-- where	Color in ('white','black','red')
where	Color not in ('white','black','red') 

-- Ej 8: 
select	*
from	HumanResources.Employee
where	HireDate > '2000-01-01'

-- listar los empleados que ingresaron entre los años 1990 y 2000
select	*
from	HumanResources.Employee
where	year(HireDate) between 1990 and 2000

-- listar los empleados que ingresaron el 31 de Julio del 2000
select	*
from	HumanResources.Employee
where	year(HireDate) = 2000
and		MONTH(HireDate) = 7
and		day(HireDate) = 31

-- Ej 9:
select	*
from	Production.Product
where	SellEndDate < GETDATE()

-- operador Like
-- listar todos los empleados que ingresaron entre 2000 y 2004
select	*
from	HumanResources.Employee
-- where	HireDate like '%200[0-4]%' -- rango de valores
-- where	HireDate like '%200[1,3,4]%' -- lista de valores
-- where	HireDate like '%200[^1]%' -- negacion
-- where	HireDate like '%200[^1-3]%' -- negacion de rango
where	HireDate like '%200[^1,3]%' -- negacion de lista

-- listar el nombre de las personas que empiecen con m, el segundo
-- caracter sea cualquiera, el 3er caracter sea r y el resto como sea. Ordenar alfabeticamente
-- Maria, Marcelo, Moria, Mirko, Mariana, Martin, Mercedes, Mirtha
select		FirstName + ' ' + LastName as Nombre
from		Person.Person
where		FirstName like 'm_r%'
order by	1















