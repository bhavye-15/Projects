SELECT 
	ProductID,
	ProductName,
	UnitsInStock,
	ReorderLevel
FROM Products
WHERE UnitsInStock <= ReorderLevel
ORDER BY ReorderLevel DESC;