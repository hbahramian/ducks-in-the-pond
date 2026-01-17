namespace DuckSimulator
{
    public class DecoyDuck : Duck
    {
        public DecoyDuck()
        {
            QuackSound = "...";
        }

        public override string Display()
        {
            return "🪵 I'm a Decoy Duck - wooden and still!";
        }
        
        public override string GetEmoji()
        {
            return "🪵";
        }
    }
}
