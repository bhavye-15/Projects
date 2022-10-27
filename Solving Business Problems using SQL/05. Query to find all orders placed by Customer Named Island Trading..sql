SELECT * FROM orders;

SELECT * 
	FROM customers
	WHERE CompanyName = 'Island Trading';

SELECT orderID, orderDate 
	FROM  orders
	WHERE customerID = 'ISLAT';