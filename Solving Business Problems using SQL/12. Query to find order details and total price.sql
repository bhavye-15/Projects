SELECT 
OrderID,
ProductID,
UnitPrice,
Quantity,
Discount,
(Quantity * UnitPrice) AS TotalPrice
FROM [Order Details]
ORDER BY OrderID, ProductID; 