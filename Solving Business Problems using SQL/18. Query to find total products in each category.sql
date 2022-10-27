SELECT 
	CategoryName,
	COUNT(*) AS [Total Products]
FROM products AS p
INNER JOIN categories AS c
ON p.CategoryID = c.CategoryID
GROUP BY CategoryName
ORDER BY [Total Products] DESC;