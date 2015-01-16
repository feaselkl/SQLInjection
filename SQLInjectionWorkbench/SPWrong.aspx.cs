using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace SQLInjectionWorkbench
{
    public partial class SPWrong : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Using .NET 4.0 here.  If you want to use 2.0/3.5, change to IsNullOrEmpty.
                if (!String.IsNullOrWhiteSpace(Request.QueryString["search"]))
                    LoadData(Request.QueryString["search"]);
            }
        }

        protected void btnClickMe_Click(object sender, EventArgs e)
        {
            LoadData(txtSearch.Text);
        }

        protected void LoadData(string Filter)
        {
            //Using .NET 4.0 here.  If you want to use 2.0/3.5, change to IsNullOrEmpty.
            if (String.IsNullOrWhiteSpace(Filter))
            {
                //This cleverly prevents anybody from seeing the whole list.  Mission Accomplished.
                Response.Write("You need a filter here, buddy!");
                gvGrid.Visible = false;
            }
            else
            {
                using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["AdventureWorks"].ConnectionString))
                {
                    //.NET 1.1 called--they want their data adapter back.
                    DataSet ds = new DataSet();
                    SqlDataAdapter sda = new SqlDataAdapter("Production.GetProductSubcategoryByName '" + Filter + "'", conn);
                    //Problem #1:  running a stored procedure as a regular SQL query.
                    //sda.SelectCommand.CommandType = CommandType.StoredProcedure;
                    //If you uncomment the line above, at least the query would fail.
                    sda.Fill(ds);

                    gvGrid.DataSource = ds;
                    gvGrid.DataBind();
                }
            }
        }
    }
}