using Account_Manager.Storage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Account_Manager.Services
{
    public class ServiceCollection
    {
        private NavigationService? _NavigationService;
        private CryptoService? _CryptoService;
        private DataService? _DataService;

        private LocalStorage? _LocalStorage;

        public ServiceCollection() {}

        public NavigationService GetNavService()
        {
            if( _NavigationService == null)
                _NavigationService = new NavigationService();
            return _NavigationService;
        }

        public CryptoService GetCryptoService()
        {
            if (_CryptoService == null)
                _CryptoService = new CryptoService();
            return _CryptoService;
        }

        public DataService GetDataService()
        {
            _LocalStorage = new LocalStorage(GetCryptoService());
            _DataService = new DataService(_LocalStorage);
            return _DataService;
        }
    }
}
