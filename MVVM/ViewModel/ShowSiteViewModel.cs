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
using static Account_Manager.Consts;

namespace Account_Manager.MVVM.ViewModel
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
