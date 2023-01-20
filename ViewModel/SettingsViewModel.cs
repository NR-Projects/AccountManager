using AccountManager.Command;
using AccountManager.Model;
using AccountManager.Service;
using Microsoft.Win32;
using System.IO;
using System.Text.Json;
using System.Windows;
using System.Windows.Input;
using static AccountManager.Consts;

namespace AccountManager.ViewModel
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
                if (ChangedPasswordStr == null || ChangedPasswordStr.Trim() == "")
                {
                    MessageBox.Show("No Password Input");
                    return;
                }

                string Salt = _ServiceCollection.GetCryptoService().GenerateSalt();

                _ServiceCollection.GetDataService().UpdateEncryption(Salt, ChangedPasswordStr);

                MessageBox.Show("Password Updated, Please remember your new password", "Settings Update");

                _ServiceCollection.GetNavService().Navigate(new AuthViewModel(_ServiceCollection));
            });

            ExportData = new ExecuteOnlyCommand((_) => {
                /*
                if (ExportDataTypeStr == null || ExportDataTypeStr.Trim() == "")
                {
                    MessageBox.Show("No DataType Selected");
                    return;
                }

                SaveFileDialog saveFileDialog = new SaveFileDialog();

                if (saveFileDialog.ShowDialog() != true)
                    return;

                string FinalJson = "";
                switch (ExportDataTypeStr)
                {
                    case "All":
                        {
                        string AccountsJson = JsonSerializer.Serialize(
                            _ServiceCollection.GetDataService().Read_Data<AccountModel>(DataType.ACCOUNT, DataService.DataSource.Local)
                            );
                        string SitesJson = JsonSerializer.Serialize(
                            _ServiceCollection.GetDataService().Read_Data<SiteModel>(DataType.SITE, DataService.DataSource.Local)
                            );

                        FinalJson = $"{AccountsJson} \n\n\n\n {SitesJson}";
                        }
                        break;
                    case "Accounts":
                        FinalJson = JsonSerializer.Serialize(
                            _ServiceCollection.GetDataService().Read_Data<AccountModel>(DataType.ACCOUNT, DataService.DataSource.Local)
                            );
                        break;
                    case "Sites":
                        FinalJson = JsonSerializer.Serialize(
                            _ServiceCollection.GetDataService().Read_Data<SiteModel>(DataType.SITE, DataService.DataSource.Local)
                            );
                        break;
                }

                if (saveFileDialog.FileName.Trim() != "" && FinalJson != "")
                    File.WriteAllText(saveFileDialog.FileName, FinalJson);

                MessageBox.Show("Data Saved");
                */
            });
        }
    }
}
