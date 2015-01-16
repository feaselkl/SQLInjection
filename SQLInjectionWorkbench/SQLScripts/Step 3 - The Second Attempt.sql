/*
	Part 3a:  The Second Attempt
	This time, we will use dynamic SQL to create our query.
	Note that the simply query works just fine; this is simply
	another (more complex) way of writing our initial query.
*/
USE [AdventureWorks2012]
GO
DECLARE @Filter NVARCHAR(MAX) = N'Bike';

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'
SELECT
	ps.ProductCategoryID,
	ps.ProductSubcategoryID,
	ps.Name
FROM
	Production.ProductSubcategory ps
WHERE
	ps.Name LIKE ''%' + @Filter + '%'';';

EXEC(@sql);


/*
	Part 3b:  The Second Attempt
	Trying a SQL injection attack on this...
*/
USE [AdventureWorks2012]
GO
DECLARE @Filter NVARCHAR(MAX) = N'Test'' OR 1 = 1--';

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'
SELECT
	ps.ProductCategoryID,
	ps.ProductSubcategoryID,
	ps.Name
FROM
	Production.ProductSubcategory ps
WHERE
	ps.Name LIKE ''%' + @Filter + '%'';';

EXEC(@sql);

/*
	We were able to get "outside" the filter.  In this case,
	our query became:
*/
	SELECT
		ps.ProductCategoryID,
		ps.ProductSubcategoryID,
		ps.Name
	FROM
		Production.ProductSubcategory ps
	WHERE
		ps.Name LIKE '%Test' OR 1 = 1--%';
	--Note where the red text (indicating a string) ends
/*
	This will return all results from the table because of the
	"OR 1 = 1" portion.  The -- comments out the rest of the dynamic
	SQL code the developer wrote.
*/