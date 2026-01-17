#!/bin/bash

# DuckSimulator Project Setup Script with Animation
echo "Creating DuckSimulator project in current directory..."



# Create Program.cs
cat > Program.cs << 'EOF'
using Avalonia;
using System;

namespace DuckSimulator
{
    class Program
    {
        [STAThread]
        public static void Main(string[] args) => BuildAvaloniaApp()
            .StartWithClassicDesktopLifetime(args);

        public static AppBuilder BuildAvaloniaApp()
            => AppBuilder.Configure<App>()
                .UsePlatformDetect()
                .LogToTrace();
    }
}
EOF

# Create App.axaml.cs
cat > App.axaml.cs << 'EOF'
using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Markup.Xaml;

namespace DuckSimulator
{
    public class App : Application
    {
        public override void Initialize()
        {
            AvaloniaXamlLoader.Load(this);
        }

        public override void OnFrameworkInitializationCompleted()
        {
            if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
            {
                desktop.MainWindow = new MainWindow();
            }
            base.OnFrameworkInitializationCompleted();
        }
    }
}
EOF

# Create App.axaml
cat > App.axaml << 'EOF'
<Application xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             x:Class="DuckSimulator.App">
    <Application.Styles>
        <FluentTheme />
    </Application.Styles>
</Application>
EOF

# Create Duck.cs
cat > Duck.cs << 'EOF'
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
        
        // Get the emoji representation of the duck
        public abstract string GetEmoji();
    }
}
EOF

# Create MallardDuck.cs
cat > MallardDuck.cs << 'EOF'
namespace DuckSimulator
{
    public class MallardDuck : Duck
    {
        public override string Display()
        {
            return "🦆 I'm a Mallard Duck - green head, brown body!";
        }
        
        public override string GetEmoji()
        {
            return "🦆";
        }
    }
}
EOF

# Create RedheadDuck.cs
cat > RedheadDuck.cs << 'EOF'
namespace DuckSimulator
{
    public class RedheadDuck : Duck
    {
        public override string Display()
        {
            return "🦆 I'm a Redhead Duck - red head, gray body!";
        }
        
        public override string GetEmoji()
        {
            return "🦆";
        }
    }
}
EOF

# Create RubberDuck.cs
cat > RubberDuck.cs << 'EOF'
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
EOF

# Create DecoyDuck.cs
cat > DecoyDuck.cs << 'EOF'
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
EOF

# Create MainWindow.axaml.cs
cat > MainWindow.axaml.cs << 'EOF'
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
EOF

