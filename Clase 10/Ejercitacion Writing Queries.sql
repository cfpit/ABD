--PROCEDIMIENTOS ALMACENADOS

--82: Crear un procedimiento almacenado que dada una determinada inicial ,devuelva codigo, nombre,apellido y direccion de correo de los empleados cuyo nombre coincida con la inicial ingresada

 CREATE PROCEDURE InformarEmpleadosPorInicial(@inicial char(1))
 AS 
    BEGIN
        SELECT		BusinessEntityID as Codigo, 
                    FirstName +' '+ LastName as Empleado, 
                    EmailAddress as 'Correo Electronico'
        FROM		HumanResources.vEmployee
        WHERE		FirstName LIKE @inicial + '%'
        ORDER BY	FirstName
    END

GO
EXECUTE InformarEmpleadosPorInicial @inicial='a'
EXECUTE InformarEmpleadosPorInicial @inicial='j'
EXECUTE InformarEmpleadosPorInicial @inicial='m'


--83: Crear un procedimiento almacenado que devuelva los productos que lleven de fabricado la cantidad de dias que le 
pasemos como parametro

create Procedure TiempoDeFabricacion(@dias int = 1)
AS
    BEGIN
        SELECT	    Name, ProductNumber, DaysToManufacture
        FROM		Production.Product
        WHERE		DaysToManufacture = @dias
    END
GO

EXECUTE TiempoDeFabricacion @dias=2
EXECUTE TiempoDeFabricacion @dias=4
EXECUTE TiempoDeFabricacion @dias=5 
EXECUTE TiempoDeFabricacion


84: Crear un procedimiento almacenado que permita actualizar y ver los precios de un determinado 
producto que reciba como parametro

CREATE PROCEDURE ActualizarPrecios
(@cantidad as float,@codigo as int)
AS
    BEGIN
        UPDATE Production.Product
        SET ListPrice = ListPrice*@cantidad
        WHERE ProductID=@codigo

        SELECT Name,ListPrice
        FROM Production.Product
        WHERE ProductID=@codigo
    END

GO
EXECUTE ActualizarPrecios 1.1, 886

SELECT listPrice from production.Product
WHERE ProductID=886 -- Antes: 366,762  Despues: 403,4382


--85: Armar un procedimineto almacenado que devuelva los proveedores que proporcionan el producto especificado por parametro

CREATE PROCEDURE Proveedores(@producto varchar(30)='%')
AS
    
    SELECT      v.Name proveedor,
                p.Name producto 
    
    FROM        Purchasing.Vendor AS v 
    INNER JOIN  Purchasing.ProductVendor AS pv
    ON          v.BusinessEntityID = pv.BusinessEntityID 
    INNER JOIN  Production.Product AS p 
    ON          pv.ProductID = p.ProductID 
    WHERE       p.Name LIKE @producto
    ORDER BY    v.Name 
GO    

EXECUTE Proveedores 'r%'
EXECUTE Proveedores 'reflector'
EXECUTE Proveedores 


--86: Crear un procedimiento almacenado que devuelva nombre,apellido y sector del empleado que le 
pasemos como argumento.no es necesario pasar el nombre y apellido exactos al procedimiento.
 
CREATE PROCEDURE empleados
    @apellido nvarchar(50)='%', 
    @nombre nvarchar(50)='%' 
AS 
    SELECT FirstName, LastName,Department
    FROM HumanResources.vEmployeeDepartmentHistory
    WHERE FirstName LIKE @nombre AND LastName LIKE @apellido
GO

EXECUTE empleados  'eric%' 
EXECUTE empleados



--FUNCIONES ESCALARES

--87: Armar una funcion que devuelva los productos que estan por encima del promedio de precios general

CREATE FUNCTION promedio()
RETURNS MONEY
AS
BEGIN
        DECLARE @promedio MONEY
        SELECT @promedio=AVG(ListPrice) FROM Production.Product
        RETURN @promedio
END


--uso de la funcion
SELECT  * 
FROM    Production.Product 
WHERE   ListPrice >dbo.promedio()

SELECT AVG(ListPrice) FROM Production.Product --438.6662


--88: Armar una función que dado un código de producto devuelva el total de ventas para dicho producto.Luego, mediante una consulta, traer codigo, nombre y total de ventas ordenados por esta ultima columna

CREATE FUNCTION VentasProductos(@codigoProducto int) 
RETURNS int
AS
 BEGIN
   DECLARE @total int
   SELECT @total = SUM(OrderQty)
   FROM Sales.SalesOrderDetail WHERE ProductID = @codigoProducto
   IF (@total IS NULL)
      SET @total = 0
   RETURN @total
 END
 
--uso de la funcion
SELECT      ProductID "codigo producto",
            Name nombre,
            dbo.VentasProductos(ProductID) AS "total de ventas"
FROM        Production.Product
ORDER BY    3 DESC