using AccountManager.ViewModel;
using System;
using static AccountManager.Consts;

namespace AccountManager.Service
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
