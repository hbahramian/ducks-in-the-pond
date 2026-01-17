using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Markup.Xaml;
using System.Collections.Generic;

namespace DuckSimulator
{
    public partial class MainWindow : Window
    {
        private readonly List<Duck> ducks;
        private Duck? currentDuck;

        public MainWindow()
        {
            InitializeComponent();
            
            ducks = new List<Duck>
            {
                new MallardDuck(),
                new RedheadDuck(),
                new RubberDuck(),
                new DecoyDuck()
            };

            // Set up the duck type selector
            var duckSelector = this.FindControl<ComboBox>("DuckSelector");
            if (duckSelector != null)
            {
                var items = new List<string>
                {
                    "Mallard Duck",
                    "Redhead Duck",
                    "Rubber Duck",
                    "Decoy Duck"
                };
                
                duckSelector.ItemsSource = items;
                duckSelector.SelectedIndex = 0;
            }

            SelectDuck(0);
        }

        private void InitializeComponent()
        {
            AvaloniaXamlLoader.Load(this);
        }

        private void OnDuckSelectionChanged(object? sender, SelectionChangedEventArgs e)
        {
            var comboBox = sender as ComboBox;
            if (comboBox?.SelectedIndex != null)
            {
                SelectDuck(comboBox.SelectedIndex);
            }
        }

        private void SelectDuck(int index)
        {
            if (index >= 0 && index < ducks.Count)
            {
                currentDuck = ducks[index];
                UpdateDisplay();
            }
        }

        private void UpdateDisplay()
        {
            if (currentDuck != null)
            {
                var displayText = this.FindControl<TextBlock>("DisplayText");
                if (displayText != null)
                {
                    displayText.Text = currentDuck.Display();
                }
            }
        }

        private void OnQuackClick(object? sender, RoutedEventArgs e)
        {
            if (currentDuck != null)
            {
                var output = this.FindControl<TextBlock>("OutputText");
                if (output != null)
                {
                    output.Text = "🔊 " + currentDuck.Quack();
                }
            }
        }

        private void OnSwimClick(object? sender, RoutedEventArgs e)
        {
            if (currentDuck != null)
            {
                var output = this.FindControl<TextBlock>("OutputText");
                if (output != null)
                {
                    output.Text = "🌊 " + currentDuck.Swim();
                }
            }
        }

        private void OnDisplayClick(object? sender, RoutedEventArgs e)
        {
            UpdateDisplay();
            var output = this.FindControl<TextBlock>("OutputText");
            if (output != null)
            {
                output.Text = "👀 Displaying duck appearance";
            }
        }
    }
}
