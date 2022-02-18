using Account_Manager.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Account_Manager.MVVM.ViewModel
{
    public class ModifySiteViewModel : ViewModelBase
    {
        public override string ViewName => "Modify Site";

        public ModifySiteViewModel(ServiceCollection serviceCollection) : base(serviceCollection)
        {
        }
    }
}
