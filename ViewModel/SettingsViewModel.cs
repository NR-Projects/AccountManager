using AccountManager.Command;
using AccountManager.Model;
using AccountManager.Service;
using Microsoft.Win32;
using System;
using System.IO;
using System.Text;
using System.Text.Json;
using System.Windows;
using System.Windows.Controls;
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
        public ComboBoxItem? ExportDataTypeCB { get; set; }
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

                string? ExportDataTypeStr = null;

                if (ExportDataTypeCB == null)
                {
                    MessageBox.Show("No DataType Selected");
                    return;
                }

                ExportDataTypeStr = ExportDataTypeCB.Content.ToString();

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

                string res_str = "";
                bool res = ExportFileData(FinalJson, ExportDataTypeStr);
                if (res) res_str += "Data Saved";
                else res_str += "Something Unexpected Occurred";
                MessageBox.Show(res_str);
            });
        }

        private bool ExportFileData(string Data, string Title)
        {
            SaveFileDialog saveFileDialog1 = new SaveFileDialog();
            saveFileDialog1.Filter = "All files|*.*|Text File|*.txt|JSON File|*.json";
            saveFileDialog1.DefaultExt = "txt";
            saveFileDialog1.Title = "Save " + Title;
            saveFileDialog1.ShowDialog();

            // If the file name is not an empty string open it for saving.
            if (saveFileDialog1.FileName != "")
            {
                FileStream fs = (FileStream)saveFileDialog1.OpenFile();
                byte[] info = new UTF8Encoding(true).GetBytes(Data);
                fs.Write(info, 0, info.Length);
                fs.Close();
                return true;
            }

            return false;
        }
    }
}
