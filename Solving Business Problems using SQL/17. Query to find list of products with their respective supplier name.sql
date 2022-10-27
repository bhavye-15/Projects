SELECT
	ProductID,
	ProductName,
	CompanyName AS [Supplier Name]
FROM Products AS p
JOIN Suppliers AS s
ON p.SupplierID = s.SupplierID;
