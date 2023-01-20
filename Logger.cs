using System;
using System.IO;
using static AccountManager.Consts;

namespace AccountManager
{
    public class Logger
    {
        public static void LogToConsole(bool ShowEveryNewLine = false, params string[] args)
        {
            foreach (string arg in args)
            {
                if (ShowEveryNewLine)
                    Console.WriteLine(arg);
                else
                    Console.Write(arg);
            }
        }

        public static void LogToFile(string PropertyType, string Message, bool IncludeConsoleLogging = false)
        {
            string CurrentTime = DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss.ff");
            string Log = $"{CurrentTime} -> [{PropertyType}] : {Message}\n";

            if (IncludeConsoleLogging)
                LogToConsole(false, Log);

            File.AppendAllText(Files.LOG_PATH, Log);
        }
    }
}
