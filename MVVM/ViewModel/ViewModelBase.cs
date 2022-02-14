using Account_Manager.Services;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace Account_Manager.MVVM.ViewModel
{
    public abstract class ViewModelBase : INotifyPropertyChanged
    {
        protected  ServiceCollection _ServiceCollection;

        public event PropertyChangedEventHandler? PropertyChanged;
        public abstract string ViewName { get; }

        protected virtual void InitializeUI() { }

        public ViewModelBase(ServiceCollection serviceCollection)
        {
            // Initialize Services
            _ServiceCollection = serviceCollection;

            // Initalize UI
            InitializeUI();
        }

        protected virtual void OnPropertyChanged([CallerMemberName] string? propertyName = null) => PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));

        protected virtual bool SetProperty<T>(ref T storage, T value, [CallerMemberName] string propertyName = "")
        {
            if (EqualityComparer<T>.Default.Equals(storage, value)) return false;
            storage = value;
            OnPropertyChanged(propertyName);
            return true;
        }
    }
}
