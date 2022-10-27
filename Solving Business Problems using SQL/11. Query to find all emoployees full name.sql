SELECT 
	EmployeeID,
	FirstName,
	LastName,
	(FirstName + ' ' + LastName) AS FullName
FROM Employees;