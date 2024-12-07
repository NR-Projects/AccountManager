using AccountManager.Service;

namespace AccountManager.ViewModel
{
    public class MainViewModel : ViewModelBase
    {
        public override string ViewName => "Main";
        public ViewModelBase? CurrentViewModel
        {
            get
            {
                if (_ServiceCollection != null)
                    return _ServiceCollection.GetNavService().CurrentViewModel;
                return null;
            }
        }

        public string? CurrentViewName
        {
            get
            {
                if (_ServiceCollection != null)
                    return _ServiceCollection.GetNavService().CurrentViewName;
                return null;
            }
        }

        public MainViewModel(ServiceCollection serviceCollection) : base(serviceCollection)
        {
            _ServiceCollection.GetNavService().CurrentViewModelChanged += OnCurrectViewModelChanged;
        }

        private void OnCurrectViewModelChanged()
        {
            OnPropertyChanged(nameof(CurrentViewModel));
            OnPropertyChanged(nameof(CurrentViewName));
        }
    }
}
