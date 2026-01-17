namespace DuckSimulator
{
    public class RubberDuck : Duck
    {
        public RubberDuck()
        {
            SwimAction = "Floating in the bathtub...";
            QuackSound = "Squeak!";
        }

        public override string Display()
        {
            return "🛁 I'm a Rubber Duck - squeaky and yellow!";
        }
        
        public override string GetEmoji()
        {
            return "🐥";
        }
    }
}
