using AccountManager.Service;
using AccountManager.ViewModel;
using System;
using System.IO;
using System.Windows;
using System.Windows.Input;
using static AccountManager.Consts;

namespace AccountManager
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private ServiceCollection serviceCollection;

        public MainWindow()
        {
            InitializeComponent();

            serviceCollection = new ServiceCollection();

            GenerateFnF();
            Logger.LogToFile(PropertyType.VIEW, "** Check For required Files and Folders **");

            Logger.LogToFile(PropertyType.VIEW, "-- Application Start --");
            StartApp();
        }

        private void StartApp()
        {
            serviceCollection.GetNavService().Navigate(new AuthViewModel(serviceCollection));
            DataContext = new MainViewModel(serviceCollection);
        }

        private void GenerateFnF()
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
            if (!File.Exists(Files.LOG_PATH))
                File.Create(Files.LOG_PATH).Dispose();

            // Generate Password If None
            // Generate Default Authentication: Default Password is 12345
            if (File.ReadAllText(Files.AUTHENTICATION_PATH).Length == 0)
            {
                string Salt = serviceCollection.GetCryptoService().GenerateSalt();
                string DefaultHashedPassword = serviceCollection.GetCryptoService().HashPassword("12345", Salt);
                DataService.SetAuthData(Salt, DefaultHashedPassword);
            }

            serviceCollection.GetCryptoService().ReInitialize();
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
    }
}
