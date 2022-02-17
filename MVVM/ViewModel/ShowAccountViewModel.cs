using Account_Manager.Commands;
using Account_Manager.MVVM.Model;
using Account_Manager.Services;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace Account_Manager.MVVM.ViewModel
{
    public class ShowAccountViewModel : ViewModelBase
    {
        public override string ViewName => "Show Accounts";

        public ICommand? NavigateBackHome { get; set; }
        public ICommand? NavigateModifyAccount { get; set; }
        public ICommand? ReloadAccounts { get; set; }

        public ObservableCollection<AccountModel>? AccountCollection { get; set; }
        public ObservableCollection<string>? SiteCollection { get; set; }

        public string? CurrentSiteSelected { get; set; }

        public ShowAccountViewModel(ServiceCollection serviceCollection) : base(serviceCollection)
        {
        }

        public override void OnEnterView()
        {
            base.OnEnterView();
        }

        protected override void InitializeButtons()
        {
            base.InitializeButtons();

            NavigateBackHome = new ExecuteOnlyCommand((_) => {
                _ServiceCollection.GetNavService().Navigate(new HomeViewModel(_ServiceCollection));
            });
        }

        protected override void InitializeProperties()
        {
            base.InitializeProperties();
        }
    }
}
