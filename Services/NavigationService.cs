using Account_Manager.MVVM.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Account_Manager.Services
{
    public class NavigationService
    {
        private ViewModelBase? _CurrentViewModel;
        public ViewModelBase? CurrentViewModel { get => _CurrentViewModel; }
        public string? CurrentViewName { get; set; }

        public void Navigate(ViewModelBase ViewModelToLoad)
        {
            _CurrentViewModel = ViewModelToLoad;
            CurrentViewName = ViewModelToLoad.ViewName;

            OnCurrentViewModelChanged();
        }

        public event Action? CurrentViewModelChanged;

        private void OnCurrentViewModelChanged()
        {
            CurrentViewModelChanged?.Invoke();
        }
    }
}
