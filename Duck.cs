namespace DuckSimulator
{
    public abstract class Duck
    {
        public string QuackSound { get; protected set; } = "Quack!";
        public string SwimAction { get; protected set; } = "Swimming...";

        public virtual string Quack()
        {
            return QuackSound;
        }

        public virtual string Swim()
        {
            return SwimAction;
        }

        // Abstract method - each subtype must implement
        public abstract string Display();
    }
}
