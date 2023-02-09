using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AspNetWebFormsTeste.Controllers
{
    public class PageController : Controller
    {
        // GET: Page
        public ActionResult _PartialPage()
        {
            return PartialView();
        }
    }
}