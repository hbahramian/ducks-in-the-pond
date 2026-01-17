using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Markup.Xaml;
using Avalonia.Threading;
using System;
using System.Collections.Generic;

namespace DuckSimulator
{
    public partial class MainWindow : Window
    {
        private readonly List<Duck> ducks;
        private Duck? currentDuck;
        private DispatcherTimer? swimTimer;
        private DispatcherTimer? quackTimer;
        private Random random;
        private double duckX = 50;
        private double duckY = 150;
        private double velocityX = 2;
        private double velocityY = 1;

        public MainWindow()
        {
            InitializeComponent();
            random = new Random();
            
            ducks = new List<Duck>
            {
                new MallardDuck(),
                new RedheadDuck(),
                new RubberDuck(),
                new DecoyDuck()
            };

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
            SetupAnimationTimers();
        }

        private void InitializeComponent()
        {
            AvaloniaXamlLoader.Load(this);
        }

        private void SetupAnimationTimers()
        {
            // Swim animation timer - updates every 30ms for smooth movement
            swimTimer = new DispatcherTimer
            {
                Interval = TimeSpan.FromMilliseconds(30)
            };
            swimTimer.Tick += OnSwimTimerTick;
            swimTimer.Start();

            // Quack timer - quacks randomly every 2-5 seconds
            quackTimer = new DispatcherTimer
            {
                Interval = TimeSpan.FromSeconds(random.Next(2, 5))
            };
            quackTimer.Tick += OnQuackTimerTick;
            quackTimer.Start();
        }

        private void OnSwimTimerTick(object? sender, EventArgs e)
        {
            if (currentDuck == null) return;

            // Update duck position
            duckX += velocityX;
            duckY += velocityY;

            // Bounce off edges (pond boundaries: 500x300)
            if (duckX <= 10 || duckX >= 480)
            {
                velocityX = -velocityX;
            }
            if (duckY <= 10 || duckY >= 280)
            {
                velocityY = -velocityY;
            }

            // Update duck visual position
            var duckCanvas = this.FindControl<Canvas>("DuckCanvas");
            var duckText = this.FindControl<TextBlock>("DuckInPond");
            if (duckCanvas != null && duckText != null)
            {
                Canvas.SetLeft(duckText, duckX);
                Canvas.SetTop(duckText, duckY);
            }
        }

        private void OnQuackTimerTick(object? sender, EventArgs e)
        {
            if (currentDuck == null) return;

            // Show quack bubble
            var quackBubble = this.FindControl<TextBlock>("QuackBubble");
            if (quackBubble != null)
            {
                quackBubble.Text = currentDuck.Quack();
                quackBubble.IsVisible = true;
                
                Canvas.SetLeft(quackBubble, duckX + 30);
                Canvas.SetTop(quackBubble, duckY - 20);

                // Hide bubble after 1 second
                var hideTimer = new DispatcherTimer
                {
                    Interval = TimeSpan.FromSeconds(1)
                };
                hideTimer.Tick += (s, args) =>
                {
                    quackBubble.IsVisible = false;
                    hideTimer.Stop();
                };
                hideTimer.Start();
            }

            // Reset timer with random interval
            if (quackTimer != null)
            {
                quackTimer.Interval = TimeSpan.FromSeconds(random.Next(2, 5));
            }
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
                
                // Reset duck position to center
                duckX = 250;
                duckY = 150;
                
                // Random initial velocity
                velocityX = random.Next(-3, 3);
                if (velocityX == 0) velocityX = 2;
                velocityY = random.Next(-2, 2);
                if (velocityY == 0) velocityY = 1;
                
                UpdateDisplay();
                UpdateDuckInPond();
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

        private void UpdateDuckInPond()
        {
            if (currentDuck != null)
            {
                var duckText = this.FindControl<TextBlock>("DuckInPond");
                if (duckText != null)
                {
                    duckText.Text = currentDuck.GetEmoji();
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
