using Account_Manager.MVVM.Model;
using Account_Manager.Storage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Account_Manager.Services
{
    public class DataService
    {
        private LocalStorage _LocalStorage;

        public enum DataSource { Web, Local }

        public DataService(LocalStorage localStorage)
        {
            _LocalStorage = localStorage;
        }

        public bool Create_Data<T>(string _Type, T _Data, DataSource _DataSource)
        {
            try
            {
                switch (_DataSource)
                {
                    case DataSource.Local:
                        return _LocalStorage.CreateLocalData<T>(_Type, _Data);
                }

                return false;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public List<T> Read_Data<T>(string _Type, DataSource _DataSource)
        {
            try
            {
                switch (_DataSource)
                {
                    case DataSource.Local:
                        return _LocalStorage.ReadLocalData<T>(_Type);
                }

                return new List<T>();
            }
            catch (Exception ex)
            {
                return new List<T>();
            }
        }

        public bool Update_Data<T>(string _Type, T _Ref, T _Data, DataSource _DataSource) where T : ModelBase
        {
            try
            {
                switch (_DataSource)
                {
                    case DataSource.Local:
                        return _LocalStorage.UpdateLocalData<T>(_Type, _Ref, _Data);
                }

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool Delete_Data<T>(string _Type, T _Ref, DataSource _DataSource) where T : ModelBase
        {
            try
            {
                switch (_DataSource)
                {
                    case DataSource.Local:
                        return _LocalStorage.DeleteLocalData<T>(_Type, _Ref);
                }

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }


        public bool SetAuthData(string Key, string AuthPassword)
        {
            return _LocalStorage.SetAuthData(Key, AuthPassword);
        }

        public static AuthModel GetAuthData()
        {
            return LocalStorage.GetAuthData();
        }

        public bool UpdateEncryption(string Key, string SecureNewPassword)
        {
            return _LocalStorage.UpdateDataEncryption(Key, SecureNewPassword);
        }
    }
}
