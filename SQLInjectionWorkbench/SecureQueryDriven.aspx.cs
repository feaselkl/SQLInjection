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
    public partial class SecureQueryDriven : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Using .NET 4.0 here.  If you want to use 2.0/3.5, change to IsNullOrEmpty.
                if (!String.IsNullOrWhiteSpace(Request.QueryString["search"]))
                {
                    LoadData(Request.QueryString["search"]);
                }
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
                Response.Write("You need a filter here, buddy!");
                gvGrid.Visible = false;
            }
            else
            {
                using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["AdventureWorks"].ConnectionString))
                {
                    string sql = String.Empty;
                    sql = "select Name, ProductSubcategoryID, ProductCategoryID from Production.ProductSubcategory where Name like '%' + @Filter + '%' order by ProductSubcategoryID;";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        //create a parameter for @Filter
                        SqlParameter filter = new SqlParameter();
                        filter.ParameterName = "@Filter";
                        filter.Size = 50;
                        filter.Value = Filter;

                        //attach our parameter to the SqlCommand
                        cmd.Parameters.Add(filter);

                        cmd.CommandTimeout = 30;
                        conn.Open();

                        //We're using a reader, so there's no way that anybody could do anything bad, right?
                        SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                        gvGrid.DataSource = dr;
                        gvGrid.DataBind();
                        gvGrid.Visible = true;
                    }
                }
            }
        }
    }
}