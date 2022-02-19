using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Account_Manager.MVVM.Model
{
    public class SiteModel : ModelBase
    {
        public string? Label { get; set; }
        public string? Link { get; set; }
        public string? Description { get; set; }

        public override bool Equals(ModelBase Model)
        {
            try
            {
                if (Model == null)
                    return false;
                if (Label == null || Link == null)
                    return false;

                SiteModel? siteModel = Model as SiteModel;

                if (siteModel == null)
                    return false;
                if (this.Label != siteModel.Label || this.Link != siteModel.Link)
                    return false;
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public override string ToString()
        {
            return $"{Label} | {Link} | {Description}";
        }
    }
}
