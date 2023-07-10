using AccountManager.Command;
using AccountManager.Model;
using AccountManager.Service;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Windows;
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


        public ICommand ShowPasswdAction { get; set; }
        public ICommand CopyPasswdAction { get; set; }



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

            ShowPasswdAction = new ExecuteOnlyCommand((row_info) => {
                AccountModel account_row_info = (AccountModel)row_info;

                if (account_row_info != null) {
                    MessageBox.Show($"Password is: {account_row_info.Password}", $"Show Password for {account_row_info.Username}");
                }
            });

            CopyPasswdAction = new ExecuteOnlyCommand((row_info) => {
                AccountModel account_row_info = (AccountModel)row_info;

                if (account_row_info != null)
                {
                    Clipboard.SetData(DataFormats.Text, account_row_info.Password);
                    MessageBox.Show("Password successfully copied to clipboard", $"{account_row_info.Username}'s Password");
                }
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
