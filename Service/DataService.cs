using AccountManager.Model;
using AccountManager.Storage;
using System;
using System.Collections.Generic;
using static AccountManager.Consts;

namespace AccountManager.Service
{
    public class DataService
    {
        private LocalStorage? _LocalStorage;

        public enum DataSource { Web, Local }

        public DataService()
        {
            _LocalStorage = new LocalStorage();
        }

        public bool Create_Data<T>(string _Type, T _Data, DataSource _DataSource)
        {
            try
            {
                switch (_DataSource)
                {
                    case DataSource.Local:
                        return _LocalStorage!.CreateLocalData<T>(_Type, _Data);
                }

                return false;
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.SERVICE, $"{ex.Message} >> {ex.StackTrace}");
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
                        return _LocalStorage!.ReadLocalData<T>(_Type);
                }

                return new List<T>();
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.SERVICE, $"{ex.Message} >> {ex.StackTrace}");
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
                        return _LocalStorage!.UpdateLocalData<T>(_Type, _Ref, _Data);
                }

                return true;
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.SERVICE, $"{ex.Message} >> {ex.StackTrace}");
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
                        return _LocalStorage!.DeleteLocalData<T>(_Type, _Ref);
                }

                return true;
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.SERVICE, $"{ex.Message} >> {ex.StackTrace}");
                return false;
            }
        }


        
        // Local
        public bool ReSet_Data(string _NewData, string _Type)
        {
            return _LocalStorage.ReSetData(_NewData, _Type);
        }



        // Auth-Related

        public static bool SetAuthData(string Salt, string HashedPassword)
        {
            return LocalStorage.SetAuthData(Salt, HashedPassword);
        }

        public static AuthModel GetAuthData()
        {
            return LocalStorage.GetAuthData();
        }

        public bool UpdateEncryption(string NewSalt, string NewPass)
        {
            return _LocalStorage!.UpdateDataEncryption(NewSalt, NewPass);
        }
    }
}
