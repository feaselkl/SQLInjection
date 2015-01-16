<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SPWrong.aspx.cs" Inherits="SQLInjectionWorkbench.SPWrong" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Stored Procedures:  You're Doing It Wrong!</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <p>This is an example of using an insecure data access construct to turn a presumed safe process (running a static stored procedure) into an unsafe process.
        Note that the stored procedure is itself safe, and you will not be able to affect the results on the page--though do give it a try.  Watch out for page errors, though. 
        You can, however, perform blind SQL injection attacks, so focus more on inserts, account creations, and drops.</p>
        <p>After you're done, uncomment out the line of code which reads "sda.SelectCommand.CommandType = CommandType.StoredProcedure;" and see the difference.</p>
        <p>Before you do any of these attacks, however, I recommend that you:</p>
        <ol>
            <li>Make a backup of your AdventureWorks database (as well as any other databases you may wish to edit).</li>
            <li>Run SQL Profiler on your local machine, to get an idea of what kind of traffic is being passed through.</li>
        </ol>
    </div>
    <div>
        <asp:TextBox ID="txtSearch" runat="server" Text="Enter some text here." />
        <asp:Button ID="btnClickMe" runat="server" Text="Click Me!" OnClick="btnClickMe_Click" />
    </div><br />
    <div>
        Here is a happy grid.  You shouldn't do anything evil to this because that would be bad!
    </div>
    <div>
        <asp:GridView ID="gvGrid" runat="server" AutoGenerateColumns="true">
            <Columns>
                <asp:TemplateField>
                    <HeaderTemplate>Other Name</HeaderTemplate>
                    <ItemTemplate><%# Eval("Name") %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>Other Name As Label</HeaderTemplate>
                    <ItemTemplate><asp:Label ID="lblName" runat="server"><%# Eval("Name") %></asp:Label></ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div><br />
    </form>
</body>
</html>
