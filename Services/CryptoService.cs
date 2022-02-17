using Account_Manager.MVVM.Model;
using Account_Manager.Storage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Account_Manager.Services
{
    public class CryptoService
    {
        private string UserKey;                // Generated User Key when password is set
        private string AppHashedPassword;      // Hashed Password from Password Set
        private string AppRuntimeKey;           // Hardcoded App Key salted with RawPassword

        public CryptoService()
        {
            AuthModel authModel = DataService.GetAuthData();
            if (authModel != null)
            {
                UserKey = authModel.UserKey;
                AppHashedPassword = authModel.HashedPassword;
            }
            AppRuntimeKey = "";
        }

        public string GenerateKey()
        {
            return GenerateRandomString(16);
        }

        public bool CheckValidPassword(string RawEnteredPassword)
        {
            if (HashPassword(RawEnteredPassword).Equals(AppHashedPassword))
                return true;
            return false;
        }

        public string HashPassword(string Password, string Key = "")
        {
            string _Key = UserKey;

            if(Key != "")
                _Key = Key;

            // Add Key To Password
            Password += _Key;

            // Hash Password
            byte[] HashedBytes = SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(Password));
            string HashedString = BitConverter.ToString(HashedBytes).Replace("-", "");

            // Hash Again With App Key
            byte[] AuthPasswordBytes = SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(MixStrings(HashedString, _Key)));

            return BitConverter.ToString(AuthPasswordBytes).Replace("-", "");
        }

        public string SetAppRuntimeKey(string HardcodedAppKey, string RawPassword)
        {
            // Source: https://stackoverflow.com/a/51378661/11592761
            byte[] bytes = Encoding.UTF8.GetBytes(HardcodedAppKey + RawPassword);
            byte[] hash = SHA256.Create().ComputeHash(bytes);
            return Convert.ToBase64String(hash);
        }

        public string Encrypt(string PlainText)
        {
            byte[] IV = Encoding.ASCII.GetBytes(ResizeString(AppHashedPassword, 16));
            byte[] Key = Encoding.ASCII.GetBytes(AppRuntimeKey);
            byte[] Data = Encoding.ASCII.GetBytes(PlainText);

            Aes aes = Aes.Create();
            aes.Padding = PaddingMode.PKCS7;
            aes.Mode = CipherMode.CBC;
            aes.BlockSize = 128;
            aes.KeySize = 256;
            aes.Key = Key;
            aes.IV = IV;

            ICryptoTransform encryptor = aes.CreateEncryptor();
            byte[] encrypted_data = encryptor.TransformFinalBlock(Data, 0, Data.Length);

            encryptor.Dispose();
            aes.Dispose();

            return BitConverter.ToString(encrypted_data).Replace("-", "");
        }

        public string Decrypt(string CipherText)
        {
            byte[] IV = Encoding.ASCII.GetBytes(ResizeString(AppHashedPassword, 16));
            byte[] Key = Encoding.ASCII.GetBytes(AppRuntimeKey);
            byte[] Data = StringToByteArray(CipherText);

            Aes aes = Aes.Create();
            aes.Padding = PaddingMode.PKCS7;
            aes.Mode = CipherMode.CBC;
            aes.BlockSize = 128;
            aes.KeySize = 256;
            aes.Key = Key;
            aes.IV = IV;

            ICryptoTransform decryptor = aes.CreateDecryptor();
            byte[] decrypted_data = decryptor.TransformFinalBlock(Data, 0, Data.Length);

            decryptor.Dispose();
            aes.Dispose();

            return Encoding.ASCII.GetString(decrypted_data);
        }


        private string GenerateRandomString(int Length)
        {
            const string valid = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()_+[]{}|,.\\/<>?;:\'\"";
            StringBuilder res = new StringBuilder();

            while(Length-- > 0)
            {
                res.Append(valid[RandomNumberGenerator.GetInt32(valid.Length) % valid.Length]);
            }

            return res.ToString();
        }

        // Source: https://stackoverflow.com/a/9995303/11592761
        public static byte[] StringToByteArray(string hex)
        {
            if (hex.Length % 2 == 1)
                throw new Exception("The binary key cannot have an odd number of digits");

            byte[] arr = new byte[hex.Length >> 1];

            for (int i = 0; i < hex.Length >> 1; ++i)
            {
                arr[i] = (byte)(
                    ( GetHexVal(hex[i << 1]) << 4) +
                    ( GetHexVal(hex[(i << 1) + 1]))
                    );
            }

            return arr;
        }

        public static int GetHexVal(char hex)
        {
            int val = (int)hex;
            //For uppercase A-F letters:
            //return val - (val < 58 ? 48 : 55);
            //For lowercase a-f letters:
            //return val - (val < 58 ? 48 : 87);
            //Or the two combined, but a bit slower:
            return val - (val < 58 ? 48 : (val < 97 ? 55 : 87));
        }

        private string MixStrings(string str1, string str2)
        {
            string val = "";
            int length = 0;

            if (str1.Length != str2.Length)
                length = Math.Max(str1.Length, str2.Length);
            else
                length = str1.Length;

            for (int i = 0; i < length; i++)
            {
                if (i < str1.Length)
                    val += str1[i];
                if (i < str2.Length)
                    val += str2[i];
            }

            return val;
        }

        public string ResizeString(string CurrentString, int SetLength)
        {
            List<int> CharList = Enumerable.Repeat<int>(0, SetLength).ToList();
            string PaddedString = "", ReturnString = "";


            if(CurrentString.Length > SetLength || (CurrentString.Length*2) > (SetLength*2))
            {
                for(int i = 0; i < SetLength*2; i++)
                {
                    PaddedString += CurrentString[(i % CurrentString.Length)];
                }
            }

            for(int i = 0; i < PaddedString.Length; i++)
            {
                CharList[i%SetLength] += (int)PaddedString[i%SetLength];
            }

            for(int i = 0; i < SetLength; i++)
            {
                int CharNum = CharList[i];
                CharNum = (CharNum % 127);
                if (CharNum < 32) CharNum += 32;
                ReturnString += (char)CharNum;
            }

            return ReturnString;
        }
    }
}
