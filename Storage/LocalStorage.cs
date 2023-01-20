using AccountManager.Model;
using AccountManager.Service;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;
using static AccountManager.Consts;

namespace AccountManager.Storage
{
    public class LocalStorage
    {
        private CryptoService _CryptoService;
        private enum FileWriteType { Write, Append, Clear }

        public LocalStorage()
        {
            _CryptoService = CryptoService.GetPrivService();
            GenerateLocalFileContents();
        }

        public void GenerateLocalFileContents()
        {
            // Initialize File Contents
            if (ReadDataFromFile(DataType.ACCOUNT).Length == 0)
                WriteDataToFile(DataType.ACCOUNT, FileWriteType.Write, "[]");
            if (ReadDataFromFile(DataType.SITE).Length == 0)
                WriteDataToFile(DataType.SITE, FileWriteType.Write, "[]");
        }

        public bool CreateLocalData<T>(string _DataType, T NewData)
        {
            try
            {
                // Pull Data List
                List<T>? DataList = JsonSerializer.Deserialize<List<T>>(ReadDataFromFile(_DataType));

                // Add New Data
                if (DataList != null && NewData != null)
                    DataList.Add(NewData);
                else
                    throw new NullReferenceException();

                // Put Back Data List
                return WriteDataToFile(_DataType, FileWriteType.Write, JsonSerializer.Serialize(DataList));
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.STORAGE, $"{ex.Message} >> {ex.StackTrace}");
                return false;
            }
        }
        public List<T> ReadLocalData<T>(string _DataType)
        {
            try
            {
                List<T>? Data = JsonSerializer.Deserialize<List<T>>(ReadDataFromFile(_DataType));

                if (Data != null)
                    return Data;
                throw new NullReferenceException();
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.STORAGE, $"{ex.Message} >> {ex.StackTrace}");
                return new List<T>();
            }
        }
        public bool UpdateLocalData<T>(string _DataType, T ReferenceData, T UpdatedData) where T : ModelBase
        {
            try
            {
                // Pull Data List
                List<T>? DataList = JsonSerializer.Deserialize<List<T>>(ReadDataFromFile(_DataType));

                if (DataList != null)
                {
                    for (int i = 0; i < DataList.Count; i++)
                    {
                        // Find Reference Data
                        if (DataList[i].Equals(ReferenceData))
                        {
                            // Change Data
                            DataList[i] = UpdatedData;
                            break;
                        }
                    }
                }
                else
                    throw new NullReferenceException();

                return WriteDataToFile(_DataType, FileWriteType.Write, JsonSerializer.Serialize(DataList));
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.STORAGE, $"{ex.Message} >> {ex.StackTrace}");
                return false;
            }
        }
        public bool DeleteLocalData<T>(string _DataType, T ReferenceData) where T : ModelBase
        {
            try
            {
                // Pull Data List
                List<T>? DataList = JsonSerializer.Deserialize<List<T>>(ReadDataFromFile(_DataType));

                if (DataList != null)
                {
                    for (int i = 0; i < DataList.Count; i++)
                    {
                        // Find Reference Data
                        if (DataList[i].Equals(ReferenceData))
                        {
                            // Delete Data
                            DataList.RemoveAt(i);
                            break;
                        }
                    }
                }
                else
                    throw new NullReferenceException();

                return WriteDataToFile(_DataType, FileWriteType.Write, JsonSerializer.Serialize(DataList));
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.STORAGE, $"{ex.Message} >> {ex.StackTrace}");
                return false;
            }
        }

        private static string GetFilePathFromDataType(string _DataType)
        {
            switch (_DataType)
            {
                case DataType.ACCOUNT:
                    return Files.ACCOUNTS_PATH;
                case DataType.SITE:
                    return Files.SITES_PATH;
                case DataType.AUTH:
                    return Files.AUTHENTICATION_PATH;
            }
            return "";
        }

        private bool WriteDataToFile(string _Type, FileWriteType _FileWriteType, string _Data = "")
        {
            try
            {
                _Data = _CryptoService.EncryptData(_Data);

                switch (_FileWriteType)
                {
                    case FileWriteType.Append:
                        File.AppendAllText(GetFilePathFromDataType(_Type), _Data);
                        break;
                    case FileWriteType.Write:
                        File.WriteAllText(GetFilePathFromDataType(_Type), _Data);
                        break;
                    case FileWriteType.Clear:
                        File.WriteAllText(GetFilePathFromDataType(_Type), string.Empty);
                        break;
                }

                return true;
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.STORAGE, $"{ex.Message} >> {ex.StackTrace}");
                return false;
            }
        }

        private string ReadDataFromFile(string _Type)
        {
            try
            {
                string FileData = File.ReadAllText(GetFilePathFromDataType(_Type));
                FileData = _CryptoService.DecryptData(FileData);
                return FileData;
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.STORAGE, $"{ex.Message} >> {ex.StackTrace}");
                return "";
            }
        }



        // Auth-Related

        public static bool SetAuthData(string Salt, string HashedPassword)
        {
            try
            {
                AuthModel appAuthModel = new AuthModel
                {
                    UserGenSalt = Salt,
                    HashedPass = HashedPassword
                };

                File.WriteAllText(GetFilePathFromDataType(DataType.AUTH), JsonSerializer.Serialize(appAuthModel));
                return true;
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.STORAGE, $"{ex.Message} >> {ex.StackTrace}");
                return false;
            }
        }
        public static AuthModel GetAuthData()
        {
            try
            {
                string FileData = File.ReadAllText(GetFilePathFromDataType(DataType.AUTH));
                AuthModel? authModel = JsonSerializer.Deserialize<AuthModel>(FileData);
                if (authModel == null)
                    throw new NullReferenceException();
                return authModel;
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.STORAGE, $"{ex.Message} >> {ex.StackTrace}");
                return new AuthModel();
            }
        }

        public bool UpdateDataEncryption(string NewSalt, string NewPass)
        {
            try
            {
                List<AccountModel>? AccountDataList = JsonSerializer.Deserialize<List<AccountModel>>(ReadDataFromFile(DataType.ACCOUNT));
                List<SiteModel>? SiteDataList = JsonSerializer.Deserialize<List<SiteModel>>(ReadDataFromFile(DataType.SITE));

                string NewHashedPass = _CryptoService.HashPassword(NewPass, NewSalt);
                SetAuthData(NewSalt, NewHashedPass);

                // Clear File Contents
                WriteDataToFile(DataType.ACCOUNT, FileWriteType.Clear);
                WriteDataToFile(DataType.SITE, FileWriteType.Clear);

                // ReInitialize CryptoService before writing
                _CryptoService.ReInitialize();
                _CryptoService.SetAccessKey(NewPass);

                // Write Data To File
                WriteDataToFile(DataType.ACCOUNT, FileWriteType.Write, JsonSerializer.Serialize(AccountDataList));
                WriteDataToFile(DataType.SITE, FileWriteType.Write, JsonSerializer.Serialize(SiteDataList));

                return true;
            }
            catch (Exception ex)
            {
                Logger.LogToFile(PropertyType.STORAGE, $"{ex.Message} >> {ex.StackTrace}");
                return false;
            }
        }
    }
}
