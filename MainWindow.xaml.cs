using Account_Manager.MVVM.ViewModel;
using Account_Manager.Services;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using static Account_Manager.Consts;

namespace Account_Manager
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private ServiceCollection serviceCollection = new ServiceCollection();

        public MainWindow()
        {
            Logger.LogToFile(PropertyType.VIEW, "-- Application Start --");
            serviceCollection.GetNavService().Navigate(new AuthViewModel(serviceCollection));
            DataContext = new MainViewModel(serviceCollection);

            InitializeAppFiles();

            InitializeComponent();
        }

        private void Window_MouseDown(object sender, MouseButtonEventArgs e)
        {
            DragMove();
        }

        private void Window_Close(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void Window_Minimize(object sender, RoutedEventArgs e)
        {
            WindowState = WindowState.Minimized;
        }

        protected override void OnClosed(EventArgs e)
        {
            base.OnClosed(e);
            Logger.LogToFile(PropertyType.VIEW, "-- Application End --");
        }

        private void InitializeAppFiles()
        {
            // Generate Folder
            Directory.CreateDirectory(Files.BASE_PATH);
            Directory.CreateDirectory(Files.TOOLS_PATH);

            // Generate Files
            if (!File.Exists(Files.APP_INFO_PATH))
                File.Create(Files.APP_INFO_PATH).Dispose();
            if (!File.Exists(Files.AUTHENTICATION_PATH))
                File.Create(Files.AUTHENTICATION_PATH).Dispose();
            if (!File.Exists(Files.ACCOUNTS_PATH))
                File.Create(Files.ACCOUNTS_PATH).Dispose();
            if (!File.Exists(Files.SITES_PATH))
                File.Create(Files.SITES_PATH).Dispose();

            // Generate Default Authentication: Default Password is 00000
            if (File.ReadAllText(Files.AUTHENTICATION_PATH).Length == 0)
            {
                string Key = new CryptoService().GenerateKey();
                string SecureDefaultPassword = new CryptoService().HashPassword("12345", Key);
                DataService.SetAuthData(Key, SecureDefaultPassword);
            }
        }
    }
}
