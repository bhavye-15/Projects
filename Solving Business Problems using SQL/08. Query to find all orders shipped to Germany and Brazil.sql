SELECT
	OrderID,
	CustomerID,
	OrderDate,
	ShipCountry
FROM Orders
WHERE ShipCountry = 'Germany' OR ShipCountry = 'Brazil';