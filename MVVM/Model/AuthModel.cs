using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Account_Manager.MVVM.Model
{
    public class AuthModel : ModelBase
    {
        public string? UserKey { get; set; }
        public string? HashedPassword { get; set; }

        public override bool Equals(ModelBase Model)
        {
            try
            {
                if (Model == null)
                    return false;
                if (UserKey == null || HashedPassword == null)
                    return false;

                AuthModel? authModel = Model as AuthModel;

                if (authModel == null)
                    return false;
                if (this.UserKey != authModel.UserKey || this.HashedPassword != authModel.HashedPassword)
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
            return $"{UserKey} | {HashedPassword}";
        }
    }
}
