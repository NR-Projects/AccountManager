using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace Account_Manager.MVVM.ViewModel
{
    public class HomeViewModel : ViewModelBase
    {
        public override string ViewName => "Home";

        public ICommand LogOut { get; set; }
        public ICommand Settings { get; set; }
        public ICommand NavigateAccounts { get; set; }
        public ICommand NavigateSites { get; set; }

        public HomeViewModel()
        {
        }
    }
}
