using Account_Manager.Commands;
using Account_Manager.MVVM.Model;
using Account_Manager.Services;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using static Account_Manager.Consts;

namespace Account_Manager.MVVM.ViewModel
{
    public partial class ModifySiteViewModel : ViewModelBase
    {
        public override string ViewName => "Modify Site";

        public ModifySiteViewModel(ServiceCollection serviceCollection) : base(serviceCollection)
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

    public partial class ModifySiteViewModel : ViewModelBase
    {
        public ICommand? NavigateBackSites { get; set; }

        public ObservableCollection<string>? LabelCollection { get => _LabelCollection; set => SetProperty(ref _LabelCollection, value); }
        private ObservableCollection<string>? _LabelCollection;

        private List<SiteModel>? _SiteList;

        private void InitializeBaseButtons()
        {
            NavigateBackSites = new ExecuteOnlyCommand((_) => {
                _ServiceCollection.GetNavService().Navigate(new ShowSiteViewModel(_ServiceCollection));
            });
        }

        private void InitializeBaseProperties()
        {
            _SiteList = _ServiceCollection.GetDataService().Read_Data<SiteModel>(DataType.SITE, DataService.DataSource.Local);
            LabelCollection = new ObservableCollection<string>();

            foreach (SiteModel Site in _SiteList)
            {
                if (Site != null && Site.Label != null)
                    LabelCollection.Add(Site.Label);
            }
        }
    }

    public partial class ModifySiteViewModel : ViewModelBase
    {
        public string? AddSiteLabel { get; set; }
        public string? AddSiteLink { get; set; }
        public string? AddSiteDescription { get; set; }
        public ICommand? AddSite { get; set; }

        private void InitializeAddButtons()
        {
            AddSite = new ExecuteOnlyCommand((_) => {

                string ErrorList = "";

                if (String.IsNullOrEmpty(AddSiteLabel))
                    ErrorList += "Site Label is Empty \n";
                if (String.IsNullOrEmpty(AddSiteLink))
                    ErrorList += "Site Link is Empty \n";
                if (String.IsNullOrEmpty(AddSiteDescription))
                    ErrorList += "Site Description is Empty \n";

                if (!ErrorList.Equals(""))
                {
                    MessageBox.Show(ErrorList, "Add Site");
                    return;
                }

                SiteModel siteModel = new SiteModel()
                {
                    Label = AddSiteLabel,
                    Link = AddSiteLink,
                    Description = AddSiteDescription
                };

                _ServiceCollection.GetDataService().Create_Data<SiteModel>(DataType.SITE, siteModel, DataService.DataSource.Local);

                MessageBox.Show("Site Info Added", "Site");

                InitializeBaseProperties();

                AddSiteLabel = "";
                AddSiteLink = "";
                AddSiteDescription = "";
            });
        }

        private void InitializeAddProperties()
        {
            //
        }
    }

    public partial class ModifySiteViewModel : ViewModelBase
    {
        public string? DeleteSiteLabel { get => _DeleteSiteLabelSelected; set { SetProperty(ref _DeleteSiteLabelSelected, value); OnDeleteLabelSelected(); } }

        public string? DeleteSiteDisplay { get => _DeleteSiteDisplay; set => SetProperty(ref _DeleteSiteDisplay, value); }
        public ICommand? DeleteSite { get; set; }

        private string? _DeleteSiteLabelSelected;
        private string? _DeleteSiteDisplay;

        private void InitializeDeleteButtons()
        {
            DeleteSite = new ExecuteOnlyCommand((_) => {

                string ErrorList = "";

                if (String.IsNullOrEmpty(DeleteSiteLabel))
                    ErrorList += "No Site Label Selected \n";

                if (!ErrorList.Equals(""))
                {
                    MessageBox.Show(ErrorList, "Delete Site");
                    return;
                }

                if (_SiteList == null)
                    return;

                foreach (SiteModel Site in _SiteList)
                {
                    if (Site != null && Site.Label != null && Site.Label.Equals(DeleteSiteLabel))
                    {
                        _ServiceCollection.GetDataService().Delete_Data<SiteModel>(DataType.SITE, Site, DataService.DataSource.Local);
                        break;
                    }
                }

                List<AccountModel> AccountList = _ServiceCollection.GetDataService().Read_Data<AccountModel>(DataType.ACCOUNT, DataService.DataSource.Local);

                foreach (AccountModel Account in AccountList)
                {
                    if (Account != null && Account.Site != null && Account.Site.Equals(DeleteSiteLabel))
                    {
                        _ServiceCollection.GetDataService().Delete_Data<AccountModel>(DataType.ACCOUNT, Account, DataService.DataSource.Local);
                    }
                }

                MessageBox.Show("Site Info Deleted", "Site");

                InitializeBaseProperties();

                DeleteSiteLabel = "";
            });
        }

