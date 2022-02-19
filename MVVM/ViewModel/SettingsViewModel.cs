using Account_Manager.Commands;
using Account_Manager.MVVM.Model;
using Account_Manager.Services;
using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using static Account_Manager.Consts;

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
                if (ChangedPasswordStr == null || ChangedPasswordStr.Trim() == "")
                {
                    MessageBox.Show("No Password Input");
                    return;
                }

                _ServiceCollection.GetDataService().UpdateEncryption(
                    _ServiceCollection.GetCryptoService().GenerateKey(),
                    ChangedPasswordStr
                    );

                MessageBox.Show("Password Updated, Please remember your new password");

                _ServiceCollection.GetNavService().Navigate(new AuthViewModel(_ServiceCollection));
            });

            ExportData = new ExecuteOnlyCommand((_) => {
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

            });
        }
    }
}
