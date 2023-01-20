using AccountManager.Command;
using AccountManager.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using static AccountManager.Consts;

namespace AccountManager.ViewModel
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
                if (EnterPassword != null && _ServiceCollection.GetCryptoService().CheckAuthentication(EnterPassword))
                {
                    _ServiceCollection.GetNavService().Navigate(new HomeViewModel(_ServiceCollection));
                    _ServiceCollection.GetCryptoService().SetAccessKey(EnterPassword);
                }
                else
                    MessageBox.Show("Authentication Failed", "Unauthorized");
            });
        }
    }
}
