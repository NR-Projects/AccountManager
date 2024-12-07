using AccountManager.Command;
using AccountManager.Model;
using AccountManager.Service;
using Microsoft.Win32;
using System.Collections.Generic;
using System.IO;
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

        public ComboBoxItem? ImportDataTypeCB { get; set; }
        public ICommand? ImportData { get; set; }

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

            ImportData = new ExecuteOnlyCommand((_) => {

                string? ImportDataTypeStr = null;

                if (ImportDataTypeCB == null)
                {
                    MessageBox.Show("No DataType Selected");
                    return;
                }

                ImportDataTypeStr = ImportDataTypeCB.Content.ToString();

                string res_str = "";
                bool res = ImportFileData(ImportDataTypeStr!);
                if (res) res_str += "Data Pulled";
                else res_str += "Something Unexpected Occurred";
                MessageBox.Show(res_str);
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
                bool res = ExportFileData(FinalJson, ExportDataTypeStr!);
                if (res) res_str += "Data Saved";
                else res_str += "Something Unexpected Occurred";
                MessageBox.Show(res_str);
            });
        }

        private bool ImportFileData(string Type)
        {
            OpenFileDialog openFileDialog1 = new OpenFileDialog();
            openFileDialog1.Filter = "All files|*.*|Text File|*.txt|JSON File|*.json";
            openFileDialog1.DefaultExt = "txt";
            openFileDialog1.Title = "Open " + Type;
            openFileDialog1.ShowDialog();

            // If the file name is not an empty string open it for reading.
            if (openFileDialog1.FileName != "")
            {
                FileStream fs = (FileStream)openFileDialog1.OpenFile();
                using (StreamReader reader = new StreamReader(fs))
                {
                    string? line = reader.ReadLine();

                    if (line == null)
                    {
                        return false;
                    }

                    // Reset Content
                    if (Type.Equals("Accounts")) _ServiceCollection.GetDataService().ReSet_Data(line, DataType.ACCOUNT);
                    else if (Type.Equals("Sites")) _ServiceCollection.GetDataService().ReSet_Data(line, DataType.SITE);
                }
                return true;
            }

            return false;
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
                using (StreamWriter writer = new StreamWriter(fs))
                {
                    writer.Write(Data);
                }
                return true;
            }

            return false;
        }
    }
}
