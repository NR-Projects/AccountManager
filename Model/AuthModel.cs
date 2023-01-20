using System;

namespace AccountManager.Model
{
    public class AuthModel : ModelBase
    {
        public string? UserGenSalt { get; set; }
        public string? HashedPass { get; set; }

        public override bool Equals(ModelBase Model)
        {
            try
            {
                if (Model == null)
                    return false;
                if (UserGenSalt == null || HashedPass == null)
                    return false;

                AuthModel? authModel = Model as AuthModel;

                if (authModel == null)
                    return false;
                if (this.UserGenSalt != authModel.UserGenSalt || this.HashedPass != authModel.HashedPass)
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
            return $"{UserGenSalt} | {HashedPass}";
        }
    }
}
