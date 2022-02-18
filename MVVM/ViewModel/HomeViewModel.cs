using Account_Manager.Commands;
using Account_Manager.Services;
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

        public ICommand? LogOut { get; set; }
        public ICommand? Settings { get; set; }
        public ICommand? NavigateAccounts { get; set; }
        public ICommand? NavigateSites { get; set; }

        public HomeViewModel(ServiceCollection serviceCollection) : base(serviceCollection)
        {
        }

        protected override void InitializeButtons()
        {
            base.InitializeButtons();

            LogOut = new ExecuteOnlyCommand((_) => {
                _ServiceCollection.GetNavService().Navigate(new AuthViewModel(_ServiceCollection));
            });

            Settings = new ExecuteOnlyCommand((_) =>
            {
                _ServiceCollection.GetNavService().Navigate(new SettingsViewModel(_ServiceCollection));
            });

            NavigateAccounts = new ExecuteOnlyCommand((_) => {
                _ServiceCollection.GetNavService().Navigate(new ShowAccountViewModel(_ServiceCollection));
            });

            NavigateSites = new ExecuteOnlyCommand((_) => {
                _ServiceCollection.GetNavService().Navigate(new ShowSiteViewModel(_ServiceCollection));
            });
        }
    }
}
