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
    public partial class SecureDynamicSPDriven : System.Web.UI.Page
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
                Response.Write("You need a filter here, buddy!");
                gvGrid.Visible = false;
            }
            else
            {
                using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["AdventureWorks"].ConnectionString))
                {
                    string sql = "Production.GetProductSubcategoryByName_Dynamic_Correct";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        SqlParameter ssname = new SqlParameter();
                        ssname.DbType = DbType.String;
                        ssname.Size = 256;
                        ssname.Value = Filter;
                        ssname.ParameterName = "@Filter";

                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandTimeout = 30;
                        cmd.Parameters.Add(ssname);

                        conn.Open();

                        SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                        gvGrid.DataSource = dr;
                        gvGrid.DataBind();
                        gvGrid.Visible = true;
                    } //close command
                }
            }
        }
    }
}