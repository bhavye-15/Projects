SELECT DISTINCT(ShipCountry) FROM orders;

SELECT 
	OrderID,
	CustomerID,
	OrderDate,
	ShipCountry
FROM orders
WHERE ShipCountry IN ('Brazil','Argentina','Venezuela','Mexico');