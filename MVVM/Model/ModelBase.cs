using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Account_Manager.MVVM.Model
{
    public abstract class ModelBase
    {
        public abstract bool Equals(ModelBase Model);
    }
}
