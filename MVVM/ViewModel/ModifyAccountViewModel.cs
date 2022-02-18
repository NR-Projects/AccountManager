using Account_Manager.Commands;
using Account_Manager.MVVM.Model;
using Account_Manager.Services;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using System.Xml;
using static Account_Manager.Consts;

namespace Account_Manager.MVVM.ViewModel
{
    public partial class ModifyAccountViewModel : ViewModelBase
    {
        public override string ViewName => "Modify Account";

        public ModifyAccountViewModel(ServiceCollection serviceCollection) : base(serviceCollection)
        {
        }

        protected override void InitializeButtons()
        {
            base.InitializeButtons();

            InitializeBaseButtons();
            InitializeAddButtons();
            InitializeDeleteButtons();
            InitializeUpdateButtons();
        }

        protected override void InitializeProperties()
        {
            base.InitializeProperties();

            InitializeBaseProperties();
            InitializeAddProperties();
            InitializeDeleteProperties();
            InitializeUpdateProperties();
        }
    }

    public partial class ModifyAccountViewModel : ViewModelBase
    {
        public ICommand? NavigateBackAccounts { get; set; }

        public ObservableCollection<string>? LabelCollection { get => _LabelCollection; set => SetProperty(ref _LabelCollection, value); }
        public ObservableCollection<string>? SiteCollection { get => _SiteCollection; set => SetProperty(ref _SiteCollection, value); }

        private ObservableCollection<string>? _LabelCollection;
        private ObservableCollection<string>? _SiteCollection;

        private List<AccountModel>? _AccountList;
        private List<SiteModel>? _SiteList;

        private void InitializeBaseButtons()
        {
            NavigateBackAccounts = new ExecuteOnlyCommand((_) => {
                _ServiceCollection.GetNavService().Navigate(new ShowAccountViewModel(_ServiceCollection));
            });
        }

        private void InitializeBaseProperties()
        {
            _AccountList = _ServiceCollection.GetDataService().Read_Data<AccountModel>(DataType.ACCOUNT, DataService.DataSource.Local);
            _SiteList = _ServiceCollection.GetDataService().Read_Data<SiteModel>(DataType.SITE, DataService.DataSource.Local);

            LabelCollection = new ObservableCollection<string>();
            SiteCollection = new ObservableCollection<string>();

            foreach (AccountModel Account in _AccountList)
            {
                if (Account != null && Account.Label != null)
                {
                    LabelCollection.Add(Account.Label);
                }
            }

            foreach (SiteModel Site in _SiteList)
            {
                if (Site != null && Site.Label != null)
                {
                    SiteCollection.Add(Site.Label);
                }
            }
        }
    }

    public partial class ModifyAccountViewModel : ViewModelBase
    {
        public string? AddAccountLabel { get; set; }
        public string? AddAccountSite { get; set; }
        public string? AddAccountUsername { get; set; }
        public string? AddAccountPassword { get; set; }
        public ICommand? AddAccount { get; set; }

        private void InitializeAddButtons()
        {
            AddAccount = new ExecuteOnlyCommand((_) => {

                string ErrorList = "";

                if (String.IsNullOrEmpty(AddAccountLabel))
                    ErrorList += "Account Label is Empty \n";
                if (String.IsNullOrEmpty(AddAccountSite))
                    ErrorList += "No Account Site Selected \n";
                if (String.IsNullOrEmpty(AddAccountUsername))
                    ErrorList += "Account Username is Empty \n";
                if (String.IsNullOrEmpty(AddAccountPassword))
                    ErrorList += "Account Password is Empty \n";

                MessageBox.Show(ErrorList, "Add Account");

                if (ErrorList.Equals(""))
                    return;

                AccountModel accountModel = new AccountModel()
                {
                    Label = AddAccountLabel,
                    Site = AddAccountSite,
                    Username = AddAccountUsername,
                    Password = AddAccountPassword
                };

                MessageBox.Show("Account Info Added", "Account");

                InitializeBaseProperties();

                AddAccountLabel = "";
                AddAccountSite = "";
                AddAccountUsername = "";
                AddAccountPassword = "";
            });
        }

