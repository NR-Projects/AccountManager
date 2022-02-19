using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Account_Manager
{
    public class Consts
    {
        public class AppInfo
        {
            public const string VERSION = "v1.0.0";
            public const string APPKEY = "337589be032e8875ea5a452b6ee6a3f2606a7cf43b4ef57745a2fc0c528c49a6";
        }

        public class Files
        {
            public const string BASE_PATH = "C:\\TunaSalmon\\Account_Manager\\";

            public const string APP_INFO_PATH = BASE_PATH + "AppData.app";

            public const string TOOLS_PATH = BASE_PATH + "Tools\\";

            public const string AUTHENTICATION_PATH = TOOLS_PATH + "AppAuth.auth";
            public const string ACCOUNTS_PATH = TOOLS_PATH + "Accounts.dat";
            public const string SITES_PATH = TOOLS_PATH + "Sites.dat";

            public const string LOG_PATH = BASE_PATH + "Logs.txt";
        }

        public class DataType
        {
            public const string ACCOUNT = "Account";
            public const string SITE = "Site";
            public const string AUTH = "Auth";
        }

        public class DataSource
        {
            public const string OFFLINE = "Offline";
            public const string ONLINE = "Online";
        }

        public class PropertyType
        {
            public const string VIEW = "View";
            public const string VIEWMODEL = "ViewModel";
            public const string SERVICE = "Service";
            public const string STORAGE = "Storage";
            public const string COMMAND = "Command";
        }
    }
}
