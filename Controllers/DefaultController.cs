using AspNetWebFormsTeste.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Results;

namespace AspNetWebFormsTeste.Controllers
{
    public class DefaultController : ApiController
    {
        [HttpGet]
        public IHttpActionResult GetAddress(string cep)
        {
            WebRequest request = WebRequest.Create($"https://viacep.com.br/ws/{cep}/json/");
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            StreamReader reader = new StreamReader(response.GetResponseStream());
            AddressModel result = JsonConvert.DeserializeObject<AddressModel>(reader.ReadToEnd());

            return Ok(new { user = new { name = "Guilherme", endereco = result } });
        }
    }
}