        private void InitializeAddProperties()
        {
            //
        }
    }

    public partial class ModifyAccountViewModel : ViewModelBase
    {
        public string? DeleteAccountLabel { get => _DeleteAccountLabelSelected; set { SetProperty(ref _DeleteAccountLabelSelected, value); OnDeleteLabelSelected(); } }
        public string? DeleteAccountSite { get => _DeleteAccountSiteSelected; set { SetProperty(ref _DeleteAccountSiteSelected, value); OnDeleteSiteChanged(); } }

        public string? DeleteAccountDisplay { get => _DeleteAccountDisplay; set => SetProperty(ref _DeleteAccountDisplay, value); }
        public ICommand? DeleteAccount { get; set; }

        private string? _DeleteAccountSiteSelected;
        private string? _DeleteAccountLabelSelected;
        private string? _DeleteAccountDisplay;

        private void InitializeDeleteButtons()
        {
            DeleteAccount = new ExecuteOnlyCommand((_) => {

                string ErrorList = "";

                if (String.IsNullOrEmpty(DeleteAccountLabel))
                    ErrorList += "No Account Label Selected \n";
                if (String.IsNullOrEmpty(DeleteAccountSite))
                    ErrorList += "No Account Site Selected \n";

                MessageBox.Show(ErrorList, "Delete Account");

                if (ErrorList.Equals(""))
                    return;

                if (_AccountList == null)
                    return;

                AccountModel _DeleteAccountData = new AccountModel
                {
                    Site = DeleteAccountSite,
                    Label = DeleteAccountLabel
                };

                foreach (AccountModel Account in _AccountList)
                {
                    if (Account.Equals(_DeleteAccountData))
                    {
                        _ServiceCollection.GetDataService().Delete_Data<AccountModel>(DataType.ACCOUNT, _DeleteAccountData, DataService.DataSource.Local);
                        break;
                    }
                }

                MessageBox.Show("Account Info Deleted", "Account");

                InitializeBaseProperties();

                DeleteAccountLabel = "";
                DeleteAccountSite = "";
            });
        }

        private void InitializeDeleteProperties()
        {
            //
        }


        private void OnDeleteLabelSelected()
        {
            if (_AccountList == null)
                return;

            foreach (AccountModel Account in _AccountList)
            {
                if (Account.Label != null && Account.Site != null && Account.Site.Equals(DeleteAccountSite) && Account.Label.Equals(DeleteAccountLabel))
                {
                    DeleteAccountDisplay = JsonSerializer.Serialize(Account);
                    return;
                }
            }

            DeleteAccountDisplay = "<No Account Selected>";
        }

        private void OnDeleteSiteChanged()
        {
            if (LabelCollection == null)
                return;

            LabelCollection.Clear();

            if (_AccountList == null)
                return;

            foreach (AccountModel Account in _AccountList)
            {
                if (Account.Label != null && Account.Site != null && Account.Site.Equals(DeleteAccountSite))
                    LabelCollection.Add(Account.Label);
            }

            DeleteAccountLabel = "";
        }
    }

    public partial class ModifyAccountViewModel : ViewModelBase
    {
        public string? UpdateShowAccountSite { get => _UpdateAccountSiteSelected; set { SetProperty(ref _UpdateAccountSiteSelected, value); OnUpdateSiteSelected(); } }
        public string? UpdateShowAccountLabel { get => _UpdateAccountLabelSelected; set { SetProperty(ref _UpdateAccountLabelSelected, value); OnUpdateLabelSelected(); } }


