SELECT 
	COUNT(CustomerID) AS [Total Customers],
	City,
	Country
FROM customers
GROUP BY country, city
ORDER BY [Total Customers] DESC;