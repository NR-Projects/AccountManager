using AccountManager.Command;
using AccountManager.Model;
using AccountManager.Service;
using System.Collections.ObjectModel;
using System.Windows.Input;
using static AccountManager.Consts;

namespace AccountManager.ViewModel
{
    public class ShowSiteViewModel : ViewModelBase
    {
        public override string ViewName => "Show Sites";

        public ICommand? NavigateBackHome { get; set; }
        public ICommand? NavigateShowData { get; set; }
        public ICommand? NavigateModifySite { get; set; }
        public ICommand? ReloadSites { get; set; }

        public ObservableCollection<SiteModel>? SiteCollection { get => _SiteCollection; set => SetProperty(ref _SiteCollection, value); }
        private ObservableCollection<SiteModel>? _SiteCollection;

        public ShowSiteViewModel(ServiceCollection serviceCollection) : base(serviceCollection)
        {
        }

        protected override void InitializeButtons()
        {
            base.InitializeButtons();

            NavigateBackHome = new ExecuteOnlyCommand((_) => {
                _ServiceCollection.GetNavService().Navigate(new HomeViewModel(_ServiceCollection));
            });

            NavigateModifySite = new ExecuteOnlyCommand((_) => {
                _ServiceCollection.GetNavService().Navigate(new ModifySiteViewModel(_ServiceCollection));
            });

            ReloadSites = new ExecuteOnlyCommand((_) => {
                InitializeProperties();
            });
        }

        protected override void InitializeProperties()
        {
            base.InitializeProperties();

            SiteCollection = new ObservableCollection<SiteModel>(_ServiceCollection.GetDataService().Read_Data<SiteModel>(DataType.SITE, DataService.DataSource.Local));
        }
    }
}