# Create MainWindow.axaml
cat > MainWindow.axaml << 'EOF'
<Window xmlns="https://github.com/avaloniaui"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Class="DuckSimulator.MainWindow"
        Title="Ducks in the pond"
        Width="700" Height="600"
        Background="#F5F5F5">
    
    <StackPanel Margin="30" Spacing="20">
        <TextBlock Text="🦆 Ducks in the pond"
                   FontSize="24"
                   FontWeight="Bold"
                   HorizontalAlignment="Center"
                   Margin="0,0,0,20"/>
        
        <!-- Duck Pond -->
        <Border Background="#87CEEB"
                CornerRadius="8"
                Padding="5"
                BoxShadow="0 2 10 0 #20000000"
                Height="310">
            <Canvas Name="DuckCanvas"
                    Width="500"
                    Height="300"
                    Background="#4A90E2">
                
                <!-- Water ripples effect -->
                <Ellipse Fill="#6BB6FF" 
                         Opacity="0.3"
                         Width="80" 
                         Height="40"
                         Canvas.Left="100"
                         Canvas.Top="120"/>
                <Ellipse Fill="#6BB6FF" 
                         Opacity="0.3"
                         Width="60" 
                         Height="30"
                         Canvas.Left="300"
                         Canvas.Top="200"/>
                
                <!-- Duck -->
                <TextBlock Name="DuckInPond"
                           Text="🦆"
                           FontSize="32"
                           Canvas.Left="250"
                           Canvas.Top="150"/>
                
                <!-- Quack bubble (hidden by default) -->
                <Border Name="QuackBubble"
                        Background="White"
                        CornerRadius="15"
                        Padding="8,4"
                        IsVisible="False"
                        Canvas.Left="280"
                        Canvas.Top="130">
                    <TextBlock Text="Quack!"
                               FontSize="12"
                               FontWeight="Bold"/>
                </Border>
            </Canvas>
        </Border>
        
        <Border Background="White"
                CornerRadius="8"
                Padding="20"
                BoxShadow="0 2 10 0 #20000000">
            <StackPanel Spacing="15">
                <TextBlock Text="Select a Duck Type:"
                           FontSize="16"
                           FontWeight="SemiBold"/>
                
                <ComboBox Name="DuckSelector"
                          SelectionChanged="OnDuckSelectionChanged"
                          MinWidth="200"
                          FontSize="14"/>
                
                <TextBlock Name="DisplayText"
                           Text=""
                           FontSize="18"
                           TextWrapping="Wrap"
                           Margin="0,10,0,0"
                           Foreground="#2C5F2D"/>
            </StackPanel>
        </Border>
        
        <Border Background="White"
                CornerRadius="8"
                Padding="20"
                BoxShadow="0 2 10 0 #20000000">
            <StackPanel Spacing="15">
                <TextBlock Text="Duck Actions:"
                           FontSize="16"
                           FontWeight="SemiBold"/>
                
                <UniformGrid Columns="3" Rows="1" HorizontalAlignment="Stretch">
                    <Button Content="Quack 🔊"
                            Click="OnQuackClick"
                            Margin="0,0,5,0"
                            Padding="15,10"
                            FontSize="14"/>
                    
                    <Button Content="Swim 🌊"
                            Click="OnSwimClick"
                            Margin="5,0,5,0"
                            Padding="15,10"
                            FontSize="14"/>
                    
                    <Button Content="Display 👀"
                            Click="OnDisplayClick"
                            Margin="5,0,0,0"
                            Padding="15,10"
                            FontSize="14"/>
                </UniformGrid>
                
                <Border Background="#F0F8FF"
                        CornerRadius="4"
                        Padding="15"
                        Margin="0,10,0,0">
                    <TextBlock Name="OutputText"
                               Text="Watch the duck swim in the pond! 🌊"
                               FontSize="14"
                               TextAlignment="Center"
                               Foreground="#666"/>
                </Border>
            </StackPanel>
        </Border>
        
        <TextBlock Text="💡 The duck automatically swims around the pond and quacks randomly!"
                   FontSize="12"
                   TextWrapping="Wrap"
                   Foreground="#666"
                   FontStyle="Italic"/>
    </StackPanel>
</Window>
EOF

# Create README.md
cat > README.md << 'EOF'
# Duck Simulator - Avalonia Desktop App

This project demonstrates object-oriented strategy pattern using a Duck class hierarchy with animated swimming and quacking!

## Features
- 🦆 Animated ducks swimming in a pond
- 💬 Random quacking with speech bubbles
- 🎨 Different duck types with unique behaviors
- 🌊 Smooth animation with bouncing off pond edges

## Running in VS Code Dev Container

1. Open this folder in VS Code
2. Press F1 or Cmd+Shift+P
3. Select "Dev Containers: Reopen in Container"
4. Wait for the container to build
5. Open browser to http://localhost:6080 (password: vscode)
6. In the virtual desktop, open terminal and run:
   ```bash
   cd /workspaces/DuckSimulator
   export DISPLAY=:1
   dotnet run
   ```

## Class Structure

- **Duck** (abstract base class)
  - quack() - all ducks can quack
  - swim() - all ducks can swim
  - display() - abstract method, each subtype implements
  - getEmoji() - returns the emoji for the duck

- **MallardDuck** - Standard duck (🦆)
- **RedheadDuck** - Redhead duck (🦆)
- **RubberDuck** - Squeaky rubber duck (🐥) - squeaks instead of quacks!
- **DecoyDuck** - Silent wooden duck (🪵) - doesn't quack!

## Animation Details
- Ducks swim automatically using DispatcherTimer
- Random quacking every 2-5 seconds
- Smooth 30fps animation
- Bounces off pond boundaries
EOF

echo ""
echo "✅ Project created successfully with animated ducks!"
echo ""
echo "📁 Location: $(pwd)"
echo ""
echo "Next steps:"
echo "1. Open VS Code"
echo "2. File > Open Folder > Select the DuckSimulator folder"
echo "3. When prompted, click 'Reopen in Container'"
echo "4. Wait for container to build"
echo "5. Open browser to http://localhost:6080 (password: vscode)"
echo "6. In the virtual desktop terminal, run:"
echo "   cd /workspaces/DuckSimulator"
echo "   export DISPLAY=:1"
echo "   dotnet run"
echo ""
echo "🦆 Enjoy watching your ducks swim and quack!"
echo ""