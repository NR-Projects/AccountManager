namespace AccountManager.Model
{
    public abstract class ModelBase
    {
        public abstract bool Equals(ModelBase Model);
        public abstract override string ToString();
    }
}
