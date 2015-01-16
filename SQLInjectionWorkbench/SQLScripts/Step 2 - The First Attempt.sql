/* 
	Part 2:  The First Attempt 
	SQL injection involves getting "outside" the filter.
	We want to inject an SQL query in @Filter to perform
	some action other than simply filtering product 
	sub-categories.
*/
USE [AdventureWorks2012]
GO
DECLARE @Filter NVARCHAR(MAX) = N'Test'' OR 1 = 1--';

SELECT
	ps.ProductCategoryID,
	ps.ProductSubcategoryID,
	ps.Name
FROM
	Production.ProductSubcategory ps
WHERE
	ps.Name LIKE '%' + @Filter + '%';

/*
	We are unable to get "outside" the @Filter parameter,
	so this query is completely safe.  If you create a stored
	procedure based on this code, there is no way for an 
	attacker to call the stored procedure from SQL Server
	and perform a SQL injection attack.

	[There is a way to exploit this code from a web application]
*/