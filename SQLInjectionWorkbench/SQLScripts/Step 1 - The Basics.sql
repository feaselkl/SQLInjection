/*
	Part 1:  The Basics
	This is a basic query.  Understanding the basics will 
	help us understand SQL injection better.
*/
USE [AdventureWorks2012]
GO
DECLARE @Filter NVARCHAR(MAX) = N'Test';

SELECT
	ps.ProductCategoryID,
	ps.ProductSubcategoryID,
	ps.Name
FROM
	Production.ProductSubcategory ps
WHERE
	ps.Name LIKE '%' + @Filter + '%';
GO