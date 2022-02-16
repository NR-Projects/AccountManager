using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Account_Manager.Consts;

namespace Account_Manager.Commands
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
