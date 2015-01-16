<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QueryDriven.aspx.cs" Inherits="SQLInjectionWorkbench.QueryDriven" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>A Query-Driven Test</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <p>This is a test of ad hoc SQL which is susceptible to SQL injection.  Feel free to test various techniques, see what you can do, and generally try
        to break the system.  Before doing that, I would recommend that you:</p>
        <ol>
            <li>Make a backup of your AdventureWorks database (as well as any other databases you may wish to edit).</li>
            <li>Run SQL Profiler on your local machine, to get an idea of what kind of traffic is being passed through.</li>
            <li>Observe the code.  There is a blacklist with three settings (for querystrings, it's automatically set to Slightly Less Naive Stop), so see what
            that does to your attacks.</li>
        </ol>
    </div>
    <div>
        <asp:TextBox ID="txtSearch" runat="server" Text="Enter some text here." />
        <asp:Button ID="btnClickMe" runat="server" Text="Click Me!" OnClick="btnClickMe_Click" />
    </div><br />
    <div>
        You searched for:  <asp:Label ID="lblSearchString" runat="server" />
    </div><br />
    <div>
        <asp:RadioButtonList ID="rblStopping" runat="server">
            <asp:ListItem Text="Do Nothing" Value="0" Selected="True" />
            <asp:ListItem Text="Naive Stop" Value="1" />
            <asp:ListItem Text="Slightly Less Naive Stop" Value="2" />
        </asp:RadioButtonList>
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
