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
    public partial class InsecureDynamicSPDriven : System.Web.UI.Page
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
                #region Stop Evil Hackers
                int StoppingValue = 0;

                if (String.IsNullOrWhiteSpace(Request.QueryString["search"]))
                    StoppingValue = Convert.ToInt32(rblStopping.SelectedValue);
                else
                    StoppingValue = 2;

                if (StoppingValue > 0)
                {
                    if (FilterHasBadWords(Filter, StoppingValue))
                    {
                        Response.Write("You are an evil hacker and will go to evil hacker prison!");
                        gvGrid.Visible = false;

                        return;
                    }
                }
                #endregion

                using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["AdventureWorks"].ConnectionString))
                {
                    string sql = "Production.GetProductSubcategoryByName_Dynamic_Incorrect";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        //We are parameterizing our query here, like we're supposed to.  Unfortunately, the procedure itself is problematic.
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

        protected bool FilterHasBadWords(string Filter, int StoppingValue)
        {
            switch (StoppingValue)
            {
                case 1:
                    //We are totally going to stop the bad guys with this!  And no false positives, either!
                    if (Filter.ToLower().Contains("select") || Filter.ToLower().Contains("insert") || Filter.ToLower().Contains("drop"))
                        return true;
                    else
                        return false;
                case 2:
                    //Okay, so we scared the little old ladies using our program, but this will definitely work!
                    if (Filter.ToLower().Contains("select ") || Filter.ToLower().Contains("insert ") || Filter.ToLower().Contains("drop "))
                        return true;
                    else
                        return false;
                default:
                    return false;
            }
        }
    }
}