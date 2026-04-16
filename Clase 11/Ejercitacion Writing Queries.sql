--89: Armar una función que dado un año , devuelva nombre y  apellido de los empleados que ingresaron ese año

CREATE FUNCTION AñoIngresoEmpleados (@año int)
RETURNS TABLE
AS
	RETURN
	(
		SELECT FirstName, LastName,HireDate
		FROM Person.Person p
		INNER JOIN HumanResources.Employee e
		ON e.BusinessEntityID= p.BusinessEntityID
		WHERE year(HireDate)=@año
	)
	
--uso de la funcion
SELECT * FROM dbo.AñoIngresoEmpleados(2004)-- 45
SELECT * FROM dbo.AñoIngresoEmpleados(2000)-- 1

--90: Armar una función que dado el codigo de negocio cliente de la fabrica, devuelva el codigo, nombre y las ventas del año hasta la fecha para cada producto vendido en el negocio ordenadas por esta ultima columna.

CREATE FUNCTION VentasNegocio (@codNegocio int)
RETURNS TABLE
AS
RETURN 
(
    SELECT P.ProductID, P.Name, SUM(SD.LineTotal) AS 'Total'
    FROM Production.Product AS P 
    JOIN Sales.SalesOrderDetail AS SD ON SD.ProductID = P.ProductID
    JOIN Sales.SalesOrderHeader AS SH ON SH.SalesOrderID = SD.SalesOrderID
    JOIN Sales.Customer AS C ON SH.CustomerID = C.CustomerID
    WHERE C.StoreID = @codNegocio
    GROUP BY P.ProductID, P.Name
    
)

--uso de la funcion
SELECT		* 
FROM		dbo.VentasNegocio (1340)
ORDER BY	3 DESC;

--91: Crear una  función llmada "ofertas" que reciba un parámetro correspondiente a un precio y nos retorne una 
tabla con código,nombre, color y precio de todos los productos cuyo precio sea inferior al parámetro ingresado


 CREATE FUNCTION ofertas(@minimo decimal(6,2))
 RETURNS @oferta table
 (codigo int,
  nombre varchar(40),
  color varchar(30),
  precio decimal(6,2)
 )
 AS
	 BEGIN
	    INSERT @oferta
		SELECT	ProductID,Name,Color,ListPrice
		FROM	Production.Product
		WHERE	ListPrice<@minimo
	    RETURN
	 END

--uso de la funcion

 SELECT *
 FROM	dbo.ofertas(1)


 --92: Mostrar la cantidad de horas que transcurrieron desde el comienzo del año

SELECT DATEDIFF(HOUR, '01-01-2000',GETDATE())


--93: Mostrar la cantidad de dias transcurridos entre la primer y la ultima venta 

SELECT	DATEDIFF(DAY,(SELECT MIN(OrderDate)FROM Sales.SalesOrderHeader),
					 (SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader))