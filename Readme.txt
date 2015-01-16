SQL Injection Workbench
A code sample for Tribal SQL (http://tribalsql.com/)

Author:		Kevin Feasel
Contact:	feaselkl@gmail.com
Last Updated:	2012-04-07

REQUIREMENTS:
	- Some version of SQL Server.  This was tested on 2008.
	- Some version of Visual Studio (for edits).  I used 2010 for the project and solution.  If you have a later version, you can convert it easily; otherwise, you would need to create your own project and solution files and include the aspx pages and references.  At worst, you could probably just run the page, because I do have a compiled DLL in the bin folder.
	- .NET Framework 4.0.  If you don't have 4.0 installed, you'll need to edit the project to scale it down to .NET 2.0/3.5, which will include a couple minor tweaks on pages.  I left comments wherever those changes are necessary.
	- AdventureWorks is set up.  For the sake of simplicity, I assumed that you have your SQL Server instance running as the default instance on localhost. If not, change the web.config file's connection string information.

IMPORTANT NOTES:
First of all, do NOT run this on a production environment.  There is UNSAFE code in this project.  Run it on a local machine (preferably without an Internet connection, but at least behind a router).  When you play with fire, caution bordering on paranoia is your friend.

The code in this project is slightly more complex than the samples in Tribal SQL.  I have added to some of the samples a simplistic blacklist (which, naturally, doesn't really work).  You can try to create a better blacklist, and then break your blacklist, if that's the type of thing you're into.

Before you actually play around with the code, there are three stored procedures you will need to create in the AdventureWorks database.  You can find them in the "SQLInjection Workbench Notes.sql" file in this project.

Finally, have fun.  Once you start getting proficient with the basics, try out various techniques, as well as automated tools (I recommend sqlmap:  http://sqlmap.sourceforge.net).
