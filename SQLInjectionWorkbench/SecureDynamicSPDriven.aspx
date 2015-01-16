<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SecureDynamicSPDriven.aspx.cs" Inherits="SQLInjectionWorkbench.SecureDynamicSPDriven" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <p>This is a test of safe dynamic SQL usage in a stored procedure.  Try what you will, but you cannot use SQL injection to attack this page.</p>
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
