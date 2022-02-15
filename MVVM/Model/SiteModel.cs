using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Account_Manager.MVVM.Model
{
    public class SiteModel : ModelBase
    {
        public string? Name { get; set; }
        public string? Link { get; set; }

        public override bool Equals(ModelBase Model)
        {
            try
            {
                if (Model == null)
                    return false;
                if (Name == null || Link == null)
                    return false;

                SiteModel? siteModel = Model as SiteModel;

                if (siteModel == null)
                    return false;
                if (this.Name != siteModel.Name || this.Link != siteModel.Link)
                    return false;
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}
