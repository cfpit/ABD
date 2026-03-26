-- Operaciones entre consultas

create database operaciones
go
use operaciones
go

create table A (pais varchar(20))
create table B (pais varchar(20))

insert into A values('Arg'),('Bra'),('Uru')
insert into B values('Arg'),('Col'),('Ven')

select * from A
select * from B

-- operaciones entre consultas

select pais from A
union
select pais from B

select pais from A
union all
select pais from B

select pais from A
intersect
select pais from B

select pais from A
except
select pais from B

select pais from B
except
select pais from A

-- Listar el titulo de los libros y las ciudades donde
-- fueron escritos o publicados (usar base pubs)


-- Consultas Anidadas = subconsultas = subselect = subqueries
-- El motor de la BD resuelve primero la consulta anidada o interna

-- Formato devuelto por la subconsulta y su ubicacion dentro del select externo
/*
	SELECT (escalar)
	FROM	(tabla)
	WHERE	(escalar) (lista)
	GROUP BY - 
	HAVING	(escalar)
	ORDER BY -
*/

select * from [HumanResources].[EmployeeDepartmentHistory]

--51.listar todos las productos cuyo precio sea inferior al precio promedio de todos los productos 
select      * 
FROM        [Production].[Product]
where       ListPrice < (select avg(ListPrice) from [Production].[Product])
ORDER BY    ListPrice DESC

-- promedio de precio de los productos por categoria = 438,6662 USD

--52.listar el nombre, precio de lista, precio promedio y diferencia de precios entre cada producto y el valor promedio general 
SELECT          Name Producto, 
                ListPrice Precio, 
                (select avg(ListPrice) from Production.Product) as Promedio, 
                ListPrice - (select avg(ListPrice) from Production.Product) as Diferencia
FROM            Production.Product
ORDER BY        ListPrice DESC

-- 53. mostrar el o los codigos del producto mas caro 
SELECT      ProductID Codigo, 
            Name Producto,
            ListPrice Precio 
FROM        Production.Product
-- WHERE       ListPrice = (SELECT MAX(ListPrice) FROM Production.Product)
WHERE       ListPrice = 3578.27

-- valor maximo = 3578,27 USD


--54. mostrar el producto mas barato de cada subcategoría. mostrar subcategoria, codigo de producto y el precio de lista mas barato ordenado por subcategoria 
SELECT      psc.Name Subcategoria, 
            p.ProductID Codigo, 
            p.ListPrice Precio
FROM        Production.Product p
INNER JOIN  Production.ProductSubcategory psc 
ON          p.ProductSubcategoryID = psc.ProductSubcategoryID
WHERE       ListPrice = (
                            SELECT  MIN(ListPrice) 
                            FROM    Production.Product p2 
                            WHERE   p2.ProductSubcategoryID = psc.ProductSubcategoryID
                        )
ORDER BY    psc.Name


--55.mostrar los nombres de todos los productos presentes en la subcategoría de ruedas 

-- x join
SELECT      p.Name Producto
FROM        Production.Product p    
INNER JOIN  Production.ProductSubcategory psc 
ON          p.ProductSubcategoryID = psc.ProductSubcategoryID
WHERE       psc.Name = 'Wheels'

--x subconsulta
SELECT      Name Producto
FROM        Production.Product
WHERE       ProductSubcategoryID = (
                                        SELECT  ProductSubcategoryID 
                                        FROM    Production.ProductSubcategory 
                                        WHERE   Name = 'Wheels'
                                    )

--x subconsulta con EXISTS
SELECT      Name Producto
FROM        Production.Product p
WHERE       EXISTS (
                        SELECT  1 
                        FROM    Production.ProductSubcategory psc 
                        WHERE   psc.Name = 'Wheels' 
                                AND psc.ProductSubcategoryID = p.ProductSubcategoryID
                    )



--56.mostrar todos los productos que no fueron vendidos
-- X join
SELECT      p.Name Producto
FROM        Production.Product p
LEFT JOIN   Sales.SalesOrderDetail sod  
ON          p.ProductID = sod.ProductID
WHERE       sod.SalesOrderDetailID IS NULL

-- por subconsulta con exists
SELECT      Name Producto
FROM        Production.Product p
WHERE       NOT EXISTS (
                            SELECT  1 
                            FROM    Sales.SalesOrderDetail sod 
                            WHERE   sod.ProductID = p.ProductID
                        )   


-- 58.mostrar todos los vendedores (nombre y apellido) que no tengan asignado un territorio de ventas 

-- x join
SELECT      p.FirstName + ' ' + p.LastName as Vendedor
FROM        Person.Person p
INNER JOIN  Sales.SalesPerson sp
ON          p.BusinessEntityID = sp.BusinessEntityID
LEFT JOIN   Sales.SalesTerritory st
ON          st.TerritoryID = sp.TerritoryID
WHERE       st.TerritoryID IS NULL

-- por subconsulta con exists
SELECT      p.FirstName + ' ' + p.LastName as Vendedor
FROM        Person.Person p
INNER JOIN  Sales.SalesPerson sp
ON          p.BusinessEntityID = sp.BusinessEntityID
WHERE       NOT EXISTS (
                            SELECT  1 
                            FROM    Sales.SalesTerritory st 
                            WHERE   st.TerritoryID = sp.TerritoryID
                        )

|









