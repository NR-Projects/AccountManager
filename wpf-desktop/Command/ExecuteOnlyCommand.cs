using System;
using static AccountManager.Consts;

namespace AccountManager.Command
{
    public class ExecuteOnlyCommand : CommandBase
    {
        private readonly Action<object> _ActionToExecute;

        public ExecuteOnlyCommand(Action<object> action)
        {
            _ActionToExecute = action;
            Logger.LogToFile(PropertyType.COMMAND, "A Button has been Initialized");
        }

        public override void Execute(object parameter) => _ActionToExecute(parameter);
    }
}
