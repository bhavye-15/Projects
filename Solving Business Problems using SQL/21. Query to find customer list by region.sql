SELECT 
	customerid,
	CompanyName,
	region
FROM customers
ORDER BY 
CASE
WHEN region IS NULL THEN 1
ELSE 0
END,
region, customerid;