        public string? UpdateAccountLabel { get => _UpdateAccountLabel; set => SetProperty(ref _UpdateAccountLabel, value); }
        public string? UpdateAccountSite { get => _UpdateAccountSite; set => SetProperty(ref _UpdateAccountSite, value); }
        public string? UpdateAccountUsername { get => _UpdateAccountUsername; set => SetProperty(ref _UpdateAccountUsername, value); }
        public string? UpdateAccountPassword { get => _UpdateAccountPassword; set => SetProperty(ref _UpdateAccountPassword, value); }
        public ICommand? UpdateAccount { get; set; }

        private string? _UpdateAccountSiteSelected;
        private string? _UpdateAccountLabelSelected;

        private string? _UpdateAccountLabel;
        private string? _UpdateAccountSite;
        private string? _UpdateAccountUsername;
        private string? _UpdateAccountPassword;

        private void InitializeUpdateButtons()
        {
            UpdateAccount = new ExecuteOnlyCommand((_) => {

                string ErrorList = "";

                if (String.IsNullOrEmpty(UpdateShowAccountSite))
                    ErrorList += "No Account Site Selected \n";
                if (String.IsNullOrEmpty(UpdateShowAccountLabel))
                    ErrorList += "No Account Label Selected \n";
                if (String.IsNullOrEmpty(UpdateAccountLabel))
                    ErrorList += "Account Label is Empty \n";
                if (String.IsNullOrEmpty(UpdateAccountSite))
                    ErrorList += "No Account Site Selected \n";
                if (String.IsNullOrEmpty(UpdateAccountUsername))
                    ErrorList += "Account Username is Empty \n";
                if (String.IsNullOrEmpty(UpdateAccountPassword))
                    ErrorList += "Account Password is Empty \n";

                MessageBox.Show(ErrorList, "Update Account");

                if (ErrorList.Equals(""))
                    return;

                AccountModel _UpdateAccountData = new AccountModel
                {
                    Site = UpdateShowAccountSite,
                    Label = UpdateShowAccountLabel
                };

                if (_AccountList == null)
                    return;

                foreach (AccountModel Account in _AccountList)
                {
                    if (Account.Equals(_UpdateAccountData))
                    {
                        AccountModel UpdatedAccount = new AccountModel
                        {
                            Label = UpdateAccountLabel,
                            Site = UpdateAccountSite,
                            Username = UpdateAccountUsername,
                            Password = UpdateAccountPassword
                        };

                        _ServiceCollection.GetDataService().Update_Data<AccountModel>(DataType.ACCOUNT, _UpdateAccountData, UpdatedAccount, DataService.DataSource.Local);

                        break;
                    }
                }

                MessageBox.Show("Account Info Updated", "Account");

                InitializeBaseProperties();

                UpdateShowAccountSite = "";
                UpdateShowAccountLabel = "";

                UpdateAccountSite = "";
                UpdateAccountLabel = "";
                UpdateAccountUsername = "";
                UpdateAccountPassword = "";
            });
        }

        private void InitializeUpdateProperties()
        {
            //
        }



        private void OnUpdateSiteSelected()
        {
            AccountModel _UpdateAccountData = new AccountModel
            {
                Site = UpdateShowAccountSite,
                Label = UpdateShowAccountLabel
            };

            if (_AccountList == null)
                return;

            foreach (AccountModel Account in _AccountList)
            {
                if (Account.Equals(_UpdateAccountData))
                {
                    UpdateAccountLabel = Account.Label;
                    UpdateAccountSite = Account.Site;
                    UpdateAccountUsername = Account.Username;
                    UpdateAccountPassword = Account.Password;

                    break;
                }
            }

            UpdateAccountLabel = "";
            UpdateAccountSite = "";
            UpdateAccountUsername = "";
            UpdateAccountPassword = "";
        }

        private void OnUpdateLabelSelected()
        {
            // Update Labels
            if (LabelCollection == null)
                return;

            LabelCollection.Clear();

            foreach (AccountModel Account in _AccountList)
            {
                if (Account != null && Account.Site != null && Account.Label != null && Account.Site.Equals(UpdateShowAccountSite))
                    LabelCollection.Add(Account.Label);
            }

            UpdateShowAccountLabel = "";
        }
    }
}
