--59. mostrar las ordenes de venta que se hayan facturado en territorio de estado unidos unicamente 'us' 
-- por join
SELECT      soh.*
FROM        Sales.SalesOrderHeader AS soh
INNER JOIN  Sales.SalesTerritory AS st ON soh.TerritoryID = st.TerritoryID
WHERE       st.CountryRegionCode = 'US'

-- por subconsulta
SELECT      *
FROM        Sales.SalesOrderHeader 
WHERE       TerritoryID IN (SELECT TerritoryID 
                                FROM Sales.SalesTerritory 
                                WHERE CountryRegionCode = 'US')


-- 60. al ejercicio anterior agregar ordenes de francia e inglaterra
SELECT      *
FROM        Sales.SalesOrderHeader 
WHERE       TerritoryID IN (SELECT TerritoryID 
                                FROM Sales.SalesTerritory 
                                WHERE CountryRegionCode IN ('US', 'FR', 'GB'))

--61.mostrar los nombres de los diez productos mas caros. Utilizr subconsultas con operador IN
SELECT      Name, ListPrice
FROM        Production.Product
WHERE       ListPrice IN (  SELECT TOP 10 ListPrice 
                            FROM Production.Product 
                            ORDER BY ListPrice DESC
                        )

--62.mostrar aquellos productos cuya cantidad de pedidos de venta sea igual o superior a 20 utilizando subconsultas con operador IN
SELECT      Name, ProductID
FROM        Production.Product
WHERE       ProductID IN (  SELECT ProductID
                            FROM Sales.SalesOrderDetail 
                            GROUP BY ProductID 
                            HAVING COUNT(*) >= 20
                        )

--63. listar el nombre y apellido de los empleados que tienen un sueldo basico de 5000 pesos. Utilizar subconsultas con operador IN
SELECT      p.FirstName +' '+ p.LastName as Empleado
FROM        HumanResources.Employee e
INNER JOIN  Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID
WHERE       e.BusinessEntityID IN   (   SELECT BusinessEntityID 
                                        FROM Sales.SalesPerson   
                                        WHERE Bonus = 5000
                                    ) 

-- Uso de predicados
create database predicados
GO
use predicados
GO
create table productos(idProducto int, precio int)
create table ventas(idVenta int, monto int)
GO
insert into productos values(1, 100),(2, 200),(3, 300),(4, 1000)
insert into ventas values(1, 300),(2, 600),(3, 500),(4, 200)
GO
SELECT * from productos
SELECT * from ventas
                        
-- Listar los productos cuyo precio supere todos los montos facturados
SELECT *
FROM productos
WHERE precio > ALL (SELECT monto FROM ventas)

-- Listar los productos cuyo precio sea mayor a cualquier monto facturado
SELECT *
FROM productos
WHERE precio > ANY (SELECT monto FROM ventas)

-- Listar los productos cuyo precio sea igual a algun monto facturado
SELECT *
FROM productos
-- WHERE precio = ANY (SELECT monto FROM ventas)
WHERE precio IN (SELECT monto FROM ventas)

-- =ANY es igual que IN, pero IN es más eficiente

-- Listar los productos cuyo precio NO sea igual a ningun monto facturado
SELECT *
FROM productos
-- WHERE precio <> ALL (SELECT monto FROM ventas)
WHERE precio NOT IN (SELECT monto FROM ventas)

-- <>ALL es igual que NOT IN, pero NOT IN es más eficiente

use [AdventureWorks2008R2]

-- 64.mostrar los nombres de todos los productos de ruedas que fabrica adventure works cycles. Resolver por subconsulta con =any
SELECT Name producto
FROM Production.Product
WHERE ProductSubcategoryID =ANY (	SELECT	ProductSubcategoryID
									FROM	Production.ProductSubcategory
									WHERE	Name = 'Wheels')

