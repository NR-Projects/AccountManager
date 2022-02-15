using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Account_Manager.MVVM.Model
{
    public class AccountModel : ModelBase
    {
        public SiteModel? Site { get; set; }
        public string? Name { get; set; }
        public string? Alias { get; set; }

        public override bool Equals(ModelBase Model)
        {
            try
            {
                if (Model == null)
                    return false;
                if (Name == null || Alias == null)
                    return false;

                AccountModel? accountModel = Model as AccountModel;

                if (accountModel == null)
                    return false;
                if (this.Name != accountModel.Name || this.Alias != accountModel.Alias)
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
