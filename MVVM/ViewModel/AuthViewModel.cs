using Account_Manager.Commands;
using Account_Manager.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using static Account_Manager.Consts;

namespace Account_Manager.MVVM.ViewModel
{
    public class AuthViewModel : ViewModelBase
    {
        public override string ViewName => "Authentication";

        public ICommand? NavigateHome { get; set; }

        public string? EnterPassword { get; set; }

        public AuthViewModel(ServiceCollection serviceCollection) : base(serviceCollection)
        {
        }

        protected override void InitializeButtons()
        {
            base.InitializeButtons();

            NavigateHome = new ExecuteOnlyCommand((_) => {
                if (EnterPassword != null && _ServiceCollection.GetCryptoService().CheckValidPassword(EnterPassword))
                {
                    _ServiceCollection.GetNavService().Navigate(new HomeViewModel(_ServiceCollection));
                    _ServiceCollection.GetCryptoService().SetAppRuntimeKey(AppInfo.APPKEY, EnterPassword);
                }
                else
                    MessageBox.Show("Authentication Failed", "Unauthorized");
            });
        }
    }
}
