using AccountManager.Command;
using AccountManager.Model;
using AccountManager.Service;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Windows.Input;
using static AccountManager.Consts;

namespace AccountManager.ViewModel
{
    public class ShowAccountViewModel : ViewModelBase
    {
        public override string ViewName => "Show Accounts";

        public ICommand? NavigateBackHome { get; set; }
        public ICommand? NavigateModifyAccount { get; set; }
        public ICommand? ReloadAccounts { get; set; }

        public ObservableCollection<AccountModel>? AccountCollection { get => _FilteredAccountCollection; set => SetProperty(ref _FilteredAccountCollection, value); }
        public ObservableCollection<string>? SiteCollection { get => _SiteCollection; set => SetProperty(ref _SiteCollection, value); }
        public string? CurrentSiteSelected
        {
            get
            {
                if (_CurrentSiteSelected == null)
                    _CurrentSiteSelected = "All";
                return _CurrentSiteSelected;
            }

            set
            {
                SetProperty(ref _CurrentSiteSelected, value);
                OnCurrentSiteChanged();
            }
        }

        private ObservableCollection<AccountModel>? _UnfilteredAccountCollection;
        private ObservableCollection<AccountModel>? _FilteredAccountCollection;
        private ObservableCollection<string>? _SiteCollection;
        private string? _CurrentSiteSelected;


        public ShowAccountViewModel(ServiceCollection serviceCollection) : base(serviceCollection)
        {
        }

        protected override void InitializeButtons()
        {
            base.InitializeButtons();

            NavigateBackHome = new ExecuteOnlyCommand((_) => {
                _ServiceCollection.GetNavService().Navigate(new HomeViewModel(_ServiceCollection));
            });

            NavigateModifyAccount = new ExecuteOnlyCommand((_) => { 
                _ServiceCollection.GetNavService().Navigate(new ModifyAccountViewModel(_ServiceCollection));
            });
        }

        protected override void InitializeProperties()
        {
            base.InitializeProperties();

            // Add Site Collection
            _SiteCollection = new ObservableCollection<string>();
            _SiteCollection.Add("All");

            List<SiteModel> SiteList = _ServiceCollection.GetDataService().Read_Data<SiteModel>(DataType.SITE, DataService.DataSource.Local);
            foreach (SiteModel site in SiteList)
            {
                if (site != null && site.Label != null)
                {
                    _SiteCollection.Add(site.Label);
                }
            }

            // Add Account Collection
            _UnfilteredAccountCollection = new ObservableCollection<AccountModel>(_ServiceCollection.GetDataService().Read_Data<AccountModel>(DataType.ACCOUNT, DataService.DataSource.Local));
            _FilteredAccountCollection = new ObservableCollection<AccountModel>(_UnfilteredAccountCollection);
        }

        private void OnCurrentSiteChanged()
        {
            if (CurrentSiteSelected != null && AccountCollection != null && _UnfilteredAccountCollection != null)
            {
                if (CurrentSiteSelected.Equals("All"))
                {
                    AccountCollection = new ObservableCollection<AccountModel>(_UnfilteredAccountCollection);
                }
                else
                {
                    AccountCollection.Clear();

                    foreach (AccountModel Account in _UnfilteredAccountCollection)
                    {
                        if (Account.Site != null && Account.Site.Contains(CurrentSiteSelected))
                            AccountCollection.Add(Account);
                    }
                }
            }
        }
    }
}