--65.mostrar los clientes ubicados en un territorio no cubierto por ningún vendedor
-- por subconsulta con operador <>ALL
SELECT *
FROM Sales.Customer 
-- WHERE TerritoryID NOT IN (SELECT TerritoryID FROM Sales.SalesPerson)
WHERE TerritoryID != ALL (SELECT TerritoryID FROM Sales.SalesPerson) 

--66. listar los productos cuyos precios de venta sean mayores o iguales que el precio de venta máximo de cualquier subcategoría de producto. Por subconsulta con operador >=ANY
SELECT Name producto, ListPrice
FROM Production.Product
WHERE ListPrice >= ANY (SELECT MAX(ListPrice)
						FROM Production.Product
						GROUP BY ProductSubcategoryID)

--expresion case
/*
67.listar el nombre de los productos, el nombre de la subcategoria a la que pertenece junto a su categoría de precio. La categoría de precio se calcula de la siguiente manera. 
	-si el precio está entre 0 y 1000 la categoría es económica.
	-si la categoría está entre 1001 y 2000, normal 
	-y si su valor es mayor a 2000 la categoría es cara.
*/
SELECT      p.Name producto,
            p.ListPrice Precio,
            ps.Name subcategoria,
            (CASE 
                WHEN ListPrice BETWEEN 0 AND 1000 THEN 'Economica'
                WHEN ListPrice BETWEEN 1001 AND 2000 THEN 'Normal'
                ELSE 'Cara'
            END) as categoria
FROM        Production.Product p
INNER JOIN  Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
ORDER BY    p.ListPrice DESC


--68.tomando el ejercicio anterior, mostrar unicamente aquellos productos cuya categoria sea "economica"
SELECT  *
FROM    (   SELECT  p.Name producto,
                    p.ListPrice Precio,
                    ps.Name subcategoria,
                    (CASE 
                        WHEN ListPrice BETWEEN 0 AND 1000 THEN 'Economica'
                        WHEN ListPrice BETWEEN 1001 AND 2000 THEN 'Normal'
                        ELSE 'Cara'
                    END) as categoria
            FROM        Production.Product p
            INNER JOIN  Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
        ) as subconsulta
WHERE   subconsulta.categoria = 'Economica'

-- insert, update y delete

-- 69.aumentar un 20% el precio de lista de todos los productos  
UPDATE Production.Product
SET ListPrice = ListPrice * 1.2

--70.aumentar un 20% el precio de lista de los productos del proveedor 1540
UPDATE Production.Product
SET ListPrice = ListPrice * 1.2
WHERE ProductID IN (SELECT ProductID 
                    FROM Purchasing.ProductVendor 
                    WHERE BusinessEntityID = 1540)

-- por join
UPDATE p
SET ListPrice = ListPrice * 1.2
FROM Production.Product p
INNER JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
WHERE pv.BusinessEntityID = 1540 


-- 71.agregar un dia de vacaciones a los 10 empleados con mayor antiguedad.
UPDATE  e
SET     VacationHours = VacationHours + 24
FROM    HumanResources.Employee e
WHERE   BusinessEntityID IN     (
                                    SELECT TOP 10   BusinessEntityID 
                                    FROM            HumanResources.Employee 
                                    ORDER BY        HireDate
                                )

--72. eliminar los detalles de compra (purchaseorderdetail) cuyas fechas de vencimiento pertenezcan al tercer trimestre del año 2006
DELETE FROM Purchasing.PurchaseOrderDetail
-- WHERE DueDate BETWEEN '2006-07-01' AND '2006-09-30'
WHERE YEAR(DueDate) = 2006 AND MONTH(DueDate) BETWEEN 7 AND 9

--73.quitar registros de la tabla salespersonquotahistory cuando las ventas del año hasta la fecha almacenadas en la tabla salesperson supere el valor de 2500000
DELETE FROM Sales.SalesPersonQuotaHistory
WHERE       BusinessEntityID IN (
                                    SELECT BusinessEntityID 
                                    FROM Sales.SalesPerson 
                                    WHERE SalesYTD > 2500000
                                )















