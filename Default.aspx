<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AspNetWebFormsTeste._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:SqlDataSource
        ID="SqlDataSourceGridView"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        runat="server"
        SelectCommand="Select a.*, e.Descricao as Especie from Animal a join Especie e ON a.IdEspecie = e.Id"
        UpdateCommand="UPDATE Animal set Nome = @Nome, IdEspecie = @IdEspecie where Id = @Id"
        DeleteCommand="DELETE FROM Animal WHERE Id=@Id">
        <UpdateParameters>
            <asp:Parameter Name="Nome" Type="String" />
            <asp:Parameter Name="IdEspecie" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceDropDown"
        runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT * FROM [Especie]"></asp:SqlDataSource>

    <asp:UpdatePanel runat="server" ID="updatePanelAnimais">
        <Triggers>
            <asp:PostBackTrigger ControlID="gridViewAnimais" />
        </Triggers>
        <ContentTemplate>
            <div class="row">
                <div class="col-md-6 pt">
                    <button type="button" class="btn btn-info" onclick="clickBotaoSubmitAjax()">Chamar Método Server API (Ajax)</button>
                </div>
                <div class="col-md-3 pt">
                    <button type="button" class="btn btn-info" onclick="clickBotaoRenderPartial()">Chamar Método Server Page (Ajax)</button>
                </div>
                <div class="col-md-3 pt">
                    <div id="contentRender"></div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <h1>Formulário DataTable</h1>
                    <asp:GridView runat="server" ID="gridViewDataTable" AutoGenerateColumns="true" AllowSorting="true" CssClass="table table-hover table-striped" GridLines="None" AllowPaging="True"></asp:GridView>
                </div>
                <div class="col-md-12">
                    <h1>Formulário Animal</h1>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <asp:Label runat="server" Text="Nome"></asp:Label>
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtNomeAnimal"></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ForeColor="Red" ValidationGroup="FormAnimal" ControlToValidate="txtNomeAnimal" ErrorMessage="Animal é obrigatório!"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <asp:Label runat="server" Text="Espécie"></asp:Label>
                                <asp:DropDownList ID="ddlEspecie" AppendDataBoundItems="true" runat="server" CssClass="form-control" DataSourceID="SqlDataSourceDropDown" DataTextField="Descricao" DataValueField="Id">
                                    <asp:ListItem Selected="True" Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator runat="server" ForeColor="Red" ValidationGroup="FormAnimal" ControlToValidate="ddlEspecie" ErrorMessage="Espécie é obrigatória!"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="col-md-4 pt">
                            <asp:Button ID="btnsubmit" ValidateRequestMode="Enabled" ValidationGroup="FormAnimal" runat="server" CssClass="btn btn-success" Text="Salvar" UseSubmitBehavior="true" OnClick="btnsubmit_Click" />
                        </div>
                    </div>
                </div>
                <div class="col-md-12">
                    <asp:GridView ID="gridViewAnimais" runat="server"
                        AllowSorting="true" CssClass="table table-hover table-striped"
                        GridLines="None" AllowPaging="True"
                        DataSourceID="SqlDataSourceGridView"
                        AutoGenerateColumns="False"
                        DataKeyNames="Id">
                        <RowStyle CssClass="cursor-pointer" />
                        <Columns>
                            <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" />
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:LinkButton ID="lbtnNome" runat="server" Text="Nome" CommandName="Sort" CommandArgument="Nome"></asp:LinkButton>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("Nome")%>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtNome" CssClass="form-control" runat="server" Text='<%#Bind("Nome")%>'></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="IdEspecie" Visible="false" HeaderText="IdEspecie" SortExpression="IdEspecie" />
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:LinkButton ID="lbtnEspecie" runat="server" Text="Especie" CommandName="Sort" CommandArgument="Especie"></asp:LinkButton>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("Especie") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEspecie" SelectedValue='<%#Bind("IdEspecie")%>' runat="server" CssClass="form-control" DataSourceID="SqlDataSourceDropDown" DataTextField="Descricao" DataValueField="Id"></asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:CommandField ShowDeleteButton="true" ShowEditButton="true" />
                        </Columns>
                        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Left" CssClass="pagination" />
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent" ID="ScriptContent">
    <script type="text/javascript">
        function clickBotaoSubmitAjax() {
            var url = new URL(document.URL);
            var cep = url.searchParams.get("cep");
            buscarEndereco(cep, function (successResult) {
                alert("callback success");
            }, function (failResult) {
                alert("callback fail");
            }, function (completedResult) {
                alert("callback completed");
            });
        }

        function clickBotaoRenderPartial() {
            buscarPartialView(function (html) {
                $("#contentRender").html(html);
            });
        }

        function buscarEndereco(cep, callbackSuccess, callbackFail, callbackComplete) {
            $.ajax({
                url: "/api/Default/GetAddress",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: {
                    cep: cep
                },
                beforeSend: function () {
                    alert("beforeSend");
                },
                success: function (result) {
                    alert("success");
                    if (callbackSuccess)
                        callbackSuccess(result);
                },
                error: function (xhr) {
                    alert("error");
                    if (callbackFail)
                        callbackFail(xhr);
                }
            }).done(function () {
                alert("done");
            }).fail(function () {
                alert("fail");
            });

            callbackComplete();
        }

        function buscarPartialView(callback) {
            $.ajax({
                url: "/Page/_PartialPage",
                //dataType: "html",
                //contentType: "application/json; charset=utf-8",
                data: {},
                beforeSend: function () {
                    alert("beforeSend");
                },
                success: function (result) {
                    alert("success");
                    if (callback)
                        callback(result);
                },
                error: function (xhr) {
                    alert("error");
                }
            }).done(function () {
                alert("done");
            }).fail(function () {
                alert("fail");
            });
        }
    </script>
</asp:Content>

