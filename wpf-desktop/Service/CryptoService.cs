using AccountManager.Model;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace AccountManager.Service
{
    public class CryptoService
    {
        // Make singleton
        private static CryptoService instance;
        public static CryptoService GetPrivService()
        {
            if (instance == null)
                instance = new CryptoService();
            return instance;
        }

        private CryptoService()
        {
        }

        private string UserGenSalt = "";        // Hash Salt (Auto-Gen)
        private string HashedPass = "";         // Hashed Password of User
        private string AccessKey = "";          // Combination of UserGenSalt, HashedPass, and UserPassword for Encryption and Decryption of Data

        public void ReInitialize()
        {
            LoadDataFromFile();
        }

        public string GenerateSalt()
        {
            return GenerateRandomString(16);
        }

        public bool CheckAuthentication(string InputRawPassword)
        {
            if (HashPassword(InputRawPassword, UserGenSalt).Equals(HashedPass))
                return true;
            return false;
        }

        public void SetAccessKey(string RawPassword)
        {
            string Mix1 = MixStrings(RawPassword, HashedPass);
            string Mix2 = MixStrings(Mix1, UserGenSalt);
            byte[] AccessKeyBytes = SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(Mix2));
            AccessKey = BitConverter.ToString(AccessKeyBytes).Replace("-", "");
        }

        public string EncryptData(string RawData)
        {
            return AES_Encrypt(RawData);
        }

        public string DecryptData(string EncryptedData)
        {
            return AES_Decrypt(EncryptedData);
        }

        public string HashPassword(string RawPassword, string Salt)
        {
            // Hash Password
            byte[] HashedBytes = SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(MixStrings(RawPassword, Salt)));
            string HashedString = BitConverter.ToString(HashedBytes).Replace("-", "");

            return HashedString;
        }


        private string AES_Encrypt(string PlainText)
        {
            byte[] encrypted;

            // Create an Aes object
            // with the specified key and IV.
            using (Aes aesAlg = Aes.Create())
            {
                aesAlg.IV = Encoding.ASCII.GetBytes(ResizeString(AccessKey, 16));
                aesAlg.Key = Encoding.ASCII.GetBytes(ResizeString(AccessKey, 16));

                // Create an encryptor to perform the stream transform.
                ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV);

                // Create the streams used for encryption.
                using (MemoryStream msEncrypt = new MemoryStream())
                {
                    using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
                        {
                            //Write all data to the stream.
                            swEncrypt.Write(PlainText);
                        }
                        encrypted = msEncrypt.ToArray();
                    }
                }
            }

            // Return the encrypted bytes from the memory stream.
            return BitConverter.ToString(encrypted).Replace("-", "");
        }

        private string AES_Decrypt(string CipherText)
        {
            // Declare the string used to hold
            // the decrypted text.
            string? plaintext = null;

            // Create an Aes object
            // with the specified key and IV.
            using (Aes aesAlg = Aes.Create())
            {
                aesAlg.IV = Encoding.ASCII.GetBytes(ResizeString(AccessKey, 16));
                aesAlg.Key = Encoding.ASCII.GetBytes(ResizeString(AccessKey, 16));

                // Create a decryptor to perform the stream transform.
                ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV);

                // Create the streams used for decryption.
                using (MemoryStream msDecrypt = new MemoryStream(StringToByteArray(CipherText)))
                {
                    using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                    {
                        using (StreamReader srDecrypt = new StreamReader(csDecrypt))
                        {

                            // Read the decrypted bytes from the decrypting stream
                            // and place them in a string.
                            plaintext = srDecrypt.ReadToEnd();
                        }
                    }
                }
            }

            return plaintext;
        }

        private string GenerateRandomString(int Length)
        {
            const string valid = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()_+[]{}|,.\\/<>?;:\'\"";
            StringBuilder res = new StringBuilder();

            while (Length-- > 0)
            {
                res.Append(valid[RandomNumberGenerator.GetInt32(valid.Length) % valid.Length]);
            }

            return res.ToString();
        }

        // Source: https://stackoverflow.com/a/9995303/11592761
        private byte[] StringToByteArray(string hex)
        {
            if (hex.Length % 2 == 1)
                throw new Exception("The binary key cannot have an odd number of digits");

            byte[] arr = new byte[hex.Length >> 1];

            for (int i = 0; i < hex.Length >> 1; ++i)
            {
                arr[i] = (byte)(
                    (GetHexVal(hex[i << 1]) << 4) +
                    (GetHexVal(hex[(i << 1) + 1]))
                    );
            }

            return arr;
        }

        private int GetHexVal(char hex)
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


            if (CurrentString.Length > SetLength || (CurrentString.Length * 2) > (SetLength * 2))
            {
                for (int i = 0; i < SetLength * 2; i++)
                {
                    PaddedString += CurrentString[(i % CurrentString.Length)];
                }
            }

            for (int i = 0; i < PaddedString.Length; i++)
            {
                CharList[i % SetLength] += (int)PaddedString[i % SetLength];
            }

            for (int i = 0; i < SetLength; i++)
            {
                int CharNum = CharList[i];
                CharNum = (CharNum % 127);
                if (CharNum < 32) CharNum += 32;
                ReturnString += (char)CharNum;
            }

            return ReturnString;
        }

        private void LoadDataFromFile()
        {
            AuthModel authModel = DataService.GetAuthData();
            if (authModel != null && authModel.UserGenSalt != null && authModel.HashedPass != null)
            {
                UserGenSalt = authModel.UserGenSalt;
                HashedPass = authModel.HashedPass;
            }
        }
    }
}
