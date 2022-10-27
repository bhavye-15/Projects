SELECT 
	contactTitle,
	COUNT(*) AS TotalContactTitle
FROM Customers
GROUP BY Contacttitle
ORDER BY TotalContactTitle DESC;