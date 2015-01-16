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
    public partial class QueryDriven : System.Web.UI.Page
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
                //This section was not directly covered in the chapter.  It shows the folly of a simple blacklist.
                //Check out the blacklists; you should be able to figure out some very simple false positives, as well as fairly simple false negatives.
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
                    string sql = String.Empty;
                    sql = "select Name, ProductSubcategoryID, ProductCategoryID from Production.ProductSubcategory where Name like '%" + Filter + "%' order by ProductSubcategoryID;";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.CommandTimeout = 30;
                        conn.Open();

                        SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                        gvGrid.DataSource = dr;
                        gvGrid.DataBind();
                        gvGrid.Visible = true;
                    }

                    lblSearchString.Visible = gvGrid.Visible;
                    lblSearchString.Text = Filter;
                }
            }
        }

        protected bool FilterHasBadWords(string Filter, int StoppingValue)
        {
            switch(StoppingValue)
            {
                case 1:
                    //We are totally going to stop the bad guys with this!  And no false positives, either!
                    if (Filter.ToLower().Contains("select") || Filter.ToLower().Contains("insert") || Filter.ToLower().Contains("drop"))
                        return true;
                    else
                        return false;
                case 2:
                    //Okay, so we scared the little old ladies using our program when they entered the word "selected" with the first blacklist attempt, 
                    //but this one will definitely work!
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