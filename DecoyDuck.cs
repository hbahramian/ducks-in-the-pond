namespace DuckSimulator
{
    public class DecoyDuck : Duck
    {
        public DecoyDuck()
        {
            QuackSound = "...*silence*...";
        }

        public override string Display()
        {
            return "🪵 I'm a Decoy Duck - wooden and still!";
        }
    }
}
