<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SQLInjectionWorkbench.Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SQL Injection Workbench</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <p>This is the SQL Injection Workbench, an accompaniment to Tribal SQL's chapter on SQL injection.  Each section is designed to 
        be a stand-alone case; most of the files share a great deal of code which would normally be abstracted out into business and
        data object layers.</p>
        <p>The following files contain <strong>bad</strong> code:  QueryDriven.aspx, SPWrong.aspx, and InsecureDynamicSPDriven.aspx.  The other three
        contain code which is not susceptible to SQL injection attacks.</p>
    </div><br />
    <div>
        <ol>
            <li><a href="QueryDriven.aspx">Query-Driven Test</a> (unsafe)</li>
            <li><a href="SPDriven.aspx">Static Stored Procedure-Driven Test</a> (safe)</li>
            <li><a href="SPWrong.aspx">Stored Procedures:  You're Doing It Wrong!</a> (unsafe)</li>
            <li><a href="InsecureDynamicSPDriven.aspx">Insecure Dynamic SP-Driven Test</a> (unsafe)</li>
            <li><a href="SecureDynamicSPDriven.aspx">Secure Dynamic SP-Driven Test</a> (safe)</li>
            <li><a href="SecureQueryDriven.aspx">Secure Query-Driven Test</a> (safe)</li>
        </ol>
    </div>
    </form>
</body>
</html>
