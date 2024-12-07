using System;

namespace AccountManager.Model
{
    public class AccountModel : ModelBase
    {
        public string? Site { get; set; }
        public string? Label { get; set; }
        public string? Username { get; set; }
        public string? Password { get; set; }

        public override bool Equals(ModelBase Model)
        {
            try
            {
                if (Model == null)
                    return false;
                if (Site == null || Label == null)
                    return false;

                AccountModel? accountModel = Model as AccountModel;

                if (accountModel == null)
                    return false;
                if (this.Site != accountModel.Site || this.Label != accountModel.Label)
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
            return $"{Site} | {Label} | {Username} | {Password}";
        }
    }
}