        private void InitializeDeleteProperties()
        {
        }

        private void OnDeleteLabelSelected()
        {
            if (_SiteList == null)
                return;

            foreach (SiteModel Site in _SiteList)
            {
                if (Site != null && Site.Label != null && Site.Label.Equals(DeleteSiteLabel))
                {
                    DeleteSiteDisplay = JsonSerializer.Serialize(Site);
                    return;
                }
            }

            DeleteSiteDisplay = "<No Site Selected>";
        }
    }

    public partial class ModifySiteViewModel : ViewModelBase
    {
        public string UpdateShowSiteLabel { get => _UpdateSiteLabelSelected; set { SetProperty(ref _UpdateSiteLabelSelected, value); OnUpdateLabelSelected(); } }

        public string? UpdateSiteLabel { get => _UpdateSiteLabel; set => SetProperty(ref _UpdateSiteLabel, value); }
        public string? UpdateSiteLink { get => _UpdateSiteLink; set => SetProperty(ref _UpdateSiteLink, value); }
        public string? UpdateSiteDescription { get => _UpdateSiteDescription; set => SetProperty(ref _UpdateSiteDescription, value); }
        public ICommand? UpdateSite { get; set; }

        private string _UpdateSiteLabelSelected = "";

        private string? _UpdateSiteLabel;
        private string? _UpdateSiteLink;
        private string? _UpdateSiteDescription;

        private void InitializeUpdateButtons()
        {
            UpdateSite = new ExecuteOnlyCommand((_) => {

                string ErrorList = "";

                if (String.IsNullOrEmpty(UpdateShowSiteLabel))
                    ErrorList += "No Existing Site Label is Selected \n";
                if (String.IsNullOrEmpty(UpdateSiteLabel))
                    ErrorList += "Site Label is Empty \n";
                if (String.IsNullOrEmpty(UpdateSiteLink))
                    ErrorList += "Site Link is Empty \n";
                if (String.IsNullOrEmpty(UpdateSiteDescription))
                    ErrorList += "Site Description is Empty \n";

                if (!ErrorList.Equals(""))
                {
                    MessageBox.Show(ErrorList, "Update Site");
                    return;
                }

                if (_SiteList == null)
                    return;

                foreach (SiteModel Site in _SiteList)
                {
                    if (Site != null && Site.Label != null && Site.Label.Equals(UpdateShowSiteLabel))
                    {
                        SiteModel UpdatedSite = new SiteModel
                        {
                            Label = UpdateSiteLabel,
                            Link = UpdateSiteLink,
                            Description = UpdateSiteDescription
                        };

                        _ServiceCollection.GetDataService().Update_Data<SiteModel>(DataType.SITE, Site, UpdatedSite, DataService.DataSource.Local);

                        List<AccountModel> AccountList = _ServiceCollection.GetDataService().Read_Data<AccountModel>(DataType.ACCOUNT, DataService.DataSource.Local);

                        foreach (AccountModel Account in AccountList)
                        {
                            if (Account != null && Account.Site != null && Account.Site.Equals(UpdateShowSiteLabel))
                            {
                                AccountModel UpdatedAccount = new AccountModel
                                {
                                    Label = Account.Label,
                                    Site = UpdateSiteLabel,
                                    Username = Account.Username,
                                    Password = Account.Password
                                };

                                _ServiceCollection.GetDataService().Update_Data<AccountModel>(DataType.ACCOUNT, Account, UpdatedAccount, DataService.DataSource.Local);
                            }
                        }

                        break;
                    }
                }

                MessageBox.Show("Site Info Updated", "Site");

                InitializeBaseProperties();

                UpdateShowSiteLabel = "";
                UpdateSiteLabel = "";
                UpdateSiteLink = "";
                UpdateSiteDescription = "";
            });
        }

        private void InitializeUpdateProperties()
        {
            //
        }

        private void OnUpdateLabelSelected()
        {
            if (_SiteList == null)
                return;

            foreach (SiteModel Site in _SiteList)
            {
                if (Site != null && Site.Label != null && Site.Label.Equals(UpdateShowSiteLabel))
                {
                    UpdateSiteLabel = Site.Label;
                    UpdateSiteLink = Site.Link;
                    UpdateSiteDescription = Site.Description;

                    return;
                }
            }

            UpdateSiteLabel = "";
            UpdateSiteLink = "";
            UpdateSiteDescription = "";
        }
    }
}
