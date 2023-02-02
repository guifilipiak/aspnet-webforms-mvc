using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AspNetWebFormsTeste
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadGridView();
        }

        private void LoadGridView()
        {
            DataTable dt = new DataTable();
            dt.Columns.AddRange(new DataColumn[3] { new DataColumn("Id"), new DataColumn("Name"), new DataColumn("Country") });
            dt.Rows.Add(1, "John Hammond", "United States");
            dt.Rows.Add(2, "Mudassar Khan", "India");
            dt.Rows.Add(3, "Suzanne Mathews", "France");
            dt.Rows.Add(4, "Robert Schidner", "Russia");
            gridViewDataTable.DataSource = dt;
            gridViewDataTable.DataBind();
        }

        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

            con.Open();
            String str = "INSERT INTO Animal VALUES ('" + txtNomeAnimal.Text + "', " + ddlEspecie.SelectedValue + ")";
            SqlCommand cmd = new SqlCommand(str, con);
            int id = Convert.ToInt32(cmd.ExecuteNonQuery());
            if (id > 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, typeof(_Default), "retorno_insert", "alert('Animal inserido com sucesso!')", true);
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, typeof(_Default), "retorno_insert_catch", "alert('Algo de errado aconteceu, tente novamente!')", true);
            }
            con.Close();

            gridViewAnimais.DataBind();
        }

        // The id parameter name should match the DataKeyNames value set on the control
        //public void DeletarAnimal(int id)
        //{
        //    try
        //    {
        //        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        //        con.Open();
        //        String str = "DELETE Animal WHERE Id = " + id;
        //        SqlCommand cmd = new SqlCommand(str, con);
        //        cmd.ExecuteNonQuery();
        //        ScriptManager.RegisterClientScriptBlock(this, typeof(_Default), "retorno_delete", "alert('Animal removido com sucesso!')", true);
        //        con.Close();

        //        gridViewAnimais.DataBind();
        //    }
        //    catch (Exception)
        //    {
        //        ScriptManager.RegisterClientScriptBlock(this, typeof(_Default), "retorno_delete_catch", "alert('Algo de errado aconteceu, tente novamente!')", true);
        //    }
        //}

        //protected void gridViewAnimais_RowCommand(object sender, GridViewCommandEventArgs e)
        //{
        //    if(e.CommandName == "Delete")
        //    {
        //        int rowIndex = Convert.ToInt32(e.CommandArgument);
        //        GridViewRow row = gridViewAnimais.Rows[rowIndex];
        //        int customerId = int.Parse(row.Cells[0].Text);

        //        DeletarAnimal(customerId);
        //    }
        //}

        //protected void btnDeleteRow_Command(object sender, CommandEventArgs e)
        //{
        //    DeletarAnimal(int.Parse(e.CommandArgument.ToString()));
        //}
    }
}