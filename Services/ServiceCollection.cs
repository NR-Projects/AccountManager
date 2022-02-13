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

        public ServiceCollection() {}

        public NavigationService GetNavService()
        {
            if( _NavigationService == null)
                _NavigationService = new NavigationService();
            return _NavigationService;
        }
    }
}
