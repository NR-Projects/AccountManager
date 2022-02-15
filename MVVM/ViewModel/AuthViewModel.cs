using Account_Manager.Commands;
using Account_Manager.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;

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
            NavigateHome = new ExecuteOnlyCommand((_) => {
                if (EnterPassword == "12345")
                    _ServiceCollection.GetNavService().Navigate(new HomeViewModel(_ServiceCollection));
                else
                    MessageBox.Show("Authentication Failed", "Unauthorized");
            });
        }
    }
}
