using Account_Manager.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace Account_Manager.MVVM.ViewModel
{
    public class AuthViewModel : ViewModelBase
    {
        public override string ViewName => "App Authentication";

        public ICommand NavigateHome { get; set; }

        public string EnterPassword { get; set; }

        public AuthViewModel(ServiceCollection serviceCollection)
        {
            //
        }
    }
}
