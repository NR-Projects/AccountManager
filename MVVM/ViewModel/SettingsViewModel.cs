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
    public class SettingsViewModel : ViewModelBase
    {
        public override string ViewName => "Settings";

        public ICommand? NavigateBackHome { get; set; }
        public string? ChangedPasswordStr { get; set; }
        public ICommand? UpdatePassword { get; set; }
        public string? ExportDataTypeStr { get; set; }
        public ICommand? ExportData { get; set; }

        public SettingsViewModel(ServiceCollection serviceCollection) : base(serviceCollection)
        {
        }

        protected override void InitializeButtons()
        {
            base.InitializeButtons();

            NavigateBackHome = new ExecuteOnlyCommand((_) => {
                _ServiceCollection.GetNavService().Navigate(new HomeViewModel(_ServiceCollection));
            });

            UpdatePassword = new ExecuteOnlyCommand((_) => {
                // TODO
                throw new NotImplementedException();
            });

            ExportData = new ExecuteOnlyCommand((_) => {
                // TODO
                throw new NotImplementedException();
            });
        }
    }
}
