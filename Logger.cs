using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Account_Manager.Consts;

namespace Account_Manager
{
    public class Logger
    {
        public static void LogToConsole(bool ShowEveryNewLine = false, params string[] args)
        {
            foreach(string arg in args)
            {
                if(ShowEveryNewLine)
                    Console.WriteLine(arg);
                else
                    Console.Write(arg);
            }
        }

        public static void LogToFile(string PropertyType, string Message)
        {
            string CurrentTime = DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss.ff");
            string Log = $"{CurrentTime} -> [{PropertyType}] : {Message}\n";
            File.AppendAllText(Files.LOG_PATH, Log);
        }
    }
}
