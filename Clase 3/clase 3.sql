-- TPN1 Writing Queries
-- 6. mostrar el nombre concatenado con el apellido de las personas cuyo apellido sea johnson
select	FirstName + ' ' + LastName as 'Nombre de Persona'
from	Person.Person
where	LastName = 'johnson'


-- 12. mostrar los codigos de venta y producto,cantidad de venta y precio unitario de los articulos 750,753 y 770
SELECT SalesOrderID, OrderQty, ProductID, UnitPrice
FROM Sales.SalesOrderDetail
WHERE ProductID IN (750, 753, 770)

-- 15. mostrar el nombre, precio y color de los accesorios para asientos de las bicicletas cuyo precio sea  mayor a 100 pesos
select	Name Nombre, 
		ListPrice Precio, 
		Color
from	Production.Product
where	ListPrice > 100 and Name like '%seat%'

-- 20. mostrar el nombre concatenado con el apellido de las personas cuyo apellido tengan terminacion española (ez)
select	FirstName + ' ' + LastName as Persona
from	Person.Person
where	LastName like '%ez'

-- 21. mostrar los nombres de los productos que su nombre termine en un numero 
select	Name as Producto
from	Production.Product
where	Name like '%[0-9]'

-- 22. mostrar las personas cuyo  nombre tenga una c o C como primer caracter, cualquier otro como segundo caracter, ni d ni D ni f ni g como tercer caracter, cualquiera entre j y r o entre s y w como cuarto caracter y el resto sin restricciones
select	FirstName Nombre
from	Person.Person
where	FirstName like '[c,C]_[^dDfg][j-w]%'

-- 23. mostrar las personas ordernadas primero por su apellido y luego por su nombre
select		FirstName + '            ' + LastName as Persona 
from		Person.Person
order by	LastName asc, FirstName asc

-- 24. mostrar cinco productos mas caros y su nombre ordenado en forma alfabetica
select	top 5	*
from			Production.Product
order by		ListPrice desc, Name asc

-- 25. mostrar la fecha mas reciente de venta
select	MAX(OrderDate) as 'fecha mas reciente de venta'
from	Sales.SalesOrderHeader


-- 26. mostrar el precio mas barato de todas las bicicletas 
select	MIN(ListPrice) as 'bici mas barata'
from	Production.Product
where	ProductNumber like '%bk%'

-- 27. mostrar la fecha de nacimiento del empleado mas joven 
select	Max(BirthDate) as 'Nacimiento del empleado mas joven'
from	HumanResources.Employee

-- 28. mostrar los representantes de ventas (vendedores) que no tienen definido el numero de territorio
SELECT *
FROM Sales.SalesPerson
WHERE TerritoryID IS NULL


-- 29. mostrar el peso promedio de todos los articulos. si el peso no estuviese definido, reemplazar por cero
select	AVG(ISNULL(Weight, 0)) as 'Peso Promedio'
from	Production.Product

-- 30. mostrar el codigo de subcategoria y el precio del producto mas barato de cada una de ellas 
select		ProductSubcategoryID as Subcategoria,
			MIN(ListPrice) 'Precio mas barato'
from		Production.Product
group by	ProductSubcategoryID





