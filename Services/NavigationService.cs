using Account_Manager.MVVM.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Account_Manager.Consts;

namespace Account_Manager.Services
{
    public class NavigationService
    {
        private ViewModelBase? _CurrentViewModel;
        public ViewModelBase? CurrentViewModel { get => _CurrentViewModel; }
        public string? CurrentViewName { get; set; }

        public void Navigate(ViewModelBase ViewModelToLoad)
        {
            Logger.LogToFile(PropertyType.SERVICE, String.Join(' ', CurrentViewName, "Had Changed ViewModel to", ViewModelToLoad.ViewName));

            // Call OnExitView of Last ViewModel
            if (_CurrentViewModel != null)
                _CurrentViewModel.OnExitView();

            // Set New ViewModel
            _CurrentViewModel = ViewModelToLoad;

            // Set New ViewModel Name
            CurrentViewName = ViewModelToLoad.ViewName;

            // Call OnEnterView of Loaded ViewModel
            _CurrentViewModel.OnEnterView();

            // Call ViewModel Change
            OnCurrentViewModelChanged();
        }

        public event Action? CurrentViewModelChanged;

        private void OnCurrentViewModelChanged()
        {
            CurrentViewModelChanged?.Invoke();
        }
    }
}
