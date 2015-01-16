/*
	Part 4:  Fixing The Problem
	There is one solution for SQL injection:  parameterizing queries.
	We can use sp_executesql to force parameters.
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
	ps.Name LIKE ''%'' + @Filter + ''%'';';

EXEC sp_executesql
	@sql,
	N'@Filter NVARCHAR(max)',
	@Filter;

/*
	This dynamic SQL is a little bit different.  @Filter is now
	a parameter inside our dynamic SQL instead of being concatenated
	with the SQL statement.

	We tell sp_executesql to expect a parameter called @Filter in
	our query and replace its contents with those inside the @Filter
	parameter we pass in.

	When we parameterize a query, special characters get escaped
	appropriately.  For example, each single quote (') gets doubled up
	to ensure that we never get outside the query.

	Our query above translates into:	
*/
	SELECT
		ps.ProductCategoryID,
		ps.ProductSubcategoryID,
		ps.Name
	FROM
		Production.ProductSubcategory ps
	WHERE
		ps.Name LIKE '%Test'''' OR 1 = 1--%';
	--Note where the red text (indicating a string) ends
/*
	There is no way for an attacker to escape a properly
	parameterized query in SQL Server.  If you have a
	stored procedure with dynamic SQL appropriately
	parameterized, it is not possible for an attacker to
	call that stored procedure to perform arbitrary code.
*/